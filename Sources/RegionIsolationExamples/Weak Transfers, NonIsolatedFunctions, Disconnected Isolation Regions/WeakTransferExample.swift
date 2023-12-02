
private actor MyActor7 {
  var state: NonSendableKlass

  init() { state = NonSendableKlass() }

  func example() async {
    // Regions: [{(), self}]

    let x = NonSendableKlass()
    // Regions: [(x), {(), self}]

    // While nonIsolatedCallee executes the regions are:
    // Regions: [{(x), Task}, {(), self}]
    await nonIsolatedCallee(x)
    // Once it has finished executing, 'x' is disconnected again
    // Regions: [(x), {(), self}]

    // 'x' can be used since it is disconnected again.
    useValue(x) // (1)

    // 'x' can be transferred since it is disconnected again.
    await transferToMainActor(x) // (2)

    // Error! After transferring to main actor, permanently
    // in main actor, so we can't use it.
    useValue(x) // (3)
  }
}
