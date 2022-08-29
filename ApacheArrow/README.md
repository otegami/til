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

- SWIG とは
  - SWIG(Simplified Wrapper Interface Generator)
  - 既存の C or C++ で実装されたコードに対応するインターフェースファイルを作ると SWIG が自動でラッパーを作ってくれる
  - ラッパーも合わせで Build し直すことで、Ruby から呼び出せるようにできる
- Glib とは
  - クロスプラットフォームのユーティリティライブラリの一種
  - 異なる CPU や OS 間の差異を吸収してくれる

- GObject Introspection とは
  - C 言語で書かれたライブラリーを各種スクリプト言語から言語バインディングを書かずに使える機能を提供するライブラリー
