
class NonSendableKlass {
  var integerField = 6
}

final class SendableKlass : Sendable {}

actor GlobalActorInstance {}

@globalActor
struct GlobalActor {
  static let shared = GlobalActorInstance()
}

@MainActor func transferToMainActor<T>(_ t: T) async {}
@MainActor func transferToMainActor<T, U>(_ t: T, _ u: U) async {}
func useValue<T>(_ t: T) {}
func useValue<T, U>(_ t: T, _ u: U) {}

var booleanFlag: Bool { false }
