
private actor Actor {
  func useNS(_ x: NonSendableKlass) {}
}

func invalidActorRegionIsOkAsLongAsYouDontUseValue() async {
  let a1 = Actor()
  // Regions: [{(), a1}]
  let a2 = Actor()
  // Regions: [{(), a1}, {(), a2}]
  let x = NonSendableKlass()
  // Regions: [{(), a1}, {(), a2}, (x)]

  if booleanFlag {
    await a1.useNS(x)
    // Regions: [{(x), a1}, {(), a2}]
  } else {
    await a2.useNS(x)
    // Regions: [{(), a1}, {(x), a2}]
  }

  // Regions: [{(x), invalid}, {(), a1}, {(), a2}]
}

func invalidActorRegionErrorsIfYouUseValue() async {
  let a1 = Actor()
  // Regions: [{(), a1}]
  let a2 = Actor()
  // Regions: [{(), a1}, {(), a2}]
  let x = NonSendableKlass()
  // Regions: [{(), a1}, {(), a2}, (x)]

  if booleanFlag {
    await a1.useNS(x)
    // Regions: [{(x), a1}, {(), a2}]
  } else {
    await a2.useNS(x)
    // Regions: [{(), a1}, {(x), a2}]
  }

  // Regions: [{(x), invalid}, {(), a1}, {(), a2}]
  useValue(x) // Error!
}

