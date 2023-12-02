
extension NonSendableKlass {
  func doSomething(_ other: NonSendableKlass) {}
}

func nonIsolated(_ arg: NonSendableKlass) async {
  // Regions: [{(arg), Task1}]
  let x = NonSendableKlass()
  // Regions: [{(arg), Task1}, (x)]
  arg.doSomething(x)
  // Regions: [{(arg, x), Task1}]
  await transferToMainActor(x) // Error! 'x' is isolated to 'Task1'
}
