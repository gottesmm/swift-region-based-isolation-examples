
private class Client {
  var name: String
  var initialBalance: Double
  var friend: Client? = nil

  init(name: String, initialBalance: Double) {
    self.name = name
    self.initialBalance = initialBalance
  }

  func logToAuditStream() { print("Logging!") }
}

private actor ClientStore {
  var clients: [Client] = []

  static let shared = ClientStore()

  func addClient(_ c: Client) {
    clients.append(c)
  }
}

func separateValuesInSeparateRegions() async {
  let john = Client(name: "John", initialBalance: 0)
  let joanna = Client(name: "Joanna", initialBalance: 0)

  await ClientStore.shared.addClient(john)
  await ClientStore.shared.addClient(joanna) // (1)
}

func separateValuesBecomePartOfSameRegionThroughAssignment() async {
  let john = Client(name: "John", initialBalance: 0)
  let joanna = Client(name: "Joanna", initialBalance: 0)

  john.friend = joanna // (1)

  await ClientStore.shared.addClient(john)
  await ClientStore.shared.addClient(joanna) // (2)
}
