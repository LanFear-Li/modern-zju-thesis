#let near-chapter = context {
  let headings_after = query(selector(heading.where(level: 1)).after(here()))
  let headings_before = query(selector(heading.where(level: 1)).before(here()))


  if headings_after.len() == 0 {
    return
  }

  let pick-heading = () => {
    let heading = headings_after.first()
    if heading.location().page() > here().page() {
      if headings_before.len() == 0 {
        return none
      }
      headings_before.last()
    } else {
      heading
    }
  }

  let target = pick-heading()
  if target.numbering == none {
    target.body
  } else {
    let nums = counter(heading).at(target.location())
    if nums.len() == 0 {
      target.body
    } else {
      let chap = str(nums.first())
      [第 #chap 章 #target.body]
    }
  }
}
