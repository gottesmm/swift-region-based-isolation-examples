
func assigningIsolationDomainsToIsolationRegions() async {
  // Regions: []

  let x = NonSendableKlass()
  // Regions: [(x)]

  let y = x
  // Regions: [(x, y)]

  await transferToMainActor(x)
  // Regions: [{(x, y), @MainActor}]

  print(y) // Error!
}
