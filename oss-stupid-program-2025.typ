#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "OSS Stupid Program 2025")

// タイトルスライド
#title-slide(
  title: "OpenStreetMap Sound Demo の話",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 5, day: 28)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - 一般社団法人OpenStreetMap Foundation Japan (OSMFJ) 理事
  - 一般社団法人OSGeo 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - UNOpenGIS/7 lead enginner
  - 株式会社Geolonia GISエンジニア
  - かつてもじら組という組織の代表だったこともある
]

// セクション: これは何？
#section-slide("OpenStreetMap Sound Demo とは")

// 概要
#content-slide(title: "OpenStreetMap Sound Demo")[
  - URL: #link("https://smellman.github.io/osm-sound-demo/")
  - *OpenStreetMap の建物を音楽に合わせて上下させる* ネタアプリ
  - 楽曲の周波数スペクトルで 3D ビルの高さがリアルタイムに変化
  - 楽曲は #link("https://www.otherman-records.com/")[Otherman Records] (CC BY-NC 2.1 JP) を全曲利用
  - 109 リリース分のトラック・アルバムを API 経由で取得
  - 元ネタは Mapbox の sound example、それを OSM で再構築
]

// デモ画面
#content-slide(title: "デモ画面（東京駅周辺）")[
  #align(center,
    image("assets/images/oss-stupid-program-2025-demo-tokyo.png", height: 85%)
  )
]

// About
#content-slide(title: "About モーダル")[
  #align(center,
    image("assets/images/oss-stupid-program-2025-demo-about.png", height: 85%)
  )
]

// セクション: OpenStreetMap とは
#section-slide("OpenStreetMap とは")

// OSM の説明
#content-slide(title: "OpenStreetMap (OSM)")[
  - 世界中のマッパーが作る *自由に編集・再配布できる* 世界地図
  - 「地図版 Wikipedia」と呼ばれることも
  - 2004 年に Steve Coast が英国で開始
  - データは *ODbL* (Open Database License) で配布
  - 道路・建物・店舗・水路・地形などあらゆる地物を含む
  - 日本では *OpenStreetMap Japan* 及び *OpenStreetMap Foundation Japan (OSMFJ)* が活動
]

// 私の関わり方
#content-slide(title: "OpenStreetMap での僕の役割")[
  - *OpenStreetMap Foundation Japan (OSMFJ)* で理事
  - *tile.openstreetmap.jp* の管理人
  - *openstreetmap.jp* の再構築担当
  - *Open Source Conference* などに
    OpenStreetMap Japan コミュニティとして出展
  - マッパーの一人、主に *千葉市若葉区* を中心にマッピング
]

// 建物の高さデータ
#content-slide(title: "OSM には建物の高さも入っている")[
  - 建物には `height` / `building:levels` などのタグが付与可能
  - 都市部はマッパーが地道に入力しており、高さデータが豊富
  - これがあるおかげで *3D ビル* としてレンダリングできる
  - 今回のデモはこの *建物の高さ* を音楽に合わせて動かしている
  - つまり OSM のデータがなければ成立しない遊び
]

// セクション: 仕組み
#section-slide("仕組み")

// 技術スタック
#content-slide(title: "技術スタック")[
  - *MapLibre GL JS* — 3D ビルの fill-extrusion 描画
  - *PMTiles* — 単一ファイルでベクトルタイル配信
  - 地図スタイル/タイル: tile.openstreetmap.jp の planet.pmtiles
  - *Web Audio API* — `AnalyserNode` で FFT 解析
  - *TypeScript + Vite* — ビルド
  - *Bootstrap 5* — UI（About モーダルなど）
]

// 高さの作り方
#content-slide(title: "建物の高さはどう動かしているか")[
  - `AnalyserNode` の `fftSize = 32` → *16 ビン* の周波数データ
  - 建物を `render_height` で *16 段階* に分割し、
    それぞれ別レイヤとして fill-extrusion を追加
  - 各フレームで `dataArray[i]` を取り、
    レイヤ `3d-buildings-i` の `fill-extrusion-height` を更新
  - 平均振幅で `setLight` の HSL 色相と intensity を変化
  - `requestAnimationFrame` でぐるぐる
]

// VJモード
#content-slide(title: "VJ モード")[
  - PC のスピーカー出力をそのまま音源として取り込むモード
  - `getUserMedia({ audio: true })` で仮想入力デバイスから取得
  - Linux: PipeWire の `module-remap-source` で仮想マイクを作成
  - macOS: *Loopback.app* で出力 → 仮想入力にルーティング
  - DJ アプリでも YouTube でも、何を流しても建物が踊る
]

// セクション: Archive.org Proxy
#section-slide("Archive.org の CORS 問題")

// 課題
#content-slide(title: "Otherman Records の音源は Archive.org 配信")[
  - Otherman Records の楽曲ファイルは *archive.org* に置かれている
  - ブラウザから直接 fetch すると一部（というか大半）で *CORS エラー*
  - `crossOrigin = 'anonymous'` を付けても通らないリソースが多数
  - そのままでは Web Audio API に MediaElementSource として渡せない
  - → ストリーミング再生ができない
]

// 解決策
#content-slide(title: "VPS 上に Proxy を建てた")[
  - GitHub: #link("https://github.com/smellman/archive-org-proxy")
  - *FastAPI + httpx* で書いた小さなプロキシ
  - `proxy.smellman.org/proxy/{host}/{path}` で archive.org を中継
  - `CORSMiddleware` で `*` 許可、ブラウザから普通に取得可能に
  - *`Range` ヘッダを透過転送* → シーク再生 / ストリーミングが動く
  - `host.endswith('archive.org')` のみ許可（Open Proxy 化の防止）
]

// Proxy の中身
#content-slide(title: "Proxy 実装のポイント")[
  - `httpx.AsyncClient(follow_redirects=True)` で 302 を辿る
  - `StreamingResponse` で `aiter_bytes()` を流すだけのシンプル実装
  - `Content-Type` / `Content-Length` / `Content-Range` / `Accept-Ranges` を返す
  - Docker / docker-compose で VPS に常駐させて運用
  - ネタアプリのために本気のインフラが組み上がっていく
]

// セクション: 開発遍歴
#section-slide("開発遍歴")

// 開発遍歴
#content-slide(title: "ここまでの道のり")[
  + *最初は mp3 をリポジトリに直置き*
  + ストリーミング非対応で、Open Source Conference 等のデモで
    *通信エラーが頻発* した
  + Otherman Records に楽曲情報の API があることに気づき、
    *勝手にスクレイピング* する実装に変更
  + archive.org の楽曲が *CORS 問題* で再生できず、
    VPS に Proxy を実装して回避
  + 最後に *VJ モード* を実装して完成
]

// まとめ
#content-slide(title: "まとめ")[
  - 「地図と音を合わせたら面白そう」だけで作ったネタアプリ
  - MapLibre の fill-extrusion + Web Audio AnalyserNode の素直な組み合わせ
  - CORS 回避のためだけに *VPS にプロキシを建てる* というアホなインフラ
  - VJ モードで DJ アプリ流しながら街が踊る、いつでもどこでも DJ 気分
  - ソース: #link("https://github.com/smellman/osm-sound-demo")
]
