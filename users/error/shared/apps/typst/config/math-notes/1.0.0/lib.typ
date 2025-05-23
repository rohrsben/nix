#import "@preview/ctheorems:1.1.3": *

#let notes(title, doc) = {
  show: thmrules

  set page(margin: 1.0cm)
  set text(size: 12pt)

  align(center, text(18pt, title))

  doc
}

#let hw(title, doc) = {
  show: thmrules

  set page(margin: 1.0cm)
  set text(size: 12pt)

  align(center, text(18pt, title))
  align(center, text(16pt, "Benjamin Rohrs"))

  doc
}

#let thm = thmbox(
  "theorem",
  "Theorem",
  fill: rgb("#e8e8f8")
)

#let lem = thmbox(
  "theorem",
  "Lemma",
  fill: rgb("#efe6ff")
)

#let cor = thmbox(
  "corollary",
  "Corollary",
  base: "theorem",
  fill: rgb("#f8e8e8")
)

#let proof = thmproof("proof", "Proof")

#let def = thmbox(
  "definition",
  "Definition",
  base_level: 1,
  stroke: rgb("#6688ff") + 1pt
)

#let q = thmbox(
  "question",
  "Question",
  stroke: rgb("#e06060") + 1pt
).with(numbering: none)

#let trans = text(fill: olive, $thick thick thin arrow.r.filled thick thick thin $)
#let spc = text($thick thin$)

#let ex = thmbox(
  "exercise",
  "Exercise",
  base_level: 0,
  stroke: rgb("#000000") + 1pt
).with(numbering: "1")

#let i = thmbox(
  "issue",
  "Issue",
  base_level: 0,
  stroke: rgb("#e06060") + 1pt
)

#let about(section, remarks, current_score) = {
  list(
    text(strong("Section: ") + section),
    text(strong("Grader remarks: ") + remarks),
    text(strong("Current score: ") + current_score)
  )
}

#let r = thmplain(
  "rebuttal",
  "Rebuttal",
  base_level: 0,
  titlefmt: smallcaps,
).with(numbering: none)
