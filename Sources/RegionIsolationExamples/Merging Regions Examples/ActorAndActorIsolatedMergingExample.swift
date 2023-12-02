
fileprivate actor MyActor1 {
  func useNS(_ x: NonSendableKlass) {}
}

func test1() async {
  let a1 = MyActor1()
  // Regions: [{(), a1}]
  let a2 = MyActor1()
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

func test2() async {
  let a1 = MyActor1()
  // Regions: [{(), a1}]
  let a2 = MyActor1()
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
  await transferToMainActor(x)
}
