struct NonSendableBox {
  var s1 = NonSendableKlass()
  var s2 = NonSendableKlass()
}

func mergeWhenAssignIntoMultiFieldStructField() async {
  var box = NonSendableBox()
  // Regions: [(box.s1, box.s1)]
  let x = NonSendableKlass()
  // Regions: [(box.s1, box.s2), (x)]
  let y = NonSendableKlass()
  // Regions: [(box.s1, box.s2), (x), (y)]
  box.s1 = x
  // Regions: [(box.s1, box.s2, x), (y)]
  // If we used an assignment operation instead of a merge operation,
  // this would cause us to lose that x was still in box.s1 and thus
  // in box's region.
  box.s2 = y
  // Regions: [(box.s1, box.s2, x, y)]

  // And then we wouldn't error here.
  await transferToMainActor(x)
  useValue(box)
}

func mergeWhenAssignIntoMultiFieldTupleField() async {
  var box = (NonSendableKlass(), NonSendableKlass())
  // Regions: [(box.0, box.1)]
  let x = NonSendableKlass()
  // Regions: [(box.0, box.1), (x)]
  let y = NonSendableKlass()
  // Regions: [(box.0, box.1), (x), (y)]
  box.0 = x
  // Regions: [(box.0, box.1, x), (y)]
  box.0 = y                              // (1)
  // Regions: [(box.0, box.1, x, y)]

  // And then we wouldn't error here.
  await transferToMainActor(x)
  useValue(box)
}

func mergeWhenAssignIntoMultiFieldTupleField2() async {
  var box = (NonSendableKlass(), NonSendableKlass())
  // Regions: [(box.0, box.1)]
  let x = NonSendableKlass()
  // Regions: [(box.0, box.1), (x)]
  let y = NonSendableKlass()
  // Regions: [(box.0, box.1), (x), (y)]
  box.0 = x
  // Regions: [(box.0, box.1, x), (y)]
  box = (y, NonSendableKlass())
  // Regions: [(box.0, box.1, y), (x)]

  // Because we assign above, we do not emit an error since x is considered to
  // be independent of box.
  await transferToMainActor(x)
  useValue(box)
}
