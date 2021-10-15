# Production Ready GraphQL

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
- https://www.thoughtworks.com/insights/blog/bff-soundcloud

## Enter GraphQL

GraphQL とは、
API query 言語であり、それを実行できるサーバーのエンジンである

The type system of a GraphQL engine is
often referred to as the schema.
