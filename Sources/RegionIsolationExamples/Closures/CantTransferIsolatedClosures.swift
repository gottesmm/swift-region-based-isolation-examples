
@MainActor func transferSynchronousClosure(_ f: () -> ()) async { }
@MainActor func transferAsynchronousClosure(_ f: () async -> ()) async { }

private actor MyActor3 {
  func doSomething() {}

  func isolatedSynchronousClosure() async {
    // This closure is isolated to actor since it captures self.
    let closure: () -> () = {
      self.doSomething()
    }

    // When we transfer the closure, we have lost the specific actor that
    // the closure belongs to so an error must be emitted!
    await transferSynchronousClosure(closure) // Error!
  }

  func isolatedSynchronousClosureThunkedToAsync() async {
    // This closure is isolated to actor since it captures self.
    let closure: () -> () = {
      self.doSomething()
    }

    // As part of transferring the closure, the closure is wrapped into an
    // asynchronous thunk that will hop onto the Actor's executor.
    await transferAsynchronousClosure(closure)
  }

  func isolatedAsynchronousClosure() async {
    // This async closure is isolated to actor since it captures self.
    let closure: () async -> () = {
      self.doSomething()
    }

    // Since the closure is async, we can transfer it as much as we want
    // since we will always invoke the closure within the actor's isolation
    // domain...
    await transferAsynchronousClosure(closure)

    // ... so this is safe as well.
    await transferAsynchronousClosure(closure)
  }
}
