
private class Client {
  var name: String
  var initialBalance: Double

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

// MARK: Example 1
private func openNewAccount(name: String, initialBalance: Double) async {
  let client = Client(name: name, initialBalance: initialBalance)
  await ClientStore.shared.addClient(client) // Error! 'Client' is non-`Sendable`!
}

// MARK: Example 2
private func openNewAccountError(name: String, initialBalance: Double) async {
  let client = Client(name: name, initialBalance: initialBalance)
  await ClientStore.shared.addClient(client)
  client.logToAuditStream()
}
