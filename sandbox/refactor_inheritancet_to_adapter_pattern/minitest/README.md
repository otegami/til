# How the minitest executes test cases

## とりあえず現時点での結論
継承をうまく利用している現状の minitest の構造を活かしつつ Adapter Pattern に対応させるようにすると
minitest の構造を深く知った実装になりそうなので、この方針は難しそうな気がしている

## 読んだ過程

- README.md を読んでみる
	- そんなに長くないため
	- RATIONALE:
		- See design_rationale.rb to see how specs and tests work in minitest.
		- ここをみたらどう動いているのかわかりそう！
- だいたい読めたので次に行く
- design_rationale.rb を読んでみる
	- 特に参考にならなかった
- `require "minitest/autorun"`の秘密を暴く

```
# This is the top-level run method. Everything starts from here. It
# tells each Runnable sub-class to run, and each of those are
# responsible for doing whatever they do.
#
# The overall structure of a run looks like this:
#
#   Minitest.autorun
#     Minitest.run(args)
		=> ここで Repoter や Options を渡している
#       Minitest.__run(reporter, options)
#         Runnable.runnables.each
          => 任意のテストクラス < Minitest::Test < Runnable を継承
          => こちらのユーザーが定義した任意のテストクラスが返される
#           runnable.run(reporter, options)
　　　　　　　 => Runnable.run が呼ばれる
#             self.runnable_methods.each
			  => test_ で始まるメソッド群に対して each を回す
#               self.run_one_method(self, runnable_method, reporter)
#                 Minitest.run_one_method(klass, runnable_method)
                  => ここで初めて Minitest 側から Runnable#run が呼ばれてテストが実行される
#                   klass.new(runnable_method).run
```

個人的な疑問は、どのように実行するテストケースを判断しているのだろうか？
- method なのはわかるが、自身の継承先にいる Class のメソッドをとるみたいなことしてるのかな？

```ruby
def self.__run reporter, options
  suites = Runnable.runnables.shuffle # <= Runnable Class を継承しているものになる
  ## => こいつは何をやっているの？流せるものをシャッフルしてる？
  parallel, serial = suites.partition { |s| s.test_order == :parallel }
  ## 並列に実行できるものとそうでないもので partition している

  # If we run the parallel tests before the serial tests, the parallel tests
  # could run in parallel with the serial tests. This would be bad because
  # the serial tests won't lock around Reporter#record. Run the serial tests
  # first, so that after they complete, the parallel tests will lock when
  # recording results.
  serial.map { |suite| suite.run reporter, options } +
    parallel.map { |suite| suite.run reporter, options }
　end
```

```ruby
class Runnable
	def self.runnables
	  @@runnables
	  ## ^ えーどのタイミングで入れられるんだ？
	end
end
```

下記のように `Minitest::Test`が継承された時に登録される
- 下記のように Runnable が継承された時に登録する仕組みをつけているのだ！

```ruby
class Runnable # re-open
  def self.inherited klass # :nodoc:
    self.runnables << klass
    ## ^ どうやらここで入れられているらしい
    ## どのタイミングで継承されているんだ？
    super
  end
end
```

```ruby
module Minitest
	class Test < Runnable
		def self.inherited klass
			self.runables << klass 
			## ^ 上記が Runnable から継承した部分になるのだ！
		end
	end
end
```

つまり `@@runnables` には継承を行ったクラス群が入る構造になっている

本題に戻ります
```ruby
serial.map { |suite| suite.run reporter, options } +
  parallel.map { |suite| suite.run reporter, options }
end
```
上記の部分で、`@runables` に登録された Minitest::Test を継承したクラスに対して run を実行します
- 但し、実行するには `reporter` と `options`を渡してあげます
	- reporter に関しては、options を一部利用した Minitest 内の class である
	- options に関しては、実行時に渡された環境変数になっている

```ruby
##
# Responsible for running all runnable methods in a given class,
# each in its own instance. Each instance is passed to the
# reporter to record.

def self.run reporter, options = {}
  # 今回は filter option を与えていないシンプルな例を見ていく
  filtered_methods = if options[:filter]
    filter = options[:filter]
    filter = Regexp.new $1 if filter.is_a?(String) && filter =~ %r%/(.*)/%

    self.runnable_methods.find_all { |m|
      filter === m || filter === "#{self}##{m}"
    }
  else
    # ここで返されるのって何かな？
    # 正規表現で `test_` で始まるメソッドを引っ掛けて取得している
    self.runnable_methods
  end

  # ここも option で無視されているので気にしなくて OK
  if options[:exclude]
    exclude = options[:exclude]
    exclude = Regexp.new $1 if exclude =~ %r%/(.*)/%

    filtered_methods.delete_if { |m|
      exclude === m || exclude === "#{self}##{m}"
    }
  end

  # 何も定義されてない時はスルーされる
  return if filtered_methods.empty?

　
  with_info_handler reporter do
    # メソッド名と reporter を渡してメソッドを実行してくれている
    filtered_methods.each do |method_name|
      run_one_method self, method_name, reporter
    end
  end
end
```

```ruby
class Minitest::Test
	def self.runnable_methods
	  methods = methods_matching(/^test_/) # public_instance_methods(true).grep(re).map(&:to_s)
	
	  case self.test_order
	  when :random, :parallel then
	    srand Minitest.seed
	    methods.sort.shuffle
	  when :alpha, :sorted then
	    methods.sort
	  else
	    raise "Unknown test_order: #{self.test_order.inspect}"
	  end
	end
end
```

```ruby
class Runnable
	def self.run_one_method klass, method_name, reporter
	  reporter.prerecord klass, method_name
	  # 主体はここに存在する
	  reporter.record Minitest.run_one_method(klass, method_name)
	end
end
```

```ruby
class Minitest
	def self.run_one_method klass, method_name # :nodoc:
	  # 継承していた Test Class 自体を呼ぶようにしている
	  # なぜ initialize 時に method_name を呼べるんだ？
	  result = klass.new(method_name).run
	  raise "#{klass}#run _must_ return a Result" unless Result === result
	  result
	end
end
```

```ruby
class Runnable
	def initialize name # :nodoc:
      self.name       = name
      self.failures   = []
      self.assertions = 0
      # lazy initializer for metadata
    end
end
```

```ruby
class Runnable
	def run
		raise NotImplementedError, "subclass responsibility"
	end
end

class Test < Runnable
	def run
	  with_info_handler do
	    time_it do
	      capture_exceptions do
		    # SETUP_METHODS = %w[ before_setup setup after_setup ] # :nodoc:
	        SETUP_METHODS.each do |hook|
	          self.send hook
	        end

            # ここで初めて テストメソッドが実行される
            # -> メソッド内の assertion 周りは別途見ることにする
	        self.send self.name
	      end

          # TEARDOWN_METHODS = %w[ before_teardown teardown after_teardown ] # :nodoc:
	      TEARDOWN_METHODS.each do |hook|
	        capture_exceptions do
	          self.send hook
	        end
	      end
	    end
	  end
	
	  Result.from self # per contract
	end
end
```
