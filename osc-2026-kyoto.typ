#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "Open Source Conference 2026 Kyoto")

// タイトルスライド
#title-slide(
  title: "日本のタイルサーバーとGeoな話題",
  subtitle: "OpenStreetMap Foundation Japanの地図タイル配信基盤と最近のGeoな話題",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus",
  date: datetime(year: 2026, month: 8, day: 1)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - 一般社団法人OpenStreetMap Foundation Japan (OSMFJ) 理事
  - 一般社団法人OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - UNOpenGIS/7 Lead Engineer
  - とある会社のGISエンジニア
]

// セクション: OpenStreetMap JapanとOpenStreetMap Foundation Japan
#section-slide("OpenStreetMap JapanとOpenStreetMap Foundation Japan")

// OpenStreetMap JapanとOpenStreetMap Foundation Japan
#content-slide(title: "OpenStreetMap JapanとOpenStreetMap Foundation Japan")[
  - OpenStreetMap Japan (OSM Japan) は、OpenStreetMap プロジェクトを支援する日本のコミュニティです。
  - OpenStreetMap Foundation Japan (OSMFJ) は、OpenStreetMap Foundation の日本支部として、OpenStreetMap プロジェクトの日本国内での普及・啓発活動を行っています。
  - OSMFJ の活動内容:
    - 地図タイル配信基盤の運用
    - 各種問い合わせ対応、OpenStreetMap Foundation への問い合わせ対応
    - OpenStreetMap 関連イベントの開催・支援(主に State of the Map Japan)
    - 日本国内での OpenStreetMap コミュニティの支援
]

// セクション: OSMFJ タイルサーバー
#section-slide("OSMFJ タイルサーバー")

// OSMFJ タイルサーバーの概要
#content-slide(title: "OSMFJ タイルサーバーの概要")[
  - OSMFJ タイルサーバは、OSM データを基にした地図タイルを配信するためのインフラストラクチャです。
  - さくらインターネット様からサーバの支援を受け、2020年からベクトルタイルサーバ及びラスタタイルサーバを運用しています。
  - OSMFJ タイルサーバの URL: #link("https://tile.openstreetmap.jp/")
]

// タイルサーバとは
#content-slide(title: "タイルサーバとは")[
  - タイルサーバは、地図をタイル状の画像に分割して配信するサーバです。
  - クライアントは必要なタイルをリクエストし、サーバはそれに応じてタイルを返します。
  - タイルは通常、ズームレベルごとに異なる解像度で提供されます。
  - タイルサーバの利点:
    - 高速な地図表示
    - キャッシュによる効率的な配信
    - 大規模な地図データの管理が容易
]

// タイルの構造
#content-slide(title: "タイルの構造")[
  - タイルは通常、XYZ座標系で管理されます。
  - ズームレベル (Z)、X座標 (X)、Y座標 (Y) の3つのパラメータで指定されます。
  - 例: ズームレベル10、X=512、Y=384 のタイルは、URLとして次のようにアクセスできます:
    - #link("https://tile.openstreetmap.jp/10/512/384.png")
    #figure(
      image("assets/images/384.png", width: 20%)
    )
]

// 国土地理院による説明
#content-slide(title: "国土地理院による説明")[
  #figure(
    image("assets/images/tileNum.png", width: 70%)
  )
  Copyright: 国土地理院
]

// ラスタタイルとベクトルタイル
#content-slide(title: "ラスタタイルとベクトルタイル")[
  - ラスタタイル: 画像として配信されるタイル (例: PNG, JPEG, WebP)
    - 地図のスタイルを変更するには、サーバ側で画像を再生成する必要があります。
  - ベクトルタイル: 地図データをベクトル形式で配信するタイル (例: Mapbox Vector Tile, MapLibre Vector Tile)
    - クライアント側でスタイルを変更できるため、柔軟な地図表示が可能です。
  - OSMFJ タイルサーバでは、ラスタタイルとベクトルタイルの両方を提供しています。
]

// ラスタタイルを深掘り
#content-slide(title: "ラスタタイルを深掘り")[
  - ラスタタイルは、地図の見た目を固定した画像として配信されます。
  - 利点:
    - クライアント側の負荷が少ない
    - 古いブラウザやデバイスでも表示可能
  - 欠点:
    - スタイル変更が困難
    - データ量が大きくなることがある
  - 通常、256px × 256px の画像として配信されます。
    - 512px × 512px のタイルを使用する場合もあります。(Retina対応)
]

// ラスタタイルの特殊な例
#content-slide(title: "ラスタタイルの特殊な例 - 標高タイル")[
  - ラスタタイルでは、画像データ以外にも、地図情報を含めるケースがあります。
  - 例: 標高データを含むラスタタイル (DEMタイル)
    - 標高情報を色で表現した画像として配信されます。
    - 色の値に計算式を適用することで、標高を取得できます。
  - 例: 標高タイルの計算式
    - https://github.com/tilezen/joerd/blob/master/docs/formats.md
    - decode: `(red * 256 + green + blue / 256) - 32768`
    - encode: ```
      v += 32768
      r = floor(v/256)
      g = floor(v % 256)
      b = floor((v - floor(v)) * 256)
```
  - なお、OSMFJのタイルサーバでは標高タイルは配信していません。
]

// 標高タイルいろいろ
#content-slide(title: "標高タイルいろいろ")[
  - 標高タイルはいくつかフォーマットがあります。
    - Mapbox Terrain-RGB
    - Mapzen Terrarium
    - 地理院地図 標高タイル
  - MapLibre GL JS では、標高タイルを使用して3D地図を表示することができます。
    - 地理院地図 標高タイルは別途ライブラリが必要です。
    - https://github.com/mug-jp/maplibre-gl-gsi-terrain
      - ただしアーカイブされたので注意が必要。後述するMapterhornを推奨。
]

// 標高タイルを組み合わせた例
#content-slide(title: "標高タイルを組み合わせた例")[
  - https://smellman.github.io/aws-terrain/#11.97/35.35292/138.74862/0/58
  #figure(
    image("assets/images/aws_terrain.png", width: 70%)
  )
]

// ベクトルタイルを深掘り
#content-slide(title: "ベクトルタイルを深掘り")[
  - ベクトルタイルは、地図データをベクトル形式で配信するタイルです。
  - 利点:
    - クライアント側でスタイルを自由に変更可能
    - データ量が少なく、効率的な配信が可能
  - 欠点:
    - クライアント側の負荷が高い
    - 古いブラウザやデバイスでは表示できない場合がある
  - OSMFJ タイルサーバでは、Mapbox Vector Tile (MVT) フォーマットで配信しています。
    - 最近では、MapLibre Vector Tile (MVT) フォーマットもリリースされていて、試験的に公開しています。(ただし、OSMFJではない個人のサーバです)
      - https://dev.smellman.org/static/planet-mlt.pmtiles
]

// ベクトルタイルの動的な挙動
#content-slide(title: "ベクトルタイルの動的な挙動")[
  - ベクトルタイルは、クライアント側でスタイルを変更することで、地図の見た目を動的に変えることができます。
    - MapLibre GL JS を使用して、地図の色や線の太さを変更することができます。
    - 3D表現も可能で、建物の高さを表現することができます。
  - また、ベクトルタイルは、ズームレベルに応じて表示する地物を制御することも可能です。
  - これにより、詳細な地図情報を提供しつつ、パフォーマンスを維持することができます。
]

// ベクトルタイルを使ったネタサイト
#content-slide(title: "ベクトルタイルを使ったネタサイト")[
  - https://smellman.github.io/osm-sound-demo/
  - OpenStreetMap の建物を音楽に合わせて上下させるネタアプリです。
  - 楽曲の周波数スペクトルで 3D ビルの高さがリアルタイムに変化します。
  #figure(
    image("assets/images/oss-stupid-program-2025-demo-tokyo.png", width: 50%)
  )
]

// OSMFJ タイルサーバの技術スタック
#content-slide(title: "OSMFJ タイルサーバの技術スタック")[
  - Schema: OpenMapTiles(Planetiler)
  - タイル生成: TileServer GL
  - キャッシュ: Varnish Cache
  - 配信: Nginx
  - モニタリング: Prometheus + Grafana
  - サーバ: さくらインターネット様からの支援を受けた専用サーバ
  - ストレージ: SSD 500GB
  - メモリ: 64GB
  - CPU: 20コア
  - ネットワーク: 100Mbps
]

// OSMFJ タイルサーバの特徴
#content-slide(title: "OSMFJ タイルサーバの特徴")[
  - OSMFJ タイルサーバは、OpenStreetMap データを基にした地図タイルを配信するためのインフラストラクチャです。
  - ラスタタイルとベクトルタイルの両方を提供しており、様々な地図アプリケーションで利用可能です。
  - また、OSMFJ タイルサーバは、非営利団体として運営されており、無料で利用できることが特徴です。商用利用も可能ですが、定期的に再起動がかかるので商用なら時前で作る事をおすすめしています。
  - 竹島、北方領土問題にちょっと対応しています。
  - ソースは全て公開しています: https://github.com/osmfj/tileserver-gl-site
]

// OSMFJ タイルサーバの配布形式
#content-slide(title: "OSMFJ タイルサーバの配布形式")[
  - ラスタタイル: PNG, WebP
  - ベクトルタイル: Mapbox Vector Tile (MVT)
    - PMTiles形式及びmbtiles形式で配布
      - mbtiles形式は OSMFJ のタイルサーバではなく、 https://file.smellman.org で配布しています。
      - PMTiles形式は OSMFJ のタイルサーバで配布しています。
      - mbtiles形式を個人のサーバで配布しているのは単に容量の問題です。
]

// OSMFJタイルサーバの使い方
#content-slide(title: "OSMFJタイルサーバの使い方")[
  - https://tile.openstreetmap.jp からデザインを一つ選択します。
  - 選択したデザインのserviceからURLをコピーして、地図アプリやWebサイトで使用します。
  #figure(
    image("assets/images/tile-openstreetmap-jp.png", width: 70%)
  )
]

// ラスタタイルの使い方 - Leaflet.js
#content-slide(title: "ラスタタイルの使い方 - Leaflet.js")[
  - Leaflet.js を使用して、OSMFJのラスタタイルを地図として表示する例です。
  - HTMLに以下のコードを追加します。
  ```html
  <div id="map" style="width: 600px; height: 400px;"></div>
  <script>
    var map = L.map('map').setView([35.6895, 139.6917], 13);
    L.tileLayer('https://tile.openstreetmap.jp/styles/maptiler-basic-ja/512/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors',
      maxZoom: 18,
      tileSize: 512,
    }).addTo(map);
  </script>
  ```
  - タイルサイズが512pxなのに注意をしてください。エンドポイントを調整することで256pxタイルとしても使用可能です。
]

// ベクタタイルの使い方 - MapLibre GL JS
#content-slide(title: "ベクタタイルの使い方 - MapLibre GL JS")[
  - MapLibre GL JS を使用して、OSMFJのベクタタイルを地図として表示する例です。
  - HTMLに以下のコードを追加します。
  ```html
  <div id="map" style="width: 600px; height: 400px;"></div>
  <script type="module">
    import * as maplibregl from 'https://unpkg.com/maplibre-gl@^6.0.0/dist/maplibre-gl.mjs';
    var map = new maplibregl.Map({
      container: 'map',
      center: [139.6917, 35.6895],
      style: 'https://tile.openstreetmap.jp/styles/maptiler-basic-ja/style.json',
      zoom: 13
    });
  </script>
  ```
  - attributionの設定は自動的に行われます。
]

// ベクタタイルのスタイル変更
#content-slide(title: "ベクタタイルのスタイル変更")[
  - MapLibre GL JS では、ベクタタイルのスタイルを自由に変更することができます。
  - 例えば、坂ノ下さんが作成している万博マニアックマップのスタイルを利用するには、以下のスタイルを指定します。
    - https://k-sakanoshita.github.io/expo2025-maniacs/tiles/japan-20251013.json
    - このスタイルは、OSMFJのベクタタイルを利用して、万博会場周辺の地図を表示するためのスタイルで、3Dの建物の表現が可能になっています。もちろん、万博会場以外でも利用可能です。
]

// 自分でスタイルを作る
#content-slide(title: "自分でスタイルを作る")[
  - MapLibre GL JS では、独自のスタイルを作成することも可能です。
  - スタイルはJSON形式で記述され、地図の色や線の太さ、ラベルの表示などを自由に設定できます。
  - スタイルエディタとして、Maputnik (https://maplibre.org/maputnik/) を使用すると、GUIでスタイルを作成できます。
  - JSONを大量に編集したくないっていう人向けには、Charites (https://github.com/unvt/charites) を使うと、JSONをYAMLに分解してテキストエディタでスタイルを作成することができます。
  - 作成したスタイルは、OSMFJのベクタタイルと組み合わせて使用することができます。
]

// OSMFJ以外のデータソース
#content-slide(title: "OSMFJ以外のデータソース")[
  - OSMFJ以外にも様々なサービスがMapLibre GL JSで利用可能です。
  - Protomap (https://protomap.com/) は、OSMデータをベースにしたベクトルタイルを提供しており、PMTiles形式の開発元としても有名です。商用、個人利用ともに可能です。
  - OpenFreeMap (https://openfreemap.org/) は、OSMデータをベースにしたベクトルタイルを提供しており、PMTiles形式で配信しています。商用利用も可能です。
  - 国土地理院最適化ベクトルタイル (https://github.com/gsi-cyberjapan/optimal_bvmap) は、国土地理院の地図データをベースにしたベクトルタイルを提供しており、PMTiles形式で配信しています。
] 

// セクション: 最近のGeoな話題
#section-slide("最近のGeoな話題")

// GeoLibre
#content-slide(title: "GeoLibre")[
  - GeoLibre は、最近登場したGISアプリケーションです。
  - #link("https://github.com/opengeos/GeoLibre")
  - MapLibre GL JS をベースに様々なフォーマットのビューアーとして使えるアプリで、Juyter Notebook などの環境でも動作します。
    - 3DTilesなども対応しているので、Plateauの3D都市モデルも表示可能です。
  - 開発スピードがとても速く、気づいたらv2.4がリリースされていました。
  - 技術スタック: Tauri v2, React, TypeScript, MapLibre GL JS, DuckDB-WASM Spatial, and deck.gl. 
]

// MIERUNE地図タイル
#content-slide(title: "MIERUNE地図タイル")[
  - MIERUNE地図タイルは、OpenStreetMapをベースにした地図タイルを提供するサービスです。
  - #link("https://maps.mierune.co.jp/")
  - セルフホスト可能な地図タイルサーバとしても利用可能で、PMTiles形式で提供されています。
  - デザインがかなり凄腕の人たちで作られているので、今後が楽しみなプロダクトです。
]

// Mapterhorn
#content-slide(title: "Mapterhorn")[
  - Mapterhorn は、MapLibre GL JS のための新しい標高タイルインフラです。
  - #link("https://mapterhorn.com/")
  - 高解像度(512px)の標高タイルを世界単位で提供しており、日本やスイスなどの地域によっていはより解像度が高い標高タイルを提供しています。
    - 日本からは国土地理院標高タイルがコミットされています。
  - 前述するMIERUNEさんがスポンサーになりました。
]

// CoMaps
#content-slide(title: "CoMaps")[
  - CoMaps は、OpenStreetMapをベースにしたオフライン地図アプリケーションです。
  - #link("https://www.comaps.app/")
  - 地図データをスマートフォンにダウンロードして、オフラインで利用することができます。
  - ナビゲーションなどがオフラインで可能なので、海外出張の時に入れて置くと便利なソフトです。
  - 最近、Gigazineでも紹介されました。
    - https://gigazine.net/news/20260718-comaps/
]

// MapLibre GL JS v6
#content-slide(title: "MapLibre GL JS v6")[
  - MapLibre GL JS v6 がリリースされました。
  - ES modulesのみでの提供になり、従来のUMD形式での提供は終了します。
  - いくつかAPIチェンジがあるので、v5系からの移行には注意が必要です。
    - https://github.com/maplibre/maplibre-gl-js/blob/main/docs/guides/v5-to-v6-migration-guide.md
]

// Leaflet.js v2
#content-slide(title: "Leaflet.js v2")[
  - Leaflet.js v2 がそろそろリリースされる予定です。
  - Leaflet.js v2 は、従来のLeaflet.js v1系からの大幅な変更があり、いくつかのAPIチェンジがあります。
    - ESMモジュール形式での提供がメインになります。
  - Leaflet.js の特徴だった L.map が new Map に変更されるなど大きな変更があります。従来の L.map も提供はされるようですが、非推奨になります。
  - 2.0.0-alpha.1 がリリースされてからそろそろ一年音沙汰が無いので、ちょっと心配している。
]

// まとめ
#content-slide(title: "まとめ")[
  - OSMFJ タイルサーバは、OpenStreetMap データを基にした地図タイルを配信するためのインフラストラクチャです。
  - ラスタタイルとベクトルタイルの両方を提供しており、様々な地図アプリケーションで利用可能です。
  - 様々なプロバイダが地図を提供しており、MapLibre GL JS などのライブラリを使用することで、自由に地図のスタイルを変更することができます。
  - 地図の進化は止まらず、今後も新しい技術やサービスが登場することが期待されます。
]