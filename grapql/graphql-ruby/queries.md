## Root Value

トップレベルで object を指定することができる
- https://graphql-ruby.org/queries/executing_queries.html
```ruby
current_org = session[:current_organization]
MySchema.execute(query_string, root_value: current_org)
```

```ruby
class Types::MutationType < GraphQL::Schema::Object
  field :create_post, Post, null: true

  def create_post(**args)
    object # => #<Organization id=456 ...>
    # ...
  end
end
```

## Phases of Execution
全体の流れを知ることで、どこでエラーが出てるのか分割して考えられそう

Tokenize: GraphQL::Language::Lexer splits the string into a stream of tokens
- ここでいう token って何だろう？
Parse: GraphQL::Language::Parser builds an abstract syntax tree (AST) out of the stream of tokens
- token から抽象構文木を作成する
Validate: GraphQL::StaticValidation::Validator validates the incoming AST as a valid query for the schema
- 正しいクエリかをスキーマと照らし合わせて確認する
Analyze: If there are any query analyzers, they are run with GraphQL::Analysis.analyze_query
- クエリを分析する: クエリの状態によっては特別な処理を挟める
Execute: The query is traversed, resolve functions are called and the response is built
- resolve を実行して、レスポンスを構築する
Respond: The response is returned as a Hash
- レスポンスを Hash として返す

## Backtrace

実行時の状態を可視化できる（デバックに便利そう）
```ruby
puts context.backtrace
# Loc  | Field                         | Object       | Arguments             | Result
# 3:13 | User.login                    | #<User id=1> | {"message"=>"Boom"}   | #<RuntimeError: This is broken: Boom>
# 2:11 | Query.user                    | nil          | {"login"=>"rmosolgo"} | {}
# 1:9  | query                         | nil          | {"msg"=>"Boom"}       |
```

## Instrumentation
クエリ実行時の前後に処理を挟むことができる

```ruby
class MySchema < GraphQL::Schema
  instrument(:query, QueryTimerInstrumentation)
end
```

```ruby
module QueryTimerInstrumentation
  module_function

  # Log the time of the query
  def before_query(query)
    Rails.logger.info("Query begin: #{Time.now.to_i}")
  end

  def after_query(query)
    Rails.logger.info("Query end: #{Time.now.to_i}")
  end
end
```
