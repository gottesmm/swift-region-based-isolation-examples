private class NonSendableLinkedList {
  var next: NonSendableLinkedList?

  init() { next = nil }
}

private actor Actor {
  var listHead = NonSendableLinkedList()

  func method() async {
    // Regions: [{(self.listHead, self.listHead.next, ...), self}]

    let x = self.listHead
    // Regions: [{(x, self.listHead, self.listHead.next, ...), self}]
    await transferToMainActor(x) // Error b/c in actor region

    let z = self.listHead.next!
    // Regions: [{(x, z, self.listHead, self.listHead.next, ...), self}]
    await transferToMainActor(z) // Error b/c in actor region

  }
}
