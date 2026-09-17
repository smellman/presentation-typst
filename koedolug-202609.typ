#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "小江戸らぐ 2026年9月")

// タイトルスライド
#title-slide(
  title: "OpenStreetMap Sound Demo Slint & Navara",
  subtitle: "小江戸らぐ 2026年9月",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 9, day: 19)
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

#content-slide(title: "FOSS4G Hiroshima 2026")[
  - 8月30日から9月5日まで広島で開催されるFOSS4G Hiroshima 2026にスタッフ参加しました。
  - おかげさまで800人を超えるイベントとなりました。
  - Workshopで3時間ぶっ通しで英語で喋って疲れました。
]

#section-slide("OpenStreetMap Sound Demoとは")

#content-slide(title: "OpenStreetMap Sound Demoとは")[
  - OpenStreetMapの建物を音楽に合わせて踊らせるデモです。
  - 詳しいことは OLL Award 2025受賞スピーチ 「OpenStreetMap Sound Demo の話」を参照してください。
    - Link: https://www.docswell.com/s/smellman/ZJW86J-2026-05-28-oll-awards-2025
]

#section-slide("OpenStreetMap Sound Demo Slint")

#content-slide(title: "OpenStreetMap Sound Demo Slint")[
  - Qtの開発者たちが新しく作ったRustベースのGUIフレームワーク Slint と MapLibre Native FFI を使って新しく OpenStreetMap Sound Demo を実装しました。
  - macOS / Linux / iOS / Android で動作します。
    - AndroidはUIがちょっと壊れるのと、パフォーマンスがあまり良くないです。
    - Windowsはしらん。
  - Link: https://github.com/smellman/osm-sound-demo-slint
  - Webブラウザでは出来なかったGamepadでの操作を実装しました。
    - Chrome/SafariではGamepad APIがあるのですが、Firefox使いなので却下。
  - デモします。
]

#section-slide("OpenStreetMap Sound Demo Navara")

#content-slide(title: "OpenStreetMap Sound Demo Navara")[
  - Navaraは Eukaryaが開発した新しい3D地図表示ライブラリです。
    - 先日MapLibre Organizationに移管されました。
    - Three.jsをベースにしています。
  - Navaraを使って、OpenStreetMap Sound Demo を実装しました。
  - Link: https://smellman.github.io/osm-sound-demo-navara/
  - デモします。
]

#content-slide(title: "雑感")[
  - MapLibre(GL JS/Native) の表現はどちらも同じようなものが実現できます。
  - 一方 Navara は3Dエンジンなので、MapLibreと同じような表現にしようとするとちょっと変になります。
  - 良いとこ取りをすると良さそう。
]
