# Apache Arrow に関して学んだこと

## Apache ArrowによるRubyのデータ処理対応の可能性

- [Apache ArrowによるRubyのデータ処理対応の可能性](https://www.ipsj.or.jp/dp/contents/publication/49/S1301-S01.html) を読んでわからないことをピックアップして調べる

### Arrow フォーマット

- データ構造
  - テーブルデータを `RecordBatch` と呼ばれる構造で表現する
    - 1 つの Schema
    - 列と同数の配列
- 行指向のデータ配置と列指向のデータ配置
- CPU のキャッシュメモリと SIMD 命令
  - CPU のキャッシュメモリ
  - CPU の SIMD 命令

#### ワード補完: Arrow フォーマット

- キャッシュメモリとは
  - CPU と主記憶装置の橋渡しをしてくれる
  - 近年は CPU の内部に設置される
  - 下記のように何段階に分かれてキャッシュされる
    - 1 次キャッシュメモリ
    - 2 次キャッシュメモリ
    - 3 次キャッシュメモリ
- SIMD とは
  - SIMD(Single Instruction Multiple Data) 1 つの命令で複数のデータを同時に処理すること、もしくはその命令のこと

### Red Arrow

- C++ で実装されたライブラリのバインディングを開発する方針で Ruby で Apache Arrow を利用するエコシステムに参入できるようにする
- C++ のバインディングを実装する方法
  - バインディングをで書きする方法
  - SWIG のような仕組みで自動生成する方法
- Red Arrow では
  - C 言語ようのバインディングを作成し、Ruby バインディングを動的生成する方法をとった
  - C 言語ようのバインディングは Glib を利用
  - Ruby バインディングの動的生成には、GObject Introspection を利用

#### ワード補完: Red Arrow

- SWIG とは
  - SWIG(Simplified Wrapper Interface Generator)
  - 既存の C or C++ で実装されたコードに対応するインターフェースファイルを作ると SWIG が自動でラッパーを作ってくれる
  - ラッパーも合わせで Build し直すことで、Ruby から呼び出せるようにできる
- Glib とは
  - クロスプラットフォームのユーティリティライブラリの一種
  - 異なる CPU や OS 間の差異を吸収してくれる

- GObject Introspection とは
  - C 言語で書かれたライブラリーを各種スクリプト言語から言語バインディングを書かずに使える機能を提供するライブラリー

## エコシステム

### Apache Arrow Flight SQL

- SQL データベースでインメモリにカラムなーフォーマットを利用できるようにするためのクライアントサーバのプロトコル
- JDBC or ODBC のような既存の API に似た仕組みを提供したい
  - クエリの実行、ステイトメントの作成やメタ情報の取得など
- Flight SQL は、他の API やフォーマットと異なり、アクセスする際にカラムナー形式に変換する工程をスキップできるようにする
- Flight SQL は Flight RPC フレームワークをフルで利用できるようにする

#### ワード補完: Apache Arrow Flight SQL

- JDBC
  - Java Database Connectivity (JDBC) AP
- ODBC
  - Open Database Connectivity (ODBC)
- Flight RPC
  - 高速なデータトランスポートを実現するための新しいクライアント・サーバー型のフレームワーク
  - gRPC を利用した Arrow 列指向フォーマットのトランスポートに最適化している
  - 並列転送機能に重きをおく

##### 参考資料

- [Apache Arrow Flightの紹介：高速データトランスポートフレームワーク](https://arrow.apache.org/blog/2019/10/13/introducing-arrow-flight-japanese/)

### Apache Arrow DataFusion

- DataFusion は、インメモリで Apache Arrow を利用した拡張可能なクエリ実行フレームワーク
- 合理的なクエリプランを構築するための SQL と　データフレーム APIを提供する
  - さらに、パーティション分けされた CSV や Parquet のデータに対して並列実行可能なエンジンやクエリオプティマイザーを備えている

### DuckDB

- 軽量で高速な OLAP である
  - データベースには大きく分けて OLTP と OLAP が存在する
- OLTP
  - Online Transaction Processing: オンライントランザクション処理
- OLAP
  - Online Analtyical Processing: オンライン分析処理
