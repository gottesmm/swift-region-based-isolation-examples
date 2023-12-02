
private actor Actor {
  func method() async {
    let x = NonSendableKlass()
    // Regions: [(x)]

    await transferToMainActor(x)
    // Regions: [{(x), @MainActor}]

    print(x) // Error! x being used outside of @MainActor isolated code.
  }
}
