
private actor MyActor4 {
  var ns: NonSendableKlass

  init() { ns = NonSendableKlass() }

  func useNonSendable(_ value: NonSendableKlass) { }

  func attemptToTransfer() async {
    let x = NonSendableKlass()
    // Regions: [(x), {(self.ns), self}]
    let closure: () -> () = { self.useNonSendable(x) }
    // Regions: [{(self.ns, x, closure), self}]
    await transferToMainActor(closure) // Error! Cannot transfer from actor region
    await transferToMainActor(x) // Error! Cannot transfer from actor region
  }

  func okToTransfer() async {
    let x = NonSendableKlass()
    // Regions: [(x)]
    let closure: () -> () = { print(x) }
    _ = closure
    // Regions: [(x, closure)]
    await transferToMainActor(x)
  }
}
