#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "小江戸らぐ 2026年2月")

// タイトルスライド

#title-slide(
  title: "Claude Codeでプレゼンテーションを作成する",
  subtitle: "Typstを学習させる",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 2, day: 14)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - OpenStreetMap Foundation Japan (OSMFJ) 理事
  - OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - 株式会社Geolonia GISエンジニア
]

// Geolonia Inc.について
#content-slide(title: "Geolonia Inc.")[
  - 地図プラットフォームを提供するGIS企業
  - 住所正規化API・地図タイルなどのサービスを展開
  - OpenStreetMapやオープンデータを活用した地理空間技術に強み
  - 2026年2月より *AI First Company* へ転換
  - GIS × AIで地理空間データの新たな活用を推進
]

// セクション: Typst + Claude Code
#section-slide("Typst + Claude Code")

// Typstとは
#content-slide(title: "Typstとは")[
  - Rust製の新しい組版システム
  - LaTeXの代替を目指して開発
  - マークアップとスクリプティングを統合した独自構文
  - コンパイルが高速でリアルタイムプレビューが可能
  - Polyluxパッケージでプレゼンテーション作成にも対応
]

// Claude Codeとは
#content-slide(title: "Claude Codeとは")[
  - Anthropic社が提供するCLIベースのAIコーディングエージェント
  - ターミナル上で対話しながらコード生成・編集が可能
  - ファイルの読み書き・コマンド実行・Git操作を自律的に実行
  - CLAUDE.mdにプロジェクトのルールを記述して制御
  - 今まさにこのプレゼンテーションもClaude Codeで作成中
]

// このプレゼンテーションについて
#content-slide(title: "このプレゼンテーションについて")[
  - タイトルスライド以外は *すべてClaude Codeが生成*
  - テーマファイル(theme/theme.typ)もClaude Codeが作成
  - 人間がやったのは日本語で指示を出すことだけ
  - 「自己紹介スライドを追加」「Typstの説明を追加」など
  - スライドの追加・修正・ビルドまで一貫して自動実行
]

// Claude Codeの使い方
#content-slide(title: "Claude Codeの基本的な使い方")[
  + macOS: `brew install --cask claude`
  + Linux: `curl -fsSL https://claude.ai/install.sh | bash`
  + プロジェクトディレクトリで `claude` を実行
  + 自然言語で指示を入力するだけ
  + CLAUDE.mdにルールを書くと規約に従ったコードを生成
]

// 実際に使ったプロンプト例
#content-slide(title: "実際に使ったプロンプト例")[
  - 「テーマを作成」
  - 「自己紹介のスライドを追加」
  - 「Geolonia Inc.についての説明を追加。特に今月からAI First Companyとなることを強調」
  - 「Typstについての説明スライドを追加してください」
  - 「brewでインストールしたのでそれに合わせてください。Linuxではcurl...も追記」
]

// OpenAI Codexとの比較
#content-slide(title: "OpenAI Codexでの課題")[
  - OpenAI CodexでもTypstのコード生成を試みた
  - しかしTypstの構文が正しく生成されないケースが多発
  - `#barcode` など未定義の命令が使われる
  - Typstは比較的新しい言語のため学習データが不足している可能性
  - Claude Codeはビルドエラーを検知して自己修正できる点が強み
]

// トークン使用量
#content-slide(title: "このプレゼン作成にかかったコスト")[
  - モデル: Claude Opus 4.6
  - `/usage` コマンドで使用量を確認可能

  #align(center,
    image("assets/images/koedolug-202602-claude-usage.png", width: 70%)
  )
]

// セクション: 宣伝
#section-slide("宣伝")

// 参加予定イベント
#content-slide(title: "参加予定イベント")[
  - *OSC Tokyo/Spring*
    - OpenStreetMap Japanとして参加
  - *FOSS4G Hiroshima 2026*
    - Call for Proposalが開始中
    - https://2026.foss4g.org
]

