
func nonIsolatedCalleeWithResult(_ x: NonSendableKlass) async -> Int { 5 }
@MainActor func transferToMainActorAndReturnInt<T>(_ t: T) -> Int { 5 }
func useValueAndReturnInt<T>(_ t: T) -> Int { 8 }

actor MyActor {
  var field = NonSendableKlass()

  func actorIsolatedFieldsCannotBeUsedInAsyncLet() async {
    // Regions: [{(self.field), self}]
    async let value = transferToMainActor(field) // Error! Cannot transfer actor
                                                 // isolated field to
                                                 // @MainActor!
    _ = await value
  }

  func untransferAfterAsyncLetFinishes() async {
    // Regions: [{(), self}]
    let x = NonSendableKlass()
    // Regions: [(x), {(), self}]
    async let value = nonIsolatedCalleeWithResult(x) + x.integerField
    // Regions: [{(x), Task}, {(), self}]
    useValue(x) // Error! Illegal to use x here.
    _ = await value
    // Regions: [(x), {(), self}]
    useValue(x) // Ok! x is disconnected again so it can be used...
    await transferToMainActor(x) // and even transferred to another actor.
  }
}

func transferIntoActorRegionStaysInActorRegion() async {
  // Regions: []
  let x = NonSendableKlass()
  // Regions: [(x)]
  async let y = transferToMainActorAndReturnInt(x) // Transferred here.
  // Regions: [{(x), @MainActor}]
  _ = await y
  // Regions: [{(x), @MainActor}]
  useValue(x) // Error! x is used after it has been transferred!
}

func errorsIfUseValueMultipleTimesInAsyncLet() async {
  // Regions: []
  let x = NonSendableKlass()
  // Regions: [(x)]
  async let y =
    transferToMainActorAndReturnInt(x) +
    useValueAndReturnInt(x) // Error! Cannot use x after it has been transferred!
  _ = await y
}

func errorsIfUseValueInDifferentAsyncLet() async {
  // Regions: []
  let x = NonSendableKlass()
  // Regions: [(x)]
  async let y = x,
            z = x // Error! Cannot use x after it has been transferred!
  _ = await y
  _ = await z
}
