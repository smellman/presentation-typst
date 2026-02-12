// theme/theme.typ - カスタムプレゼンテーションテーマ
#import "@preview/polylux:0.4.0": *

// === カラーパレット ===
#let colors = (
  primary: rgb("#2563EB"),       // メインカラー（青）
  primary-dark: rgb("#1E40AF"),  // メインカラー（暗）
  secondary: rgb("#64748B"),     // サブカラー（グレー）
  accent: rgb("#F59E0B"),        // アクセントカラー（オレンジ）
  bg: rgb("#FFFFFF"),            // 背景色
  bg-light: rgb("#F8FAFC"),     // 背景色（薄）
  text: rgb("#1E293B"),          // テキスト色
  text-light: rgb("#64748B"),    // テキスト色（薄）
  heading: rgb("#0F172A"),       // 見出し色
  footer-bg: rgb("#F1F5F9"),    // フッター背景色
)

// === 共通設定 ===
#let slide-defaults(body) = {
  set text(font: "Noto Sans CJK JP", size: 20pt, fill: colors.text)
  set par(leading: 0.8em)
  set list(marker: text(fill: colors.primary, "●"), indent: 0.5em, spacing: 0.6em)
  set enum(indent: 0.5em, spacing: 0.6em)
  show heading: set text(fill: colors.heading)
  show link: set text(fill: colors.primary)
  show raw: set text(font: "Noto Sans CJK JP", size: 0.85em)
  body
}

// === イベントタイトル（state） ===
#let event-title-state = state("event-title", none)

// === フッター ===
#let footer-block() = {
  block(
    width: 100%,
    inset: (x: 1.5em, y: 0.4em),
    fill: colors.footer-bg,
  )[
    #set text(size: 10pt, fill: colors.text-light)
    #grid(
      columns: (1fr, 1fr),
      align(left, context {
        let t = event-title-state.get()
        if t != none { t }
      }),
      align(right, [#toolbox.slide-number / #toolbox.last-slide-number]),
    )
  ]
}

// === タイトルスライド ===
#let title-slide(
  title: none,
  subtitle: none,
  author: none,
  institution: none,
  date: none,
) = {
  slide({
    slide-defaults({
      set align(center + horizon)
      block(width: 100%, inset: (x: 2em))[
        #block(
          width: 60%,
          align(center, line(length: 100%, stroke: 2pt + colors.primary))
        )
        #v(0.5em)
        #text(size: 32pt, weight: "bold", fill: colors.heading, title)
        #if subtitle != none {
          v(0.3em)
          text(size: 20pt, fill: colors.secondary, subtitle)
        }
        #v(0.5em)
        #block(
          width: 60%,
          align(center, line(length: 100%, stroke: 2pt + colors.primary))
        )
        #v(1em)
        #if author != none {
          text(size: 18pt, fill: colors.text, author)
        }
        #if institution != none {
          v(0.3em)
          text(size: 14pt, fill: colors.text-light, institution)
        }
        #if date != none {
          v(0.3em)
          text(size: 14pt, fill: colors.text-light, date.display("[year]/[month]/[day]"))
        }
      ]
    })
  })
}

// === コンテンツスライド ===
#let content-slide(title: none, body) = {
  slide({
    slide-defaults({
      // ヘッダー
      if title != none {
        block(
          width: 100%,
          inset: (x: 1.5em, top: 1em, bottom: 0.5em),
          below: 0pt,
        )[
          #text(size: 26pt, weight: "bold", fill: colors.heading, title)
          #v(0.3em)
          #line(length: 100%, stroke: 1.5pt + colors.primary)
        ]
      }

      // コンテンツ
      block(
        width: 100%,
        height: 1fr,
        inset: (x: 2em, y: 0.8em),
        body,
      )

      // フッター
      footer-block()
    })
  })
}

// === セクションスライド ===
#let section-slide(title) = {
  slide({
    slide-defaults({
      set align(center + horizon)
      block(width: 100%, inset: (x: 2em))[
        #line(length: 40%, stroke: 2pt + colors.primary)
        #v(0.5em)
        #text(size: 30pt, weight: "bold", fill: colors.primary, title)
        #v(0.5em)
        #line(length: 40%, stroke: 2pt + colors.primary)
      ]
    })
  })
}

// === ページ設定（show rule） ===
#let presentation(
  title: none,
  author: none,
  date: none,
  event: none,
  ratio: "16-9",
  body,
) = {
  set page(
    paper: "presentation-" + ratio,
    fill: colors.bg,
    margin: 0pt,
  )
  set text(font: "Noto Sans CJK JP", size: 20pt, fill: colors.text)
  event-title-state.update(event)
  body
}
