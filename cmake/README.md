# CMake をどうやって使うのか？
[Groonga開発者に聞け！（グルカイ！）第50回](https://www.youtube.com/watch?v=XPP_5gbf4zc)を聞いて学んだことをメモする

## ビルド時にディレクトリを指定するのはなぜ？
最近は、ソースディレクトリとビルドディレクトリを分けるのが主流である
- そのため cmake で configuration するときはディレクトリを指定する必要がある
  - `cmake -S source_dir -B build_dir`

## Generator って何？
- CMake を利用したら最終的には、実行ファイルやライブラリーができる

昔は、configure->make->実行ファイルだけだった
現在は、make 意外にもいくつかビルドシステムがある
- make
- Ninja(by C++)
- Samurai(Ninja の再実装 by C)
  - 入力は一緒である

CMake はクロスプラットフォーム対応している
- Windows: Visual Studio: .xml(make とやる仕事)
- Xcode

make の代替はあるが、ユーザーとしては詳細は知りたいくない
=>差異は CMake に吸収させるので CMake だけ覚えてね！
  - ビルドようのファイルを生成するよ！
  - make の役割を担うモジュール達を Generator と呼んでいる

CMake 用の設定ファイルを書く際も各 Generator の差異を意識しなくても描けるようになっている

## preset とは？
環境や目的によってビルド対象を変えたい
cmake -DXXX -DXXX みたいな形でオプションを指定できるが、それをユースケース毎に一纏めにして指定できるのが preset である
- 注意点: 新しい機能なので古い環境では使えないよ

## CMakeLists.txt って何もの？
CMake の独自言語があり、それで書かれたプログラム
- make の場合はルールに縛られた設定ファイル

環境検出プログラムを書いているイメージでいると良い
- 最近流行りの Meson も同じ気持ちである


- cmake .
- Generator って何？
- preset って何？

