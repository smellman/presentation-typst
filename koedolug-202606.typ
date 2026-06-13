#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "小江戸らぐ 2026年6月")

// タイトルスライド
#title-slide(
  title: "bandcampsync で音楽を同期する",
  subtitle: "Bandcamp で買った音源をローカルに集約する",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 6, day: 13)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - 一般社団法人OpenStreetMap Foundation Japan (OSMFJ) 理事
  - 一般社団法人OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - 株式会社Geolonia GISエンジニア
]

#section-slide("最近の話")

// OLL Awards 受賞
#content-slide(title: "OLL Awards 受賞")[
  - OLL Awards を受賞しました。
  #figure(
    image("assets/images/oll_awards.jpg", width: 20%)
  )
  - 受賞記念講演: #link("https://www.docswell.com/s/smellman/ZJW86J-2026-05-28-oll-awards-2025")
]

// 地理院地図3次元地図
#content-slide(title: "国土地理院「3次元地図可視化サイト」が試験公開")[
  - 国土地理院「3次元地図可視化サイト」が試験公開されました
  - Geoloniaによる告知： #link("https://www.geolonia.com/archives/6803/")
  - 僕が業務を担当しました。がんばったでー
]

// セクション: 背景
#section-slide("さて、本題。まずは背景")

// Bandcampとは
#content-slide(title: "Bandcamp とは")[
  - アーティスト直販型の音楽配信プラットフォーム
  - 売上の大半がアーティストに還元される仕組み
  - *DRMフリー* でロスレス（FLAC/ALAC等）を含む高音質配信
  - 一度購入すれば *何度でもダウンロード可能*
  - インディーズ・電子音楽・同人音楽との相性が良い
]

// なぜローカルに同期したいか
#content-slide(title: "なぜローカルに同期したいのか")[
  - Bandcampのページから *毎回ポチポチDLするのが面倒*
  - 購入数が増えてくると、何を落として何を落としてないか分からなくなる
  - 新しくLinuxをセットアップしたのでLinuxでも音楽を聞きたい
  - 配信サービスが消えてもローカルに音源が残る安心感
  - 「買った音源は自分のもの」を物理的に担保したい
]

// 課題
#content-slide(title: "公式機能だけだと辛い")[
  - Bandcampの購入履歴ページから1アルバムずつ手動ダウンロード
  - フォーマットを選んでZIPで降ってくる
  - 解凍して、アーティスト/アルバム名のフォルダに振り分ける作業
  - 既にDL済みかどうかは自分で覚えておく必要あり
  - → 数百枚レベルになると現実的ではない
]

// セクション: bandcampsync
#section-slide("bandcampsync")

// 概要
#content-slide(title: "bandcampsync")[
  - GitHub: #link("https://github.com/meeb/bandcampsync")
  - Python製のCLIツール（Dockerイメージも公式提供）
  - Bandcampの *購入済みアイテムを丸ごとローカルに同期*
  - 差分検出付きなので、新しく買ったものだけが落ちてくる
  - 依存: `beautifulsoup4` / `curl-cffi`
  - ライセンス: AGPL-3.0
]

// 動作フロー
#content-slide(title: "動作の流れ")[
  + エクスポートしたセッションクッキーで認証
  + ローカルの同期先ディレクトリをスキャン
  + Bandcampの *コレクション（購入履歴）* をインデックス化
  + 未ダウンロードのアイテムを抽出
  + ZIPをダウンロード → 解凍 → 所定のディレクトリに配置
]

// 動作環境
#content-slide(title: "動作環境")[
  - CachyOS
    - ArchLinuxベースのディストリビューション
    - 先月紹介されてたものを早速導入
  - python-uv パッケージを導入
]

// インストール
#content-slide(title: "インストール")[
  - uv でインストール:
    ```sh
    mkdir test-bandcampsync
    cd test-bandcampsync
    uv init
    uv add bandcampsync
    ```
]

// セクション: 認証
#section-slide("認証 (cookies.txt)")

// クッキーの取得
#content-slide(title: "セッションクッキーの取得")[
  - bandcampsync は *ブラウザのセッションクッキー* で認証する
  - 公式APIではないので、ログイン後のCookieをそのまま使う方式
  + ブラウザで bandcamp.com にログイン
  + 開発者ツール (F12) → ネットワークタブを開く
  + 任意のページのリクエストを選択
  + リクエストヘッダの `Cookie` 値をコピーして `cookies.txt` に保存
]

// クッキーの取り扱い注意
#content-slide(title: "cookies.txt の取り扱い")[
  - *このファイルは事実上のログイン情報そのもの*
  - 漏れるとアカウントを乗っ取られる
  - `chmod 600 cookies.txt` などで権限を絞る
  - クラウドストレージへの同期対象から外す
  - 公式ドキュメントにも明示的に警告あり
]

// セクション: 使い方
#section-slide("使い方")

// 基本コマンド
#content-slide(title: "基本コマンド")[
  - 最小構成の実行例:
    ```sh
    mkdir tmp
    uv run bandcampsync -c cookies.txt -d /path/to/music -t tmp/
    ```
  - `-c` … cookies.txt のパス
  - `-d` … 同期先ディレクトリ
  - `-t` …temp directory (指定なしで/tmp)
  - デフォルトは *FLAC* (ロスレス) で取得
  - 既に `bandcamp_item_id.txt` がある項目はスキップされる
]

// フォーマット指定
#content-slide(title: "ダウンロードフォーマット")[
  - `--format` で指定可能
  - 主な選択肢:
    - `flac` (デフォルト・ロスレス)
    - `alac` / `aiff-lossless` (Apple系ロスレス)
    - `mp3-v0` (可変ビットレート)
    - `mp3-320` (高音質MP3)
    - `aac-hi` (Apple系AAC)
]

// その他のオプション
#content-slide(title: "便利なオプション")[
  - `--ignore` … 特定アーティストをスキップ
  - `--ignore-file` … スキップ対象をファイルで管理
  - `--concurrency` … 並列ダウンロード数（デフォルト 1）
  - `--notify-url` … 完了時に外部URLへ通知
    （Webhook等と組み合わせて Slack / Discord に通知できる）
]

// 出力ディレクトリ構造
#content-slide(title: "同期後のディレクトリ構造")[
  ```
  /media/Artist Name/Album Name/
    ├─ bandcamp_item_id.txt   # 差分検知用
    ├─ cover.jpg
    └─ 01 Track Name.flac
  ```
  - アーティスト名 / アルバム名のフォルダに整理される
  - `bandcamp_item_id.txt` がbandcamp上のIDを保持
  - → 次回実行時に「これは既にある」と判定できる
]

// セクション: 運用
#section-slide("運用してみての所感")

// メディアサーバとの連携
#content-slide(title: "メディアサーバとの連携")[
  - bandcampsync側は「DL済かどうか」しか気にしないので、
    後段でフォルダを動かしても壊れにくい設計
]

// ハマりポイント
#content-slide(title: "ハマりやすいポイント")[
  - WiFiによって接続が安定しないケースがある
  - 時期によって極端に遅い時もある
  - 一度全件落としてしまえば、以降は差分のみで軽い
  - リリースによっては/tmp(tmpfs)の容量を越えてしまうので注意
    - flacはでかい
]

// まとめ
#content-slide(title: "まとめ")[
  - Bandcampの購入音源を *自動でローカル同期* できるCLIツール
  - 認証はセッションクッキー方式、cookies.txt の管理だけ要注意
  - FLACなどロスレスでまとめて取得可能
  - 「買った音源は自分のもの」を運用で担保したい人におすすめ
]
