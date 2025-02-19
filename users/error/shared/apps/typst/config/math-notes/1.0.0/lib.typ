#import "@preview/ctheorems:1.1.3": *

#let notes(title, doc) = {
    show: thmrules

    set page(margin: 1.0cm)
    set text(size: 12pt)

    align(center, text(18pt, title))

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
