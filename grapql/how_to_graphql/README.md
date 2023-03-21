## graphql-ruby Tutorial - Introduction
下記で学んだこと理解したことのメモ
- https://www.howtographql.com/graphql-ruby/0-introduction/

### What is a GraphQL Server?
GraphQL Server ができるべきこと
- GraphQl フォーマットのリクエストを受け取れる
  - 受け取った後に抽象構文木に分解する工程があるはず
- データベースやサービスにデータを保存や取得するためにアクセスする
  - 接続部分の設定を忘れずに行う必要がある
  - Rails でいう database.yml 的な感じかな
- リクエストされたデータと一緒にレスポンスを返す
- リクエストをバリデーションできる、スキーマーの定義によって

### Schema-Driven Development
1. 定義するよ〜　Type, Query と Mutation
2. 関数を定義するよ Resolvers を操作するためにね Type と Fields
3. 新しい用件がきたら最初からまた繰り返す感じ
