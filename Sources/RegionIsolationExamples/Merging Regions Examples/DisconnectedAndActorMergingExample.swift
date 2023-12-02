
private actor MyActor5 {
  var field = NonSendableKlass()

  func myUseValue(_ t: NonSendableKlass) async {
  }

  func example1() async {
    // Regions: [{(self.field), self}]
    let x = NonSendableKlass()
    // Regions: [(x), {(self.field), self}]

    await self.myUseValue(x)
    // Regions: [{(x, self.field), self}]

    await transferToMainActor(x)

    useValue(x) // Error! 'x' is effectively isolated to 'a'

    let y = NonSendableKlass()
    // Regions: [{(x, a.field), a}, (y)]

    field = y
    // Regions: [{(x, a.field, y), a}]

    await transferToMainActor(y) // Error! 'y' is isolated to 'a'
  }
}
