struct NonSendableStruct {
  let letSendableField = SendableKlass()
  var varSendableField = SendableKlass()
  let ns = NonSendableKlass()
}

@MainActor func modifyOnMainActor(_ y: consuming NonSendableStruct) async {
  // These assignments only affect our parameter, not x in the callee.
  y.varSendableField = SendableKlass()
  y = NonSendableStruct()
}

func letExample() async {
  let x = NonSendableStruct()

  await modifyOnMainActor(x) // Transfer x, giving useValueOnMainActor a
                             // shallow copy of x.

  // We do not race with the assignment in modifyOnMainActor since the
  // assignment is to y, not to x. Since the fields are sendable, once
  // we avoid the race on accessing the field, we are safe.
  print(x.letSendableField)
  print(x.varSendableField)
}
