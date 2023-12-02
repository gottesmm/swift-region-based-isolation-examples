
fileprivate actor MyActor2 {
  func useNS(_ x: NonSendableKlass) {}
}

extension NonSendableKlass {
  func useNS(_ x: NonSendableKlass) {}
}

func example1(_ arg: NonSendableKlass) async {
  // Regions: [{(arg), Task1}]
  let a = MyActor2()
  // Regions: [{(), a}, {(arg), Task1}]
  let x = NonSendableKlass()
  // Regions: [(x), {(), a}, {(arg), Task1}]

  if booleanFlag {
    await a.useNS(x)
    // Regions: [{(x), a}, {(arg), Task1}]
  } else {
    arg.useNS(x)
    // Regions: [{(), a}, {(arg, x), Task1}]
  }

  // Regions: [{(arg, x), invalid}, {(), a}, {(), Task1}]
}

func example2(_ arg: NonSendableKlass) async {
  // Regions: [{(arg), Task1}]
  let a = MyActor2()
  // Regions: [{(), a}, {(arg), Task1}]
  let x = NonSendableKlass()
  // Regions: [(x), {(), a}, {(arg), Task1}]

  if booleanFlag {
    await a.useNS(x)
    // Regions: [{(x), a}, {(arg), Task1}]
  } else {
    arg.useNS(x)
    // Regions: [{(), a}, {(arg, x), Task1}]
  }

  // Regions: [{(arg, x), invalid}, {(), a}, {(), Task1}]
  await transferToMainActor(x)
}
