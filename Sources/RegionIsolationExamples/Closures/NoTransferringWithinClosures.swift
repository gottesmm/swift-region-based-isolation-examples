
private func example() async {
  let x = NonSendableKlass()
  // Regions: [(x)]
  let closure: () async -> () = {
    // Error! Cannot transfer a captured closure parameter!
    await transferToMainActor(x)
  }
  _ = closure
}
