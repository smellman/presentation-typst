#import "theme/theme.typ": *

#show: presentation.with(ratio: "16-9", event: "OSunC 川越 2026年4月")

// タイトルスライド
#title-slide(
  title: "Debian sidのWayland移行計画",
  subtitle: "KDE PlasmaのWaylandセッションをデフォルトに",
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

// セクション: Debian sidのWayland移行計画
#section-slide("Debian sidのWayland移行計画")

// なんでWaylandに移行するのか
#content-slide(title: "なんでWaylandに移行するのか")[
  - KDE PlasmaでX11が無効化される予定
  - Gnome 50ではすでにWaylandがデフォルト
  - X11環境は古くなっていて、パフォーマンスの面で問題がある
  - Waylandはセキュリティやマルチディスプレイのサポートが改善されている
  - Debian sidもこれに追随する必要がある
]

// 移行に向けた最低要件
#content-slide(title: "移行に向けた最低要件")[
  - KDE PlasmaのWaylandセッションが安定して動作すること
  - *RDPが正常に動作すること*
]

// RDP!?
#content-slide(title: "RDPがなぜ必須なのか")[
  - wayvncがKDE PlasmaやGnomeのWaylandセッションで動作しない
    - リモートデスクトップが使えないと俺が困る
  - XRDPはX11セッションでしか動作しない
    - KDE PlasmaのWaylandセッションがデフォルトになるとXRDPも使えなくなる
  - つまり、WaylandセッションでRDPが動作することが必須
]

// KRDPへの移行
#content-slide(title: "XRDPからKRDPへの移行")[
  - KDE PlasmaのWaylandセッションで動作するRDPサーバーはKRDPしかない
    - KRDPはKDEコミュニティが開発している純正のRDPサーバー
    - KDE Plasma 6.1ぐらいからサポートされている
  - とりあえず移行してみる
]

// KRDPのインストールとXRDPの停止
#content-slide(title: "KRDPのインストールとXRDPの停止")[
  + sudo apt install krdp
  + sudo systemctl stop xrdp xrdp-sesman
  + sudo systemctl disable xrdp xrdp-sesman
]

// SDDMの設定
#content-slide(title: "SDDMの設定")[
  + sudo mkdir -p /etc/sddm.conf.d
  + sudo vim /etc/sddm.conf.d/autologin.conf
  ```
[Autologin]
User=btm
Session=plasma
Relogin=true
  ```
]

// uinputの設定
#content-slide(title: "uinputの設定")[
  + sudo vim /etc/udev/rules.d/99-input.rules
  ```
  KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
  ```
  + sudo groupadd -f uinput
  + sudo usermod -aG uinput btm
  + sudo modprobe uinput
  + sudo udevadm control --reload-rules
  + sudo udevadm trigger
  + sudo reboot
  - ここらへんはいろいろ試行錯誤していたので、もしかしたら一部は不要かもしれない
]

// KRDPのパスワード設定
#content-slide(title: "KRDPのパスワード設定")[
  ```
mkdir -p ~/.config/krdp
vim ~/.config/krdp/password
chmod 600 ~/.config/krdp/password
echo "KRDP_PASSWORD=$(cat ~/.config/krdp/password)" > ~/.config/krdp/env
chmod 600 ~/.config/krdp/env
  ```
  - ここはセキュリティ的にあまりよろしくない方法なので、実際にはもっと安全な方法を検討する必要がある
    - たぶんKDE側でKwalletあたりと連携して安全にパスワードを管理できるようになるのが理想
]

// KRDPの証明書を作成
#content-slide(title: "KRDPの証明書を作成")[
  - OpenSSLで証明書を作成
  ```
openssl req -x509 -newkey rsa:4096 -keyout ~/.config/krdp/key.pem -out ~/.config/krdp/cert.pem -days 3650 -nodes -subj "/CN=btm-a300"
  ```
]

//
#content-slide(title: "KRDPのオーバーライド設定")[
  + vim ~/.config/systemd/user/app-org.kde.krdpserver_service.d/override.conf
  ```
[Service]
EnvironmentFile=%h/.config/krdp/env
Environment="WAYLAND_DISPLAY=wayland-0"
Environment="QT_QPA_PLATFORM=wayland"
ExecStart=
ExecStart=/usr/bin/krdpserver -u btm -p ${KRDP_PASSWORD} --certificate %h/.config/krdp/cert.pem --certificate-key %h/.config/krdp/key.pem --virtual-monitor 1920x1080@1
  ```
]

// KRDPの起動と動作確認
#content-slide(title: "KRDPの起動と動作確認")[
  + systemctl --user daemon-reload
  + systemctl --user restart app-org.kde.krdpserver.service
  - KRDPが正常に起動していることを確認
  - MacなどでRDPクライアントを使って接続してみる
  - なお、20回ぐらいサーバ再起動しているので、もしかすると一部設定が間違ってる可能性があるので、参考程度にしてください。
]

// まとめ
#content-slide(title: "まとめ")[
  - 疲れた！
  - 次はGnome 50でやってみるぞ!(地獄)
]