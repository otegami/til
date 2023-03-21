# RubyKaigi 2022 after event for Fast data processing with Ruby and Apache Arrow

ref: https://www.youtube.com/watch?v=bpuJWC9_USY

## RedArrow とは
- Apache Arrow の C++ 実装を利用できるようにしたバインディング

### Chunked Array とは
- Apache Arrow が扱うのは表形式のデータになる
  - 各カラムのことを Array と呼んでいる
  - ここでいう Array とは Ruby でいう Array とは違う
- Large data(Big data)を扱う
  - メモリに乗り切らないくらい
^ 上記のデータをインメモリで対応したいのが Apache Arrow
ストリーム処理で対応することでインメモリで実現できる

配列とは連続した領域に入ったデータのことを指す
Ruby の配列
- VALUE(ポインター)が入っている
  - Ruby の C でいう Ruby Object が入っている
  - Ruby の配列は参照するためのデータは連続しているが、実際の参照先のデータは連続しているとは限らない
  - Ruby の数値は、VALUE（ポインター）ではなく、値をそのまま埋め込んでいる
    - 例えば、1 が数値そのものなのか or 1 という場所にある Ruby Object を指すのかわかりづらい
    - 下位数ビットにフラグを立てて差異を表している
  - どちらにせよ、数値を計算できる値に戻す必要があるので、時間がかかってしまう
- 巨大な連続した配列を用意しようとするとインメモリで制御できない
  - なので、ストリームで処理する必要がある

Chunked Array
- 1つのカラムを物理的には複数の配列で表すが、論理的には、1 つの配列として扱うようにしている

Q: 他の言語では、Chunked Array などの低レイヤーを意識しないで扱えるのですか？

A: 他の言語では低レイヤーを扱えるライブラリーが存在する
- Python: pandas
  - PyArrow: Python bindings
  - ^ pandas 側で利用できるように変換する機能を提供している（可能ならゼロコピー）
- R: dplyer
  - CRAN(R の RubyGems みたいな立ち位置)
  - arrow: Apache Arrow R
  - dplyer のバックエンドとして利用できるようになっている
    - 既存の API を利用しているが、実際は Apache Arrow の機能を利用している

つまり他の言語では、他のライブラリ経由で使うようになっている

- Ruby に pandas のような高級な API は存在するのか

Chunked Array は誰のためのものなのか？
- ユーザーが意識しないで良いようにしている

例えば
Apache Arrow 内部では、Table と Record Batch で表形式のデータを扱う
Table: 各カラムは Chunked Array で表される
- メモリに乗り切らないデータを扱える
RecordBatch: Red Arrow 側ではこちらを操作する API を用意している
- メモリにのりきるサイズのデータを表す
- 複数の RecordBatch から Table が形成されている

Ruby: RedAmber バックエンド側を切り替える
- Red Arrow など使える

Table に対してジェネリックな API を提供したい
- Active Record のように、表形式のデータを統一的に扱えるようにしたい
- Red Table Query

API としては Sequel がよくできている
- Filter など
- https://sequel.jeremyevans.net/

LINQ: C# でテーブル形式のデータを扱える

Python DBI
- 統一的にデータベースにアクセスできるようの API
- PEP でしようとして決められている

## Red Arrow から Apache Arrow C++ までのレイヤー

Red Arrow
- 新機能: 便利 API
  |
Ruby GObject Introspection: jobject-introspectation gem
- Ruby レベルの API を提供
  |
C API と GObject Introspection API
  |
Apache Arrow C GLib: C
- C++ の API を C っぽくマッピングしている
  |
Apache Arrow C++: C++

速さが必要なのは、C++ レイヤーで実装されている
便利さがあるのは、Ruby レイヤーで実装されている
- Arrow::Table.load/Arrow::Table#save

Partition 機能
- 複数のデータを小分けにした論理的なデータを読み込むなど
- C++ 側では実装されているが現状は、まだラッパーが用意されていない

## 
Apache Arrow Dataset とは
- 複数のデータを統一的に扱える
  - パーティション機能はここで実装されている
- 複数のデータを混ぜられる
- ストリーム処理を扱える
  - Local File 
  - Remote Storage
  - HDFS(Hadoop FileSystem)
  - S3
  - CCS
  - Azure Blob Storage
