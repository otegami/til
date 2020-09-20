# Land Of Lisp

## 2 章

- グローバル変数を定義するには defparameterを使う。
  - グローバル関数を定義するには、defunコマンドを使う。
  - ローカル変数と関数を定義するには、それぞれ letと fletを使う。
  - labelsは fletと似ているが、ローカル関数が自分自身を呼ぶことができる。自分自身を呼び出す 関数は再帰関数と呼ばれる

- let と　flet の違いは？
  - let はローカル変数を定義できる
  - flet はローカル関数も定義できる

- flet と　labels の違いは？
  - 再帰関数
    - labels は定義されたローカル変数を他のローカル変数内でも使える

### guess-my-number

- ash((+ 1 100) -1)
- 101

```ruby
> 101.to_s(2)
=> "1100101"

> 0b1100101
```

```lisp
ash((+ 1 100) -1)
=> 110010
```

### ローカル変数の定義する

```lisp
> (
    let(
      (a 5)
      (b 6)
    )
    (+ a b)
  )
```
```lisp
(flet (
  (f (n)
    (+ n 10)))
  (f 5))
)
 (flet ((f (n)
(+ n 10)))
(f 5))
```
```lisp
(
  flet (
    (f (n)
      (+ n 10)
    )
    (g (n)
      (- n 3)
    )
  )
  (g (f 5))
)
```
```lisp
(
  labels (
    (a (n)
      (+ n 5)
    )
    (b (n)
      (+ (a n) 6)
    )
  )
  (b 5)
)
```

- カッコが大量で見づらいよぉ

## 第三章　シンタックス

- Lisp の括弧は、シンタックスを最小限に保つためにある。
  - リストはコンスセルから作られる。
  - consコマンドでコンスセルを作ってゆくことで、リストが構成される。
  - carと cdrを使ってリストの中身を調べることができる。
    - 配列っぽいイメージを持っている

### シンボル

```lisp
(eq 'fooo 'FoOo)
```

### 数値

- 浮動小数点によって、整数は「汚染され」てしまう

```lisp
(+ 1 1.0)
```

```lisp
(expt 53 53)
```

```lisp
(/ 4 6)
```

- 有理数で答えを返す　like 2/3

```lisp
(/ 4.0 6)
```

- 小数点を含んだ値を返す

### 文字列

```lisp
(princ "Tutti Frutti")
```

```lisp
(princ "He yelled \"Stop that thief\" from the busy street.")
```

### コードモード

```lisp
(expt 2 (+ 3 4))
```

- (expt) : コードは、フォームと呼ばれる構造のリストになっている
- expt : フォームでは、最初の要素が特別なコマンドになっている

### データモード

```lisp
'(expt 2 3)
```

- ' : 先頭にシングルクォートあると、それ以降はデータだと認識する

### Lisp とリスト

```lisp
(expt 2 3)
```

### コンスセル

```lisp
'(1 2 3)

```

- リストは、コンスセルでつなぎ合わされている。
- 上記は三つのコンスセルから作られている
  - 1 と次のセル
  - 2 と次のセル
  - 3 と nil(次のセルがないため)
- それぞれのセルは、数値とリストの次のセルを指している 

#### cons 関数

```lisp
(cons 'chicken 'cat)
```

```lisp
(cons 'chicken 'nil)
```

```lisp
(cons 'chicken ())
```

```lisp
(cons 'beef (cons 'chicken()))
```

```lisp
> (cons 'pork (cons 'beef (cons 'chicken ())))
(eq (PORK BEEF CHICKEN) (pork . (beef . (chicken . ()))))
```

#### car と cdr

- セルの最初のスロットにあるデータを取り出すのに使う

```lisp
> (car '(pork beef chicken))
PORK
```

- セルの二番目のスロットにあるデータを取り出すのに使う

```lisp
> (cdr '(pork beef chicken))
(BEEF CHICKEN)
```

- 二番目のセルの最初のスロットの値を取り出す

```lisp
> (cadr '(pork beef chicken))
```

#### list

- コンスセルを一つずつ作る必要がなく長いリストを作成することができる

```lisp
> (list 'pork 'beef 'chicken)
```

- なんで？リストを作る話の流れになったんだろう？
- Lisp の構造の話から切り替わってる
- 配列みたいなもの？

#### list の操作をしてみよう

```lisp
> (cdr (car '((peas carrots tomatoes) (pork beef chicken))))
> 

> (cdar '((peas carrots tomatoes) (pork beef chicken)))
```
