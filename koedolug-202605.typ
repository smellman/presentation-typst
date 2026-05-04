#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "小江戸らぐ 2026年5月")

// タイトルスライド
#title-slide(
  title: "OpenStreetMap Japan Websiteの再構築",
  subtitle: "Drupal から Astro へ",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 5, day: 9)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - OpenStreetMap Foundation Japan (OSMFJ) 理事
  - OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - 株式会社Geolonia GISエンジニア
]

// セクション: 背景
#section-slide("背景")

// 旧サイトの状況
#content-slide(title: "旧サイト openstreetmap.jp の課題")[
  - 長年 *Drupal 7* で運用されてきたOSM Japanの公式サイト
  - PHP/MySQLベースで運用負担が大きい
  - セキュリティアップデート対応が継続的に必要(もう無理)
  - イベントやガイドの追加にDrupal管理画面の操作が必要
  - 投稿のハードルが高く、コミュニティが手を入れづらい
]

// 移行の目的
#content-slide(title: "移行の目的")[
  - 運用コストの削減（サーバ・DB不要の静的サイトへ）
  - GitHubで誰でも *Pull Request* で記事追加できる体制
  - モダンなフロントエンド技術スタックへの刷新
  - URL構造（`/node/<id>/`）は互換性を保つ
  - コンテンツ（イベント・ガイド）は全て移行
]

// セクション: 新サイトの構成
#section-slide("新サイトの構成")

// 技術スタック
#content-slide(title: "採用した技術スタック")[
  - *Astro v6* — 静的サイトジェネレータ
  - *React 19* — イベント地図など一部の動的UI
  - *Tailwind CSS v4* + *daisyUI v5* — スタイリング
  - *MapLibre GL JS* — イベント地図のレンダリング
  - *TypeScript* — 型安全な実装
  - *GitHub Pages* — `main` への push で自動デプロイ
]

// なぜAstroか
#content-slide(title: "なぜ Astro を選んだか")[
  - コンテンツ主体のサイトと相性がよい
  - Markdown + フロントマターでイベント・ページを記述
  - Content Collections のスキーマで投稿時のミスを検出
  - 必要な箇所だけ React で *islands* 化（地図など）
  - 出力は完全な静的HTML → GitHub Pages にそのまま乗る
]

// リポジトリ構成
#content-slide(title: "リポジトリ構成")[
  - GitHub: #link("https://github.com/openstreetmap-japan/openstreetmap-japan.github.io")
  - 公開URL: #link("https://openstreetmap-japan.github.io/")
  - `src/content/events/<id>.md` — イベント
  - `src/content/pages/<slug>.md` — 固定ページ・ガイド
  - `src/components/EventMap.tsx` — MapLibre 地図
  - `src/lib/remark-preserve-indent.mjs` — 独自Remarkプラグイン
]

// セクション: スクリーンショット
#section-slide("新サイトの画面")

// トップページ
#content-slide(title: "トップページ")[
  #align(center,
    image("assets/images/koedolug-202605-top.png", height: 85%)
  )
]

// イベント一覧
#content-slide(title: "イベント・ページ一覧")[
  #align(center,
    image("assets/images/koedolug-202605-events.png", height: 85%)
  )
]

// イベント地図
#content-slide(title: "イベント地図 (MapLibre)")[
  #align(center,
    image("assets/images/koedolug-202605-events-map.png", height: 85%)
  )
]

// ガイドページ
#content-slide(title: "ガイドページ (例: OSM利用入門)")[
  #align(center,
    image("assets/images/koedolug-202605-guide.png", height: 85%)
  )
]

// セクション: 移行で工夫したこと
#section-slide("移行で工夫したこと")

// URL互換性
#content-slide(title: "URL の互換性を保つ")[
  - 旧サイトは Drupal の `/node/<id>/` 形式
  - フロントマターに `legacy_node_id` を持たせる
  - イベントは `/events/<id>/` に正規化しつつ
  - `/node/<id>/` から *リダイレクト* で誘導
  - 既存の被リンク・ブックマークを切らない
]

// Markdownの再現
#content-slide(title: "Drupal 由来の Markdown 挙動を再現")[
  - 段落内の単一改行 → `<br>` (`remark-breaks`)
  - 行頭半角スペースのインデントを保持する独自プラグイン
  - `https://...` の自動リンク (GFM autolink)
  - 素のHTML（`<ul>`/`<a>`/`<br>`）もそのまま使える
  - 既存記事を *無変換* に近い形で取り込める
]

// 移行スクリプト
#content-slide(title: "Drupal → Markdown 移行スクリプト")[
  - 自作の Python スクリプトで *一括変換*（未公開）
  - 入力は *MySQL ダンプの .sql テキストそのもの*
  - MySQL を立てずに `CREATE TABLE` / `INSERT INTO` を直接パース
  - `node` / `field_data_body` / `field_data_field_meeting_date` /
    `url_alias` / `file_managed` / `taxonomy_*` などを抽出
  - イベント判定は `field_meeting_date` の有無、ページは `url_alias` 経由
  - 出力: `events/<nid>.md` / `pages/<slug>.md` + リダイレクトCSV
]

// 画像と本文の書き換え
#content-slide(title: "画像と本文の書き換え")[
  - 添付ファイル（`field_data_upload` + `file_managed`）から hero\_image を選定
  - `field_data_field_top_photo` を最優先でキャッチ画像に
  - 本文HTMLの `<img src="...openstreetmap.jp...">` を正規表現で抽出
  - `requests` で実画像をダウンロードし `public/images/legacy/` へ
  - URLのクエリ違いはハッシュ付与で衝突回避
  - body は Markdown 化せず *HTML のまま* 保持して忠実性を優先
]

// コンテンツ移行
#content-slide(title: "コンテンツ移行の結果")[
  - 旧サイトの全イベント・全ガイドページを Markdown 化
  - 画像は `public/images/legacy/` に退避
  - 新規追加分は `public/images/current/` に分離
  - Content Collections のスキーマで型バリデーション
  - `start` が必須、`source_url` は URL 形式チェックなど
]

// 投稿フローの変化
#content-slide(title: "投稿フローの変化")[
  - 旧: Drupalにログイン → 管理画面で投稿
  - 新: GitHub上で Markdown を Pull Request
  - 誰でもレビュー可能、履歴は Git で残る
  - `main` への merge で GitHub Actions が自動ビルド・公開
  - イベント主催者・コミュニティの負担を分散できる
]

// セクション: 細かい改善
#section-slide("細かい改善")

// SEO・SNS対応
#content-slide(title: "SEO・SNS対応")[
  - 全ページに *Open Graph* / *Twitter Card* メタタグ
  - *RSSフィード* を追加（`@astrojs/rss`）
  - ヘッダーに X / Facebook / RSS のソーシャルボタン
  - OSM ロゴをfavicon化（地図ピン + 日章のドット）
  - GitHub リポジトリへのリンクをグローバルナビに追加
]

// 開発体験
#content-slide(title: "開発体験")[
  - `npm run dev` で即プレビュー（Vite による HMR）
  - PR ごとにローカルで同じ手順で動作確認
  - 型エラー・スキーマ違反はビルド時に検出
  - daisyUI でデザインの統一感を担保
  - サーバ・DB の管理から解放
]

// まとめ
#content-slide(title: "まとめ")[
  - OSM Japan のサイトを Drupal から *Astro* に再構築
  - Markdown + GitHub PR でコミュニティが投稿しやすく
  - GitHub Pages で運用コストほぼゼロ
  - URL互換と Drupal 風 Markdown 挙動で *過去資産を保護*
  - イベント追加・ガイド更新の Pull Request 歓迎です
]
