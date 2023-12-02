
extension NonSendableKlass {
  var name: String { "123" }

  func doSomething() {}
}

private actor MyActor6 {
  func synchronousNonIsolatedNonSendableClosure() async {
    // This is non-Sendable and nonisolated since it does not capture MyActor or
    // any field of my actor.
    let nonSendable = NonSendableKlass()
    let closure: () -> () = {
      print("I am in a closure: \(nonSendable.name)")
    }

    // We can safely transfer closure.
    await transferToMainActor(closure)

    // If we were to invoke closure again, an error diagnostic would be
    // emitted.
    if booleanFlag {
      closure() // Error!
    } else {
      // If we were to access nonSendable, an error diagnostic would be
      // emitted.
      nonSendable.doSomething() // Error!
    }
  }
}
