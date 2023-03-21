# [Production Ready GraphQL](https://book.productionreadygraphql.com/)

## Let’s Go Back in Time

### 問題

- クエリパラメーターに対応できるように、API をかつては用意する必要があった

```
GET api/products?version=mobile
GET api/products?partial=full
```

- 上の状態が続いていくと対応すべき項目が増えて、メンテナンスが大変になってしまう

### 解決

リソースごとではなく、要望に適したエンドポイントを作成して、それを既存のエンドポイントとの間に挟むことで新しい層を作ろうとした
=> BFF(Backend For Frontend)

- <https://www.thoughtworks.com/insights/blog/bff-soundcloud>

## Enter GraphQL

GraphQL とは、
API query 言語であり、それを実行できるサーバーのエンジンである

The type system of a GraphQL engine is
often referred to as the schema.

## Client First

GraphQL は、クライアント中心の API です。

- バックエンドがわのリソースを起点に考えては行けない
- 何よりもまず、クライアントのユースケースを先に考えること
- 実装に寄り添ったスキーマの設計をしてはいけない
- スキーマは機能の入り口なだけである
  - うまく言語化できない＞＜

## Design Query

- 引数を複数取ることで、クライアント側が直感的に利用し辛い、引数にない値をわたす可能性もある
- 冗長に感じても、クライアント側のユースケースに応じて、API を作ると良い
- 必須項目にすることで、必ず必要な情報であることを示せる
- 型を作ることで、フォーマットを明示的に指定することができる（クレジットカードや電話番号など）
- 組み合わせで整合性取りたい部分は型に寄せてあげると良い

## Custom Connection Fields

- edges { node } パターンを利用する場合は、必ず両方を利用するようにすること（利用ユーザーが混乱するため）

## Sharing Types

- 実際には意味合いが異なる場合に、Type をシェアしてしまうことがある

## Nullability

- Null or Non-Null を選択した意図を説明できるようにすること
- Non-Null
  - クライアント側に必ず必要なペアなどを知らせることで、API の利用方法を知らせることができる
  - 例えば、決済の際のクレジットカードの番号と有効期限が必ず必要など
- Null
  - 柔軟に他のノードに含めることができる
  - ^後で利用用途をより明確にしたい

## Abstract Types

- TypeScript でいう interface 的な感じかな？

## Union or Interface?

- Interface
  - 振る舞いを共有する時に利用する
- Union
  - 特定のフィールドが、複数の Type を返す際に利用する

## Don’t Overuse Interfaces

- 行動や振る舞いを提供するのが良い Interface である
- 持っているデータやあり方を共通化して持たせるものではない

```graphql
# bad
interface ItemInterface
interface ItemFileds
interface ItemInfo

type CartItems
type CheckoutItems
type OrderItems
```

- ソートする方法が異なったり、クライアント側で異なる振る舞い(機能)を持つため、後に混乱をうむ

## Abstract Types and API Evolution

- API を変更するときは、クライアント側の実装にも気を遣ってください
  - 特に新しい Type を利用する時など

## Designing for Static Queries

- 動的に Query を作らないこと
  - フロント側から送られてきた Query を調査しずらいこと
  - Runtime 時に毎回形が変更される可能性があるため

## Mutations

### Input and Payload types

- Mutation の戻り値には Payload type を設定しよう
  - 戻り値に特定の値を付与することもできるよ
- Mutation の引数には、Input type を利用しよう
  - 常に引数を一つで表すことができて、わかりやすいよ

```graphql
type Mutation {
  createProduct(input: CreateProductInput!) {
    CreateProductPayload
  }
}

type CreateProductPayload {
  product: Product
  successful: Boolean!
}

input CreateProductInput {
  name: String!
  price: Money!
}
```

### Fine-Grained or Coarse-Grained

- GraphQL の mutation を action ごとに作成するのが良い
- 問題
  - ネットワークを多く使ってしまうので、パフォーマンスの問題
  - 言語による実装の問題など
- 課題
  - どの粒度で mutation を作成するべきなのか

## Errors

### Errors as data

```graphql
type ResultPayload {
  userErrors: [UseError!]!
  post: Post
}

type UserError {
  message: String!
  field: [String!]!
  code: UserErrorCode
}
```

### Union / ResultTypes

- エラー情報が schema からもわかりやすい

```graphql
type Mutation {
  signUp(email: string!, password: String!): SignUpPayload
}
union SignUpPayload =
  SignUpSuccess |
  UserNameTaken |
  PasswordTooWeak
```

## Schema Organization

### Namespaces

### Mutation

```graphql
# not bad
type productCreate
type cartProductAdd

# better
type createProduct
type addProductToCart
```

- アクションを示すわかりやすい形で書くと良いよ
- 昔は、検索性の問題もあり `productCreate` と書いていた

### Asynchronous Behavior

### Data-Driven Schema vs Use-Case-Driven Schema

- 多くの場合は、use cases ベースでうまくいく
- 大量のデータなどが必要なときは、deta driven で設計したい場合があるかもしれないが、エッジケースなので、Bluk 系の機能を利用すれば解決できる

### Asynchronous GraphQL Jobs

### Summary

- ドメイン情報に適した形で実装すること
  - 実装の部分には目を向けないこと
- スキーマーは、クライアントのユースケースによって設計すること、データ情報などは考慮しないこと
- スキーマーはユーザーが利用しやすいようにすること
  - ドキュメントは、あるのが好ましい！
- 共通化などを無理にしないこと

## GraphQL Server Basics

- GrapQL Server に必要なもの
  - 型システムの定義
  - 型システムによるリクエストされたクエリの実行エンジン
  - クエリの文字列と変数を受け取る HTTP server

- User: 型システムの定義と実行時の振る舞いを考慮する
- Library: GraphQL の実行アルゴリズムなどを提供する

### Code First vs Schema First

### Resolver Design

- GraphQL は、 API のインターフェースである
- ドメインとビジネスロジックへのインターフェースである

- Best Practice
  - かなり少ないコードであること
  - ユーザーの入力項目に対応する
  - ドメインレイヤーを呼ぶ
- Resolver Pattern

## Schema Metadata

## Multiple Schemas

### Schema Visibility

- context の現在のユーザーから、特定の schema にアクセスできるか権限管理する
  - Pundit に任せるのも良さそう

### Modular Schemas

### Summary

- GraphQL layer は可能な限り薄くしよう
- ロジックは domain layer にうつそう
- resolver も可能な限りシンプルにしよう
- モジュール化するときは、外部のフレームワークを活用しよう、個人でやるのは難しい
- テストは、domain layer でやろう、GraphQL の integration test があると好ましい

## Security

### Exposing Rate Limits

- limitation 情報は、extension に記述しよう
  - 毎回 limit 情報などを 定義するのは Dry じゃないため

### Blocking Abusive Queries

### Timeouts

### Authentication

- Authorization
  - GraphQL layer で行っても自然である

### Leaking Existence

### Blocking Introspection

### Persisted Queries

- query をキャッシュしてしまおう
  - 毎回 query string を送るのは大変だし、バックエンド側も実行するコストがかかるため

### Summary

- Rate limit をかけよう
- Timeout を設定しよう
- query の深さは制限しよう
- Authorization は、フィールで行わず型側で対応しちゃおう

## Performance & Monitoring

### Per-Field Monitoring & Tracing

- GraphQL Lifecycle
  - Parsing & Lexing
  - Validation & Static Analysis
    - validation がボトルネックな時も意外にあるよ
  - Execution
    - 実行部分が、ボトルネックだとは限らない

- graphql-ruby では、performance の計測する際は下記が良さそう
  - [prometheus](https://github.com/rmosolgo/graphql-ruby/blob/master/guides/queries/tracing.md#prometheus)

## The N+1 Problem and the Dataloader Pattern

### Caching

### GraphQL breaks server-side caching

### HTTP Caching

### GraphQL & HTTP Caching

### Summary

- REST API のように最適化？するのは難しい
- エンドポイントのレスポンスではなくて、フィールドのレスポンスをみる必要がある
- N+1 問題は、遅延ロードで対応できる
- GraphQL でキャッシュすることはできるが、既存の API ほど強力ではない

## Tooling

### Linting

- GraphQL Doctor

### Change Management

### Analytics

## Workflow

### Design
