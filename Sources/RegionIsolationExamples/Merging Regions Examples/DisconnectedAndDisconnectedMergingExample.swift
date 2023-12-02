
func disconnectedAndDisconnectedMergingExample() async {
  let x = NonSendableKlass()
  // Regions: [(x)]
  let y = NonSendableKlass()
  // Regions: [(x), (y)]
  useValue(x, y)
  // Regions: [(x, y)]

  // Since they are in the same region, using y after transferring x is
  // an error.
  await transferToMainActor(x)
  useValue(y)
}
