
private func example() async {
  let x = NonSendableKlass()
  // Regions: [(x)]
  let y = NonSendableKlass()
  // Regions: [(x), (y)]
  let closure = { useValue(x, y) }
  // Regions: [(x, y, closure)]
  await transferToMainActor(closure)

  // Error! Since x and y are both in the closure.
  if booleanFlag {
    useValue(x)
  } else {
    useValue(y)
  }
}
