#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "小江戸らぐ 2026年8月")

// タイトルスライド
#title-slide(
  title: "Rapid Plateauをサクサク対応するためにHOT Tasking Managerを立ち上げて見た",
  subtitle: "小江戸らぐ 2026年8月",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 8, day: 22)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - 一般社団法人OpenStreetMap Foundation Japan (OSMFJ) 理事
  - 一般社団法人OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - UNOpenGIS/7 Lead Engineer
  - 株式会社Geolonia GISエンジニア
]

#section-slide("最近の話")

// OSC 2026 Kyoto での発表
#content-slide(title: "OSC 2026 Kyoto での発表")[
  - OSC 2026 Kyoto で発表しました。
  - 日本のタイルサーバーとGeoな話題
  - 講演資料: #link("https://www.docswell.com/s/smellman/5VJX3E-2026-08-01-osmf-tile")
]

#content-slide(title: "FOSS4G Hiroshima 2026")[
  - 8月30日から9月5日まで広島で開催されるFOSS4G Hiroshima 2026にスタッフ参加します。
  - おかげさまで800人規模のイベントになりそうです。
  - Workshopも一つ担当します。
  - https://2026.foss4g.org/ja/
]

#content-slide(title: "GeoLibre の登場")[
  - 2026年6月ごろからGeoLibreという新しいOSSが誕生しました。
  - Rust + WebAssembly + MapLibreで作られた、軽量な地理情報処理ライブラリです。
  - フットプリントがかなり小さく、スタンドアロン版もあるが、Web ブラウザやChrome 拡張機能でも動作するので気軽にGISが使えます
  - https://geolibre.app/
]

#section-slide("Rapid Plateauとは")

#content-slide(title: "Rapid Plateauとは")[
  - nyampire氏が作成したRapid AIをPlateauのインポート作業に特化させたインスタンス
  - 従来の建物インポート作業がWebブラウザだけで完結するようになった
  - タグの転記機能もあり、建物を新規に作るだけでなく、既存の建物にタグを転記することも可能
  - https://rapid.nyampire.info/
]

#content-slide(title: "作業してみた")[
  - 千葉市中央区の工業地帯から始めてみた
  - マウスではなくトラックボールで作業ができたので手の負担がすごく少なくって最高でした
  - 作業自体は楽だが、だんだん何処が「まだやってないところ」なのか分からなくなってくる
    - これ自体はマッピングでよくある悩み
  - そこで、HOT Tasking Managerを立ち上げてみることにした
]

#section-slide("HOT Tasking Managerを立ち上げて見た")

// HOT Tasking Managerとは
#content-slide(title: "HOT Tasking Manager とは")[
  - Humanitarian OpenStreetMap Team (HOT) が提供するタスク管理プラットフォーム
  - 災害対応や人道支援のための地図作成プロジェクトを効率的に管理
  - 技術的にはRustが使われていたりして結構面白い
  - https://github.com/hotosm/tasking-manager/
]

#content-slide(title: "立ち上げ方")[
  - zenn.devに記事を書きました。
    - https://zenn.dev/geolonia/articles/27fced227e1e12
]

#content-slide(title: "必要なもの")[
  - Docker環境(Docker Compose)
  - git
  - テキストエディタ
  - ドメイン, Reverse Proxy
  - OpenStreetMapのアカウント
  - SMTP アカウント
]

#content-slide(title: "厄介なところ")[
  - SMTPの設定が必須になります。
    - ユーザ登録はできるが、validationメールが送信できないと詰む
    - GmailのSMTPを使う場合は、アプリパスワードを発行する必要があります。
      - https://myaccount.google.com/apppasswords
]

#content-slide(title: "立ち上げてみた")[
  - Docker Composeで立ち上げるときにドメインの設定を渡さないと詰む
  - OSMのアカウントでログイン後、SQLを叩いて管理者権限を付与する
  - その後、管理者権限でログインして、プロジェクトを作成する
  - nyampire氏のRapid Plateauを使う場合は、プロジェクトの設定で外部サイトに登録する必要がある
]

#content-slide(title: "結果")[
  #align(center,
    image("assets/images/koedolug-202608-chiba.png", height: 85%)
  )
  千葉市中央区の全域の建物をインポートしました
]

#content-slide(title: "まとめ")[
  - OSMの活動は、たまにどこまでやったか分からなくなる
  - HOT Tasking Managerを立ち上げると、作業の進捗が可視化される
  - 立ち上げ自体はちょっと面倒だし、SMTPの設定が必要なのが厄介
]

#content-slide(title: "面倒なので")[
  - どうせだったらCloudflareで一発でデプロイできるような仕組みを作りたい
  - OSMのアカウントを hono で使えるようにすればいいのでは？
    - https://github.com/honojs/middleware/pull/2076 実装はしてみた
  - 上記が取り込まれたら実装してみたい。
    - 発表中に取り込まれた！やったぜ！
]