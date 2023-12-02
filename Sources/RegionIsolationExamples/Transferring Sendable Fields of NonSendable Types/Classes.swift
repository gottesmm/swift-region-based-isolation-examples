
class NonSendable {
  let letSendable = SendableKlass()
  var varSendable = SendableKlass()
  let ns = NonSendableKlass()
}

@MainActor func modifyOnMainActor(_ x: NonSendable) async {
  x.varSendable = SendableKlass()
}

func letSendableIsSafe() async {
  let x = NonSendable()
  await modifyOnMainActor(x)
  _ = x.letSendable // This is safe.
  _ = x.varSendable // Error! Use after transfer of mutable field that could
                    // race with a write to x.varSendable in modifyOnMainActor.
}

