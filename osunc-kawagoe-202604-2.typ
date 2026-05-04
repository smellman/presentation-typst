#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "OSunC 川越 2026年4月")

// タイトルスライド
#title-slide(
  title: "Planetilerのzoom 16対応をした話",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 4, day: 4)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - OpenStreetMap Foundation Japan (OSMFJ) 理事
  - OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - 株式会社Geolonia GISエンジニア
]

// セクション: Planetilerとは
#section-slide("Planetilerとは")

// Planetilerの概要
#content-slide(title: "Planetilerとは")[
  - OpenStreetMapやShapefile、GeoParquetなどからベクトルタイルを生成するツール
  - Javaで実装されており、非常に高速
  - On The Go Mapが開発をしている
  - MBTiles/PMTiles形式での出力に対応
  - 惑星全体（Planet）のデータも数時間で処理可能
]

// なぜzoom 16が必要なのか
#content-slide(title: "なぜzoom 16が必要なのか")[
  - Planetilerのデフォルトはzoom 14で、以前はzoom 15まで対応可能だった
  - 地番レベルの詳細表示にはzoom 16が必要
  - 例えば地理院地図などではzoom 16の対応が必要
    - 弊社のプロダクトでもzoom 16対応が必要だった
]

// セクション: zoom 16対応の実装
#section-slide("zoom 16対応の実装")

// 実装の改修
#content-slide(title: "実装の改修")[
  - Planetiler自体が内部のタイルのロジックにint型を使っていた
  - zoom 16に対応するために、タイルのロジックをlong型に変更
  - テストケースなども合わせて修正を行った
  - Pull Request(https://github.com/onthegomap/planetiler/pull/1523)を作成して、無事マージされた。
]

// セクション: 結果
#section-slide("結果")

// 速度の向上
#content-slide(title: "速度の向上")[
  - Java Profileでzoom 16のレンタリングを行ったところ、以下のように速度が改善された
    - tippecanoeのみの実装: 39分
    - Planetilerのzoom 16対応後: 26分
  - ちなみに、とあるプロセッシングでは1日以上かかるプロセスが1時間以下で終わることも検証済み
]

// まとめ
#content-slide(title: "まとめ")[
  - Planetilerのzoom 16対応を行ったことで、地番レベルの詳細表示が可能になった
  - Planetiler自体が高速であるため、tippecanoeなどよりも高速に処理が可能になった
  - 比較的大きな改修がマージされてちょっと嬉しい
]

