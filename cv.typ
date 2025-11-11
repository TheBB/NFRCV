#let nfrGray = luma(242)

#let renderDate(date) = {
  if type(date) == str or type(date) == int [
    #date
  ] else [
    #date.at(0)--#date.at(1)
  ]
}

#let dateTable(header, entries) = [
  #table(
    columns: (..range(header.len()).map(_ => auto), 1fr),
    fill: (x, y) => { if y == 0 { nfrGray } else { none }},
    table.header(none, ..header),
    ..entries.map(((x, ..y)) => (renderDate(x), ..y)).flatten(),
  )
]

#let role(role) = [
  *ROLE IN THE PROJECT*
  #h(1fr)
  #if role == "manager" [#sym.ballot.check.heavy] else [#sym.ballot]
  Project manager
  #h(1fr)
  #if role == "wp-leader" [#sym.ballot.check.heavy] else [#sym.ballot]
  Work package leader
  #h(1fr)
  #if role == "participant" [#sym.ballot.check.heavy] else [#sym.ballot]
  Project participant
]

#let personalia(
  name: "",
  dob: "",
  sex: "",
  nationality: "",
  orcid: none,
  link: none,
) = [
  = Personal information

  #table(
    columns: (auto, 1fr, auto, 1fr),
    fill: (x, y) => { if x == 0 or x == 2 { nfrGray } else { none } },
    [Family name, First name:],
    table.cell(name, colspan: 3),
    [Date of birth:],
    dob,
    [Sex:],
    sex,
    [Nationality:],
    table.cell(nationality, colspan: 3),
    [Researcher unique identifier:],
    table.cell(colspan: 3)[#if orcid != none [ORCID: #orcid]],
    [URL for personal website:],
    table.cell(colspan: 3)[#if link != none [#std.link(link)]],
  )
]

#let expertise(entries) = [
  = Key expertise for my role in the current application

  #box(fill: nfrGray, width: 100%, stroke: black, inset: 5pt)[
    #for entry in entries [
      *#entry.title:* #entry.description
      #parbreak()
    ]
  ]
]

#let education(entries) = [
  = Education

  #dateTable(
    (
      [Degree/Name of faculty/department, name of university],
    ),
    entries.map(x => (
      x.date,
      [*#x.degree - #x.field*, #x.issuer, #x.location],
    )),
  )
]

#let positions(current, entries) = [
  #set par(spacing: 0.5em)

  = Positions

  *Current Position*

  #dateTable(
    (
      [Job title - Employer - Country],
    ),
    (
      (
        current.date,
        [*#current.title*, #current.company, #current.department, #current.location],
      ),
    ),
  )

  *Previous positions held*

  #dateTable(
    (
      [Job title - Employer - Country],
    ),
    entries.map(x => (
      x.date,
      [*#x.title*, #x.company, #x.department, #x.location],
    )),
  )
]

#let awards(entries) = [
  = Fellowships, awards and prizes

  #dateTable(
    (
      [Name of institution/country],
    ),
    entries.map(x => (
      x.date,
      [*#x.name*, #x.details],
    )),
  )
]

#let mobility(entries) = [
  = Mobility

  #dateTable(
    (
      [Name of faculty/department/centre, name of university/institution/country],
    ),
    entries.map(x => (
      x.date,
      [*#x.title*, #x.details],
    )),
  )
]

#let projects(entries) = [
  = Project management and participation experience

  #dateTable(
    (
      [Project and role (WP: Work-package leader, TL: Task leader, P: Participant)/funding from],
    ),
    entries.map(x => (
      x.date,
      (
        (
          [*#x.title*],
          if x.at("description", default: none) != none [(#x.description)],
        ).filter(x => x != none).join(" "),
        if x.role == "manager" [*PM*],
        if x.role == "wp-leader" [*WP*],
        if x.role == "task-leader" [*TL*],
        if x.role == "participant" [*P*],
        x.at("funder", default: none),
        x.at("budget", default: none),
      ).filter(x => x != none).join(", "),
    ))
  )
]

#let supervision(entries) = [
  = Supervision of graduate students and research fellows

  #dateTable(
    (
      [No. of],
      [Type of Students],
      [University/institution - Country],
    ),
    entries.map(x => (
      x.date,
      [#x.number],
      x.type,
      x.location,
    )),
  )
]

#let software(entries) = [
  = Key software development

  #dateTable(
    (
      [Name],
      [Role],
      [Description],
    ),
    entries.map(x => (
      x.date,
      x.name,
      x.role,
      (
        x.description,
        if x.at("link", default: none) != none { [(#link(x.link)[web])] }
      ).filter(x => x != none).join(" ")
    ))
  )
]

#let teaching(entries) = [
  = Teaching activities

  #dateTable(
    (
      [Teaching position - topic, name of university/institution/country],
    ),
    entries.map(x => (
      x.date,
      [#x.course, #x.location]
    )),
  )
]

#let responsibilities(entries) = [
  = Institutional responsibilities

  #dateTable(
    (
      [Name of university/institution/country - and role],
    ),
    entries.map(x => (
      x.date,
      [*#x.role*, #x.description]
    )),
  )
]

#let collaborations(entries) = [
  = Major collaborations

  #table(
    columns: (1fr, 1fr),
    fill: (x, y) => { if y == 0 { nfrGray } else { none }},
    table.header([Name of institution], [Topic]),
    ..entries.map(x => (
      x.institution,
      x.topic,
    )).flatten(),
  )
]

#let dissemination(entries) = [
  = Research communication, dissemination or outreach activities

  #dateTable(
    (
      [Name],
    ),
    entries.map(x => (
      x.date,
      [#x.title, #x.venue]
    )),
  )
]

#let trackrecord(references) = [
  #text(
    size: 15pt,
    weight: "bold",
  )[Track record]

  #for label in references.citations {
    cite(std.label(label), form: none)
  }

  #bibliography(
    references.sources,
    title: none,
  )
]

#let cv(personal, project) = {
  set text(
    font: "Carlito",
    size: 10pt,
  )

  show heading.where(level: 1): upper
  show heading.where(level: 1): set text(size: 10pt, weight: "bold")
  show heading.where(level: 1): set block(above: 1.6em)

  show title: set block(below: 1.2em)

  set document(
    title: [Curriculum vitae for #personal.personalia.name]
  )

  title()
  role(project.role)
  personalia(..personal.personalia)
  expertise(project.expertise)
  education(personal.education)
  positions(personal.positions.current, personal.positions.previous)
  awards(personal.awards)
  mobility(personal.mobility)
  projects(personal.projects)
  supervision(personal.supervision)
  software(personal.software)
  teaching(personal.teaching)
  responsibilities(personal.responsibilities)
  collaborations(personal.collaborations)
  dissemination(personal.dissemination)
  trackrecord(personal.references)
}
