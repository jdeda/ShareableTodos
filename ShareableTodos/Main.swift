import SwiftUI

@main
struct ShareableTodosApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        AppView(store: .init(
          initialState: .init(viewState: .init(
            todos: .init(uniqueElements: Todo.mock.map { .init(viewState: .init(todo: $0))})
          )),
          reducer: AppReducer(),
          prepareDependencies: {
            $0.uuid = .incrementing
          }
        ))
      }
    }
  }
}
