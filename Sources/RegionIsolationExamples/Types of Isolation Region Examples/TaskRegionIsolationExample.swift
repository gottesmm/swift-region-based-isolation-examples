
func nonIsolatedCallee(_ x: NonSendableKlass) async { }

func nonIsolatedCaller(_ x: NonSendableKlass) async {
  // Regions: [{(x), Task1}]

  // Not a transfer! Same Task! No Error!
  await nonIsolatedCallee(x)

  // Error!
  await transferToMainActor(x)
}
