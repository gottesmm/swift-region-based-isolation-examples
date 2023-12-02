private struct NonSendableStruct2 {
  let letSendableField = SendableKlass()
  var varSendableField = SendableKlass()
  let ns = NonSendableKlass()

  init() {
  }

  init(otherInit: ()) {

  }
}

@MainActor func invokeOnMain(_ f: () -> ()) async {
  f()
}

func unsafeMutableReferenceCaptureExample() async {
  var x = NonSendableStruct2()
  let closure = {
    x = NonSendableStruct2(otherInit: ())
  }
  await invokeOnMain(closure)

  if booleanFlag {
    _ = x.letSendableField // Error! Could race against write in closure!
  } else {
    _ = x.varSendableField // Error! Could race against write in closure!
  }
}
