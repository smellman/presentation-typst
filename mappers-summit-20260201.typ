#import "@preview/axiomst:0.2.0": *
#import "@preview/oxdraw:0.1.0": *
#set text(font: "Noto Sans CJK JP")

#show: slides.with(
  title: "OSMFJ タイルサーバについて",
  author: "Taro Matsuzawa",
  date: datetime(year: 2026, month: 02, day: 01),
  ratio: "16-9",  // or "4-3"
  handout: false,
)

#title-slide(
  title: "OSMFJ タイルサーバについて",
  subtitle: "〜OpenStreetMap Foundation Japanの地図タイル配信基盤〜",
  author: "Taro Matsuzawa",
  institution: "OpenStreetMap Foundation Japan",
  date: datetime(year: 2026, month: 02, day: 01),
)

#slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa)
  - OpenStreetMap Foundation Japan (OSMFJ) 理事
  - OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - 株式会社Geolonia GISエンジニア
]

#slide(title: "目次")[
  - OSMFJ タイルサーバの概要
  - 技術スタック
  - 運用と課題
  - 今後の展望
]

#slide(title: "OSMFJ タイルサーバの概要")[
  OpenStreetMap Foundation Japan (OSMFJ) は、OpenStreetMap プロジェクトを支援する非営利団体です。
  
  OSMFJ タイルサーバは、OSM データを基にした地図タイルを配信するためのインフラストラクチャです。

  さくらインターネット様からサーバの支援を受け、2020年からベクトルタイルサーバ及びラスタタイルサーバを運用しています。
]

#slide(title: "リソース")[
  - CPU: 20コア
  - メモリ: 64GB
  - ストレージ: 500GB SSD
  - ネットワーク: 100Mbps
]

#slide(title: "技術スタック")[
  - タイル生成: TileServer GL
  - キャッシュ: Varnish Cache
  - 配信: Nginx
  - モニタリング: Prometheus + Grafana
]

#oxdraw("
graph LR
  U[Client] --> N[Nginx]

  subgraph D[Docker Host]
    subgraph VSG[Varnish Cache]
      V1[Varnish #1]
    end

    subgraph TSG[TileServer GL]
      T1[TileServer GL #1]
      T2[TileServer GL #2]
      Tn[TileServer GL #N]
    end
  end

  subgraph Static[Static Files]
    S1[Static Tile #1]
  end

  N --> V1

  V1 --> T1
  V1 --> T2
  V1 --> Tn

  N --> S1
")

#slide(title: "構成")[
  Nginxは1台で構成。

  Nginxの背後にVarnish Cacheを配置し、2GBのメモリキャッシュを設定。

  TileServer GLは10台稼働し、Varnish Cacheからのリクエストを分散処理している。

  PMTiles(静的ファイル)はNginxから直接配信。
]


#slide(title: "運用と課題")[
  - ベクタタイル(mbtiles及びpmtiles)の作成は手動で実施。
    - 毎週土曜日の夕方ごろにPlanet OSMが更新されるので、それを手動でダウンロードしてタイルを作成。
    - 自動化したいが、認証などの問題で出来ていない。
  - タイルサーバのモニタリングはPrometheusとGrafanaで実施。
    - CPU使用率、メモリ使用率、ディスクI/O、ネットワークトラフィックなどを監視。
    - 異常の通知などはしていない。
  - セキュリティアップデートも手動で実施。
    - 定期的にOSとソフトウェアのアップデートを確認し、必要に応じて適用。
]

#slide(title: "今後の展望")[
  - スタイルの充実
    - より多様な地図スタイルを提供し、利用者のニーズに応える。
  - モニタリングの強化
    - 異常検知と通知機能を追加し、運用の効率化を図る。
]