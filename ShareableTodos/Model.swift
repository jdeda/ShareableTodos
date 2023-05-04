import Foundation
import Tagged

struct Todo: Identifiable, Equatable {
  typealias ID = Tagged<Self, UUID>
  
  let id: ID
  var description: String
  var isComplete: Bool
}

extension Todo {
  static let mock: [Todo] = [
    .init(id: .init(), description: "Wakeup", isComplete: true),
    .init(id: .init(), description: "Do Homework", isComplete: false),
    .init(id: .init(), description: "Play Vidoegames", isComplete: true),
    .init(id: .init(), description: "Do Keto", isComplete: false),
    .init(id: .init(), description: "Go to Bed", isComplete: false),
  ]
}
