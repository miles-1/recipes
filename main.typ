// general set rules
#set text(font: "Avenir")
#set par(
  first-line-indent: 0.5cm,
  spacing: 9pt,
)
#set page(
  margin: 0.5cm,
  numbering: "1",
  number-align: center,
  footer-descent: -10pt,
  width: 450pt * 1.2,
  height: 550pt * 1.2,
  columns: 2,
)

// small content functions and variables
#let group-num = "A"
#let group-divide-color = maroon
#let u(txt) = text(weight: "black", txt)
#let i(txt) = text(eastern, weight: "black", txt)
#let g(num, p: true) = [#if p [(];group *#text(group-divide-color, numbering(group-num, num))*#if p [)]]
#let gg(num) = g(num, p: false)
#let status(txt, supp: "") = text(luma(70%))[#v(0cm) #align(right)[_#supp #txt;_]]
#let colors = (
  "#D88C9A",
  "#F2D0A9",
  "#F1E3D3",
  "#99C1B9",
  "#8E7DBE",
)
#let frac(num1, num2, inch: false) = [#h(0.15cm)#box[
    #place(
      top + left,
      dx: -4pt,
      dy: 0pt,
      text(8pt)[#num1],
    )\/#place(
      bottom + right,
      dx: 4pt,
      text(8pt)[#num2],
    )#if inch {
      place(
        top + right,
        dx: 9pt,
        text(8pt)["],
      )
    }]#h(if inch { 0.3cm } else { 0.15cm })
]
#let half = frac(1, 2)
#let half-in = frac(1, 2, inch: true)

// ingredients list functions
#let group-counter = counter("ingredients-group")
#let ingredient-entry(elems) = if type(elems) == array {
  (
    u(elems.at(0)),
    [#set par(hanging-indent: 15pt);#i(elems.at(1)) #elems.at(2, default: []) #parbreak()],
  )
} else if type(elems) == int {
  (
    table.hline(stroke: (paint: group-divide-color, dash: "dotted")),
    table.cell(
      colspan: 2,
      inset: (bottom: -5pt),
      place(top + right, dx: 1pt, dy: -2pt)[#group-counter.step()#context text(
          7pt,
          group-divide-color,
        )[#group-counter.display(group-num) ↓]],
    ),
  )
} else {
  (
    table.hline(stroke: (paint: group-divide-color, dash: "dotted")),
  )
}
#let ingredient-table(ingredients-array) = {
  group-counter.update(0)
  block(
    inset: (left: 25pt, right: 5pt),
    table(
      columns: 2,
      inset: (x, y) => (left: 5pt * int(x == 1), top: 5pt, right: 1pt + 10pt * int(x == 1), bottom: 5pt),
      stroke: none,
      align: (x, y) => if x == 0 { right } else { left },
      ..for ing in ingredients-array { ingredient-entry(ing) }
    ),
  )
}

// recipe function
#let recipe-types = ("side", "main", "treat")
#let recipe(
  recipe-type,
  title,
  ingredients,
  description,
  is-vegan: false,
  is-vegetarian: false,
  adapted-from: none,
  bon-appetit: true,
) = {
  assert(recipe-type in recipe-types, message: "bad recipe type >:(")
  let dietary-type = if is-vegan { "vegan" } else if is-vegetarian { "vegetarian" } else { none }
  return (
    recipe-type: recipe-type,
    title: title,
    content: [
      #show heading: title => align(center, underline(text(15pt, title), offset: 7pt, extent: -9pt))
      == #title
      #if dietary-type != none {
        place(
          top + right,
          circle(
            radius: 7pt,
            inset: 0pt,
            fill: green.darken(10%).desaturate(50%),
            text(7pt, white)[#set align(center + horizon); #if dietary-type == "vegan" { [V#h(1pt);V] } else { [V] }],
          ),
        )
      }
      #v(0.2cm)
      #if adapted-from != none { status(adapted-from, supp: "adapted from" + if bon-appetit { " Bon Appétit" }) }
      #v(0.2cm)
      #ingredient-table(ingredients)
      #v(0.3cm)
      #description
      #colbreak()
    ],
  )
}

// heading styling
#let category-counter = counter("category")
#show heading.where(level: 1): it => context {
  let next-section-location = query(selector(heading.where(level: 1)).after(here(), inclusive: false))
    .at(0, default: query(<end>).at(0))
    .location()
  let child-heading-selector = selector(heading).after(here()).before(next-section-location, inclusive: false)
  let heading-count = category-counter.get().first()
  let page-color = rgb(colors.at(calc.rem(heading-count, colors.len())))
  {
    set page(
      fill: page-color.lighten(30%),
      background: rect(width: 100% - 20pt, height: 100% - 20pt, stroke: page-color.saturate(20%) + 5pt),
      numbering: none,
      margin: 10%,
      columns: 1,
    )
    category-counter.step()
    v(2cm)
    text(22pt, align(center, [\- #h(0.5cm) #it.body #h(0.5cm) \-]))
    v(1cm)
    outline(
      title: none,
      target: if heading-count == 0 { selector(heading.where(level: 1)).after(here()) } else { child-heading-selector },
      indent: 0pt,
    )
  }
}

// all recipes
#let all_recipes = (
  recipe(
    "main",
    "pork and cucumber stir-fry",
    adapted-from: "May 25 p38",
    (
      ([1 lb], [ground pork]),
      ([2 cup], [dry rice], [cooked]),
      1,
      (
        [3],
        [cucumbers],
        [zebra-peeled, halved lengthwise, seeds removed, sliced diagonally #u[#half-in] thick],
      ),
      ([1 tsp], [salt]),
      2,
      ([3 Tbsp], [oyster sauce]),
      ([3 Tbsp], [soy sauce]),
      ([3 Tbsp], [dry white wine]),
      3,
      ([2-3], [jalapeños], [no seeds, thinly sliced]),
      ([1 Tbsp], [ginger powder]),
      ([2], [garlic cloves], [grated]),
      ([1 tsp], [pepper]),
    ),
    [
      Form #i[pork] into several patties, season lightly with salt. Set aside.

      Toss #i[cucumber] with #i[salt] #g(1) in medium bowl. Let sit until cucumber starts releasing its water, about #u[10 mins]. While waiting, mix wets #g(2) to make sauce, set aside\*.

      Rinse, drain and pat dry #i[cucumber]. Heat #u[1 Tbsp] oil in large skillet at #u[medium-high] and cook, tossing frequently, until lightly browned. Remove and set aside.

      Cook #i[pork] patties in skillet until deeply browned on both sides, about #u[5 mins] per side. Break up into bite-sized pieces and add seasonings #g(3), cook another #u[1-2 mins].

      Add #i[cucumber] and \*reserved sauce to skillet, cook #u[\~1 min]. Add cooked #i[rice] on top.
    ],
  ),
  recipe(
    "main",
    "popover-topped pot pie",
    is-vegetarian: true,
    adapted-from: "May 25 p14",
    (
      ([12 oz], [golden potatoes], [#u(half-in) cubes]),
      1,
      ([1 bunch], [asparagus], [#u(half-in) pieces]),
      ([1-2 cup], [carrots], [#u[#frac(1, 4, inch: true)] sliced pieces]),
      ([2 stalks], [celery], [thinly sliced]),
      ([2], [yellow onions], [chopped]),
      ([1 cup], [frozen peas]),
      2,
      ([6], [garlic cloves], [grated]),
      ([#frac(1, 4) cup], [flour]),
      3,
      ([2 cup], [vegetable broth]),
      ([#half cup], [dry white wine]),
      ([#frac(2, 3) cup], [heavy cream]),
      ([1 Tbsp], [Dijon mustard]),
      ([3 Tbsp], [dill], [(save some for topping)]),
      ([1 tsp], [pepper]),
      ([1#half tsp], [lemon zest]),
      ([1#half tsp], [salt]),
      4,
      ([5], [eggs], [blended till fluffy]),
      ([#half tsp], [salt]),
      ([1#frac(1, 4) cup], [flour]),
      ([1 oz], [Parmesan], [grated]),
      ([1#frac(1, 3) cup], [whole milk]),
      ([#half tsp], [baking powder]),
    ),
    [
      Heat #u[#frac(1, 4) cup] #i[olive oil] in Dutch oven on #u[medium]. Cook #i[potatoes] for #u[2 mins], stirring often. Add veggies #g(1) and cook #u[15-18 mins]. Add #gg(2), stirring until homogenous. Add #gg(3) to pot while stirring. Simmer #u[\~1 min]. Take off heat, let sit withough stirring #u[20-60 mins].

      Prepare oven: middle rack, #u[425°]. Mix and briefly blend #gg(4) till smooth. Gently pour into pot. Bake until deep golden brown and puffed, #u[45-55 mins].
    ],
  ),
  recipe(
    "main",
    "oyakodon (parent and child)",
    adapted-from: "May 25 p18",
    (
      ([1#frac(1, 4) lb], [chicken], [preferrably thighs]),
      ([1#half], [dry rice], [cooked]),
      ([2 tsp], [Hondashi powder]),
      1,
      ([1], [yellow onion], [thinly sliced]),
      ([#frac(1, 4) cup], [soy sauce]),
      ([#frac(1, 4) cup], [sake]),
      ([1 Tbsp], [sugar]),
      none,
      ([3], [green onions], [pale and dark parts separated, thinly sliced]),
      ([5], [eggs], [blended]),
    ),
    [
      Mix #i[dashi] and #u[1#half cups] hot water in a skillet until dissolved. Add #gg(1) and immmer on #u[medium-high] until onion is slightly softened and liquid slightly reduced, #u[6-8 mins].

      Add #i[chicken] and #i[pale green onion] to pan. Cook until chicken is not pink on the outside, for #u[2-3 mins].

      Reduce heat to #u[medium], evenly drizzle half of #i[eggs]. Cover and simmer until eggs almost set, #u[\~2 mins]. Repeat with other half of eggs.

      Top with #i[dark green onion], serve over #i[rice].
    ],
  ),
  recipe(
    "main",
    "cauliflower chowder",
    is-vegetarian: true,
    adapted-from: "May 25 p22",
    (
      ([3 Tbsp], [butter]),
      1,
      ([1], [yellow onion], [finely chopped]),
      ([4], [celery stocks], [thinly sliced]),
      ([6], [garlic cloves], [finely chopped]),
      ([2 tsp], [thyme], [chopped]),
      ([1#half cup], [salt]),
      none,
      ([#frac(1, 4) cup], [flower]),
      2,
      ([1], [cauliflower head], [trimmed and cut into small florets]),
      ([10 oz], [golden potatoes], [cut into #u[#half-in] pieces]),
      ([1#half cup], [heavy cream], [chopped]),
      3,
      ([2 Tbsp], [butter], [melted]),
      ([3 cup], [crackers], [like oyster or Ritz, break up into smaller pieces if necessary]),
      ([2 tsp], [Old Bay seasoning]),
      none,
      ([2 Tbsp], [miso]),
      ([1], [green onion], [for chives]),
    ),
    [
      Heat #u[3 Tbsp] #i[butter] in Dutch oven over #u[medium]. Add #gg(1) and cook until onion is translucent, #u[6-8 mins]. Sprinkle in #i[flower] and stir #u[1 min]. Add #gg(2) and #u[4 cups] water. Simmer until veggies are tender and liquid is slightly thickened, stirring occasionally, #u[20-25 mins].

      Toss #gg(3) in a bowl. Set aside\*.

      Stir a few spoonfuls of soup in with #i[miso] separately, then stir into the pot.

      Serve with \*prepared crackers and #i[chives].
    ],
  ),
  // recipe(
  //   "main",
  //   "title",
  //   adapted-from: "May 25 p38",
  //   (
  //     ([1 lb], [ground pork], [wow]),
  //   ),
  //   [
  //     description
  //   ],
  // ),
)

= outline

#for i in recipe-types.map(it => [
  = #it;s
  #for j in all_recipes.filter(itt => itt.recipe-type == it) { j.content }
]) { i }

<end>
