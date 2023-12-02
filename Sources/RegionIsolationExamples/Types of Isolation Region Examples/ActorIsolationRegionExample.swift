private actor Actor {
  var nonSendable: NonSendableKlass

  init() {
    nonSendable = NonSendableKlass()
  }
}

@MainActor func actorRegionExample() async {
  let a = Actor()
  // Regions: [{(a.nonSendable), a}]

  let x = await a.nonSendable // Error!
  _ = x

  await transferToMainActor(a.nonSendable) // Error!
}
