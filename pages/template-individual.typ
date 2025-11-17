#import "../utils/fonts.typ": 字号, 字体
#import "../utils/datetime-display.typ": datetime-display
#import "../utils/twoside.typ": twoside-pagebreak

#let template-individual(
  outlined: false,
  indent-first-par: true,
  titlelevel: 2,
  bodytext-settings: (size: 字号.四号),
  pagetitle,
  s,
) = {
  context {
    twoside-pagebreak
    set text(font: 字体.仿宋)

    v(2em)

    show heading.where(level: titlelevel): it => {
      align(center, [
        #text(size: 字号.小二, weight: "bold")[#it.body]
        #v(1em)
      ])
    }

    heading(pagetitle, numbering: none, level: titlelevel, outlined: outlined)

    block(width: 100%)[
      #set par(justify: true)
      #set text(..bodytext-settings)

      #s
    ]


    twoside-pagebreak
  }
}
