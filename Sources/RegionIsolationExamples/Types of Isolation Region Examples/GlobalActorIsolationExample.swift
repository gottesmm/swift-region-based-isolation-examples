
private class NonSendableLinkedList<T> {
  var listHead: NonSendableLinkedListNode<T>?

  init() { listHead = nil }
}

private class NonSendableLinkedListNode<T> {
  var next: NonSendableLinkedListNode?
  var data: T?

  init() { next = nil }
}

@GlobalActor private var firstList = NonSendableLinkedList<Int>()
@GlobalActor private var secondList = NonSendableLinkedList<Int>()

@GlobalActor func useGlobalActor() async {
  // Regions: [{(firstList, secondList), @GlobalActor}]

  let x = firstList
  // Regions: [{(x, firstList, secondList), @GlobalActor}]
  await transferToMainActor(x) // Error! In Actor Region!

  let y = secondList.listHead!.next!
  // Regions: [{(x, firstList, secondList, y), @GlobalActor}]
  await transferToMainActor(y) // Error! In Actor Region!
}

