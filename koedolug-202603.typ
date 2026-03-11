#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "小江戸らぐ 2026年3月")

// タイトルスライド

#title-slide(
  title: "中古のSurfaceを買ってArch Linuxを入れた",
  subtitle: "約1万円で手に入るLinuxマシン",
  author: "Taro Matsuzawa (@smellman)",
  institution: "OSGeo.JP/OSMFJ/jus/Geolonia Inc.",
  date: datetime(year: 2026, month: 3, day: 14)
)

// 自己紹介
#content-slide(title: "自己紹介")[
  - 松澤 太郎 (Taro Matsuzawa / \@smellman)
  - OpenStreetMap Foundation Japan (OSMFJ) 理事
  - OSGeo財団 日本支部(OSGeo.JP) 理事
  - 日本UNIXユーザ会 副会長
  - 株式会社Geolonia GISエンジニア
]

// 購入したSurface
#content-slide(title: "購入したSurface")[
  - *Surface Pro 5* (2017年モデル / SKU: 1796)
  - CPU: Intel Core i5-7300U \@ 2.60GHz（2コア4スレッド）
  - メモリ: 8GB
  - 中古価格: *約1万円*
  - タッチスクリーン・キックスタンド付きでこの価格
]

// なぜSurfaceを選んだか
#content-slide(title: "なぜSurfaceを選んだか")[
  - 川越のじゃんぱらで一目惚れ
  - とにかくタブレットが欲しかった
]

// セクション: まずはDebian sidを試した
#section-slide("まずはDebian sidを試した")

// Debian sidでの問題
#content-slide(title: "Debian sidをインストールしてみたが…")[
  - 最初にDebian sid（unstable）をインストール
  - 標準カーネルではタッチパネルが動作しなかった
  - linux-surfaceプロジェクトはDebian *stable* が対象
  - sid向けのパッケージは提供されていない
  - タブレットとして使いたいのにタッチが使えないのは致命的
  - → *Arch Linuxに切り替えることを決意*
]

// セクション: Arch Linuxのインストール
#section-slide("Arch Linuxのインストール")

// インストール手順
#content-slide(title: "インストール手順")[
  + UEFI設定でSecure Bootを無効化
  + USBメモリからArch Linuxインストーラを起動
  + インストーラ上ではWi-Fiが使える（iwdで接続）
  + 通常通りArch Linuxをインストール
  + 再起動後、*Wi-Fiが動かない*ことに気づく
]

// Wi-Fiの罠
#content-slide(title: "ハマりポイント: Wi-Fiが動かない")[
  - インストーラのカーネルにはSurface用ドライバが含まれている
  - しかしインストール後の標準カーネルには含まれていない
  - 再起動するとWi-Fiが一切使えない状態に
  - 有線LAN変換アダプタが手元にないと詰む
]

// linux-surfaceカーネルの導入
#content-slide(title: "linux-surfaceカーネルの導入")[
  - Surface向けカスタムカーネル + ドライバ集
  - タッチスクリーン・Wi-Fi・カメラ等に対応
  - Arch Linux向けにはパッケージリポジトリを提供
  - `/etc/pacman.conf` にリポジトリを追加してインストール
  - https://github.com/linux-surface/linux-surface
]

// インストール後の状態
#content-slide(title: "linux-surface導入後")[
  - Wi-Fiが問題なく動作するようになった
  - タッチスクリーンも正常に認識
  - カーネルバージョン: `6.18.8-arch2-1-surface`
  - 普段使いのArch Linuxマシンとして十分実用的
  - このプレゼンテーションもこのSurfaceで作成
]

// インストールしたパッケージ（デスクトップ環境・入力）
#content-slide(title: "インストールしたパッケージ (1/2)")[
  - *デスクトップ環境*: `plasma-meta` / `sddm`（KDE Plasma）
  - *日本語入力*: `fcitx5-skk` / `fcitx5-configtool`
  - *フォント*: `noto-fonts-cjk`
  - *オンスクリーンキーボード*: `onboard`
  - *タッチスクリーン*: `iptsd`（linux-surface提供）
  - *Bluetooth*: `bluez` / `bluez-utils`
]

// インストールしたパッケージ（アプリ・開発ツール）
#content-slide(title: "インストールしたパッケージ (2/2)")[
  - *ブラウザ*: `firefox`
  - *エディタ*: `code`（VS Code） / `vim`
  - *開発ツール*: `git` / `nodejs` / `typst`
  - *音声*: `pipewire` / `pipewire-pulse` / `wireplumber`
  - *ネットワーク*: `networkmanager` / `iwd` / `cloudflared`
  - *その他*: `htop` / `copyq` / `zram-generator`
]

// まとめ
#content-slide(title: "まとめ")[
  - 中古Surface Pro 5は *約1万円* で入手できる
  - linux-surfaceカーネルでハードウェアサポートは充実
  - Wi-Fiはインストール時の罠があるので事前準備が重要
  - 軽量・タッチ対応でモバイルLinuxマシンに最適
  - 安価にLinux環境を手に入れたい方におすすめ
]
