## ActiveRecord::Relationに関して

1. ActiveRecord に対して Query Interface を呼び出すことができる
2. 呼び出した Query Interface は、ActiceRecord::Relation のインスタンスに蓄積される
3. 実際にデータが必要になったタイミングで SQL が発行される
  - 'to_a' メソッドが呼び出された時に SQL を任意のところで発行できる

## Scope とクラスメソッドの違い

- クラスメソッドは、値が返って来ないとに nil が返ってくる
- Scope は、結果が nil になった時、Scope の検索条件を除外した ActiveRecord::Relationを返す
