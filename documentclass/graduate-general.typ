#import "../pages/graduate-cover.typ": graduate-cover
#import "../pages/graduate-title-zh.typ": graduate-title-zh
#import "../pages/graduate-title-en.typ": graduate-title-en
#import "../pages/graduate-decl.typ": graduate-decl
#import "../pages/bibliography.typ": bibliography-page
#import "../pages/template-individual.typ": template-individual
#import "../pages/outline.typ": figure-outline, main-outline, table-outline

#import "../utils/fonts.typ": *
#import "../utils/header.typ": footer, header
#import "../utils/fakebold.typ": show-cn-fakebold
#import "../utils/supplement.typ": show-set-supplement
#import "../utils/twoside.typ": show-twoside-pagebreak, twoside-numbering-footer, twoside-pagebreak
#import "../utils/near-chapter.typ": near-chapter
#import "../utils/bib-provider.typ": bib-provider
#import "../utils/structure.typ": abstractmatter, frontmatter, mainmatter
#import "../utils/appendix.typ": appendix
#import "../utils/flex-caption.typ": show-flex-caption

#import "../dependency/i-figured.typ"

#let show-outline(s) = {
  show outline.entry.where(level: 1): it => {
    let h = it.element
    let toc-page = here().page()

    // hide table of contents entry
    if h.location().page() == toc-page {
      return none
    }

    // hide caption for non-numbered headings
    if h.numbering == none {
      return it
    }

    let nums = counter(heading).at(h.location())
    let chap = nums.first()

    link(
      h.location(),
      it.indented(
        [第 #chap 章],
        it.inner(),
      ),
    )
  }

  s
}


#let graduate-general-default-info = (
  title: ("毕业论文/设计题目", ""),
  title-en: ("Graduation Project/Design Title", ""),
  grade: "20XX",
  student-id: "1234567890",
  clc: "O643.12",
  unitcode: "10335",
  reviewer: ("隐名", "隐名", "隐名", "隐名", "隐名"),
  committe: ("主席", "委员", "委员", "委员", "委员", "委员"),
  reviewer-en: ("Anonymous", "Anonymous", "Anonymous", "Anonymous", "Anonymous"),
  committe-en: ("Chair", "Committeeman", "Committeeman", "Committeeman", "Committeeman", "Committeeman"),
  secret-level: "无",
  author: "张三",
  department: "某学院",
  major: "某专业",
  degree: "硕士",
  field: "某方向",
  supervisor: "李四",
  submit-date: datetime.today(),
  defense-date: ("二一九三年六月", "September 2193"),
  logo-size: 0.15
)

#let graduate-general-set-style(
  doc,
  degree: "硕士",
  twoside: false,
) = {
  // Page geometry
  set page(
    paper: "a4",
    margin: (
      x: 3.2cm,
      y: 3.8cm,
      // bottom: 2.54cm + 12pt + 30pt,
      // top: 2.54cm + 12pt + 4mm,
    ),
  )
  show: show-twoside-pagebreak.with(twoside: twoside)


  // Header and footer
  set page(
    numbering: "1",
    header-ascent: 0.4cm,
    footer-descent: 0.4cm,
    header: header(
      left: [浙江大学#(degree)学位论文],
      right: near-chapter,
      size: 10.5pt,
    ),
    footer: twoside-numbering-footer,
  )

  // Paragraph and text
  set par(leading: 10pt, first-line-indent: (amount: 2em, all: true), justify: true)
  set text(font: 字体.仿宋, size: 字号.小四, lang: "zh", discretionary-ligatures: true)
  show: show-cn-fakebold
  set underline(offset: 0.2em)


  // Headings
  show heading: i-figured.reset-counters

  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    let reset-counters = i-figured.reset-counters(it, level: 1, extra-kinds: (), equations: true, return-orig-heading: false)
    let chap-num = context {
      counter(heading).display("1")
    }

    twoside-pagebreak
    v(22pt)

    align(
      center,
      text(size: 字号.小二, weight: "bold")[
        第 #chap-num 章 #it.body
      ],
    )

    reset-counters

    v(6pt)
  }

  show heading.where(level: 1): set text(size: 字号.小二)
  show heading.where(level: 2): set text(size: 字号.小三)
  show heading.where(level: 3): set text(size: 字号.四号)
  show heading.where(level: 4): set text(size: 字号.小四)
  show heading: set block(above: 1.5em, below: 1.5em)


  // Reference
  show: show-set-supplement
  show figure: i-figured.show-figure
  show math.equation.where(block: true): i-figured.show-equation
  show figure.where(kind: table): set figure.caption(position: top)

  show: show-flex-caption


  doc
}


#let graduate-general(
  info: (:),
  twoside: false,
  bibsource: "",
  bibmode: "citext",
) = {
  assert(bibmode == "citext" or bibmode == "bilingual")
  let info = graduate-general-default-info + info
  let individual = template-individual.with(outlined: true, titlelevel: 1, bodytext-settings: (size: 字号.小四))

  let bib = bib-provider(bibsource, mode: bibmode)
  let bibcontent = [
    #set par(leading: 0.55em)
    #set text(size: 字号.小四, font: 字体.宋体)

    #bib.bibcontent
  ]
  (
    pages: (
      cover: graduate-cover(info: info),
      title-zh: graduate-title-zh(info: info),
      title-en: graduate-title-en(info: info),
      decl: graduate-decl(),

      outline: {
        set outline(indent: 2.0em)
        set par(leading: 0.6em)

        show-outline(main-outline(outlined: true, titlelevel: 1))
      },

      figure-outline: {
        set par(leading: 0.6em)
        figure-outline(outlined: true, titlelevel: 1)
      },

      table-outline: {
        set par(leading: 0.6em)
        table-outline(outlined: true, titlelevel: 1)
      },

      individual: individual,
      bibliography: bibliography-page(bib: bibcontent, individual: individual),
    ),
    style: doc => {
      set document(title: info.title.join())
      let doc = graduate-general-set-style(doc, degree: info.degree, twoside: twoside)

      show: bib.bibshow
      bib.hiddenbib + doc
    },
  )
}
