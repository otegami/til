# GraphQL に関して学んだこと

## 命名規則

- GraphQL は、サーバーAPI に対して利用する
  - DB とのやりとりをするわけではない

### Query or Mutation の命名

- Query
  - リソース名（名詞）が好ましい
- Mutation
  - addStar(動詞 + 名詞) が好ましい
    - createStart|InsertStart などは DB とのやりとりを想定した名前になってしまうので好ましくない

### 引数や返値の型の命名

- 引数: Mutation の名前 + Input
- 返値: Mutation + Payload

## Relay 各仕様解説

### Global Object Identification

- リソースの垣根を超えて、一意な ID を付与することで、リソースの特定が容易になる

```graphql
query node(id: :node_id)
```

- 例: MDEyOk9yZ2FuaXphdGlvbjEzNDIwMDQ=
  - 012:Organization1342004
  - 何か + リソース識別 + レコード ID
- ID は知っているけど、対象のリソースがわからない時に役立つ

### Pagination

今更だけど、pagination の仕組みをきちんと理解できていないので、別途学んでから改めて読む必要ありそう

### Input Object Mutations

- Mutation 時に Input で追加した情報を返す形にする
- 返値の結果を別の型にする必要があるので、下手に肩情報を流用して混乱を招くことがなくなる

### キャッシュ対応

何もフロント側でキャッシュできていないと思う

### ページネーションの実装について

- 何件のデータが欲しいか
- フィルタの条件は何か
- データの参照方向は、順方向|逆方向か
- どのデータからの続きが欲しいか

### スキーマ設計の実践と考察
