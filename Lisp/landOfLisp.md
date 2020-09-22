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

## 第 4 章 条件と判断

- この章では、Lisp の条件分岐について紹介した。その過程で次のようなことを学んだ。
  - Common Lisp では、式 nil、'nil、()、'()の値は全て同じである。
  - Lisp では空リストかどうかを調べるのが簡単だ。そのためリストを頭から食べてゆく関数を簡潔
に書ける。
  - if等の Lisp の条件式は、条件に合致した部分の式しか評価しない。
  - 条件式でいろんなことを一度にやりたければ、condが使える。
  - Lisp でもの同士を比較するやり方はいくつもあるけれど、原則としてシンボルを比べる時は eqを、 それ以外のものを比べる時は equalを使う、と覚えておけば良い。

### nil と　()　の対称性

#### 空と偽なり

```lisp
(if '()
  'i-am-true
  'i-am-false
)
```

```lisp
(if '(1)
  'i-am-true
  'i-am-false
)
```

```lisp
(defun my-length (list)
  (if list
    (1+ (my-length (cdr list)))
    0
  )
)
(my-length '(list with four symbols))
```

#### () の四つの顔

```lisp
(eq '() nil)
(eq '() ())
(eq '() 'nil)
```

- nil と () は、例外的にデータとして扱われている
  - 本来は、「'」が先頭についてる時にデータとして扱われるため

#### if

```lisp
(if (= (+ 1 2) 3)
  'yup
  'nope
)

(if (= (+ 1 2) 4)
  'yup
  'nope
)

(if (oddp 5)
  'odd-number
  'even-number
)
```

- if の場合、関数呼び出しされたときに全てが一度に評価されるているわけではない

```lisp
(if (oddp 5)
  'odd-number
  (/ 1 0)
)
```

#### progn

```lisp
(defvar *number-was-odd* nil)

(if (oddp 5)  
  (progn (setf *number-was-odd* t)
    'odd-number
  )
  'even-number
)
```

#### when

```lisp
(defvar *number-was-odd* nil)

(when (oddp 5)
  (setf *number-was-odd* t)
  'odd-number
)
```

#### unless

```lisp
(unless (oddp 4)
  (setf *number-is-odd* nil)
  'even-number
)
```

#### cond

```lisp
(defvar *arch-enemy* nil)
(defun pudding-eater (person)
  (cond
    (
      (eq person 'henry)
        (setf *arch-enemy* 'stupid-lisp-alien)
        '(curse you lisp alien - you ate my pudding)
    )
    (
      (eq person 'johnny)
        (setf *arch-enemy* 'unless-old-johnny)
        '(i hope you choked on my pudding johnny)
    )
    (
      t
        '(why you eat my pudding stranger?)
    )
  )
)
```

#### case

```lisp
(defun pudding-eater (person)
  (case person
    (
      (henry)
        (setf *arch-enemy* 'stupid-lisp-alien)
        '(curse you lisp alien - you ate my pudding)
    )
    (
      (johnny)
        (setf *arch-enemy* 'unless-odd-johnny)
        '(i hope you chocked on my pudding johnny)
    )
    (
      otherwise
        '(why you eat my pudding stranger?)
    )
  )
)
```

### ちょっとした条件分岐のテクニック

#### and と or を使う

```lisp
(and (oddp 5)(oddp 7)(oddp 9))
```

```lisp
(or (oddp 4)(oddp 7)(oddp 8))
```

```lisp
(defparameter *is-it-even* nil)

(or (oddp 4)(setf *is-it-even* t))
```

```lisp
(defparameter *is-it-even* nil)

(or (oddp 5)(setf *is-it-even* t))
```

```lisp
(if (and *file-modified*(ask-user-about-saving))
  (save-file)
)
```

- 真偽値を返す目的を持つ式だけを条件のところに入れている
- 返す値の質を揃えること大切です

```lisp
(if (member 1 '(3 4 1 5))
  'one-is-in-the-list
  'one-is-not-in-the-list
)
```

```lisp
(member 1 '(3 4 1 5))
```

```lisp
(if (member nil '(3 4 nil 4))
  'nil-is-in-the-list
  'nil-is-not-in-the-list
)
```

```lisp
(find-if #'oddp '(2 4 5 6))
```

```lisp
(if (find-if #'oddp '(2 4 5 6))
  'there-is-an-odd-number
  'there-is-no-odd-number
)
```

```lisp
(find-if #'null '(2 4 nil 6))
```

- 上記の中から　nil の値を無事に取り出していても、この値を if に含めると偽になってしまうので、直感に反してしまう可能性がある

### 比較関数 :q、equal、そしてもっと

- 少なくともひどい Lisp コードを書いたかどにより鍬と鎌でベテラン Lisper から街を追い出されるなんて羽目にはならないだろう。

```lisp
(defparameter *fruit* 'apple)
```

```lisp
(cond
  (
    (eq *fruit* 'apple)
      'its-an-apple
  )
  (
    (eq *fruit* 'orange)
      'its-an-orange
  )
)
```

#### eq と equal の違い

- Ruby で例えると
  - eq は、「===」
  - equal は、「==」

```lisp
(eq (list 1 2 3)(list 1 2 3))
=> NIL
```

```lisp
(equal (list 1 2 3)(list 1 2 3))
=> T
```

#### eql > equal

```lisp
(eql 3.4 3.4)
```

- 文字列について大文字小文字の使い方が異なるものを比較
- 整数と浮動小数点数を比較

## 第 5 章テキストゲームのエンジンを作る

- 好きな言葉
  - あなたの MacBook を脳に直結して思考を流し込めるその日まで

### 5-1 魔法使いのアドベンチャー

#### このゲームの世界

#### 基本的な要求仕様

- 周囲を見渡す
- 別の場所へ移動する
- オブジェクトを拾う
- 拾ったオブジェクトで何かする

#### 連想リストを使って景色を描写する

```lisp
(
  defparameter *nodes* '(
    (
      living-room (
        you are in the living-room.
        a wizzard is snoring loudly on the couch.
      )
    )
    (
      garden (
        you are in a beautiful garden.
        there is a well in front of you.
      )
    )
    (
      attic (
        you are in the attic.
        there is a giant welding torch in the corner.
      )
    )
  )
)
```

#### 情景を描写する

```lisp
(assoc 'garden *nodes*)
```

```lisp
(defun describe-location (location nodes)
  (cadr(
    assoc location nodes
  ))
)
```

#### 5-2 通り道を描写する

```lisp
(defparameter *edges* '(
    (living-room
        (garden west door)
        (attic upstairs ladder)
    )
    (garden
        (living-room east door)
    )
    (attic
        (living-room downstairs ladder)
    )
  )
)
```

```lisp
(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.)
)
```

```lisp
(describe-path '(garden west door))
```

#### 準クォートの仕組み

#### 複数の通り道を一度に描写する

```lisp
(defun describe-paths (location edges)
  (apply #'append
    (mapcar #'describe-path
      (cdr
        (assoc location edges)
      )
    )
  )
)
```

- いや、読んで何をしているのかは、わかったよ。でも複雑じゃない？もっと感覚的に、てかオブジェクトとして書きたいよ。

#### 描写を統合する

```lisp
(append '(mary had)'(a)'(little lamb))
```

```lisp
(apply #'append '((mary had)(a)(little lamb)))
```

### 5-3 特定の場所にあるオブジェクトを描写する

#### 目に見えるオブジェクトをリストする

```lisp
(defparameter *objects* '(whisky bucket frog chain))
```

```lisp
(defparameter *object-locations* '(
  (whiskey living-room)
  (bucket living-room)
  (chain garden)
  (frog garden)
))
```

```lisp
(defun object-at (loc objs obj-locs)
  (labels ((at-loc-p (obj)
        (eq (cadr (assoc obj obj-locs)) loc)))
    (remove-if-not #'at-loc-p objs)
  )
)
```

#### 見えるオブジェクトを描写する

```lisp
(defun describe-objects (loc objs obj-loc)
  (labels ((describe-obj (obj)
    `(you see a ,obj on the floor.)))
    (apply #'append (mapcar #'describe-obj (object-at loc objs obj-loc)))
  )  
)
```

### 5-4 全てを描写する

```lisp
(defparameter *location* 'living-room)
```

```lisp
(defun look ()
  (append
    (describe-location *location* *nodes*)
    (describe-paths *location* *edges*)
    (describe-objects *location* *objects* *object-locations*)
  )
)
```

### 5-5 ゲーム世界を動き回る

```lisp
(defun walk (direction)
  (let (
    (next (find direction
      (cdr (assoc *location* *edges*))
      :key #'cadr)))
    (if next
      (progn (setf *location* (car next))
        (look)
      )
      '(you cannot go that way.)
    )
  )
)
```

- シンボル yを cadrに持つような最初の要素をリストから探し出す
