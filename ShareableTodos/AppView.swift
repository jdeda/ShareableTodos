import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: StoreOf<AppReducer>
  var body: some View {
    WithViewStore(store, observe: \.viewState) { viewStore in
      List {
        ForEachStore(store.scope(
          state: \.viewState.todos,
          action: AppReducer.Action.todo
        )) { childStore in
          TodoView(store: childStore)
        }
      }
      .navigationTitle("Todos")
      .toolbar {
        ToolbarItemGroup(placement: .primaryAction) {
          ShareLink(item: URL(string: "https://www.apple.com")!)
        }
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Text("\(viewStore.todos.count) todos")
          Spacer()
          Button {
            viewStore.send(.addTodoButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
          .foregroundColor(.primary)
          
        }
      }
    }
  }
}

struct AppReducer: Reducer {
  struct State: Equatable {
    var viewState: ViewState
  }
  
  
  enum Action: Equatable {
    case todo(TodoReducer.State.ID, TodoReducer.Action)
    case addTodoButtonTapped
  }
  
  @Dependency(\.uuid) var uuid
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .todo(todoReducerStateID, todoReducerAction):
        switch todoReducerAction {
        case let .delegate(action):
          switch action {
          case .todoSwipedToDelete:
            state.viewState.todos.remove(id: todoReducerStateID)
            return .none
          }
        default:
          return .none
        }
        
      case .addTodoButtonTapped:
        state.viewState.todos.append(.init(
          viewState: .init(
            todo: .init(
              id: .init(uuidString: uuid().uuidString)!,
              description: "Untitled Todo",
              isComplete: false
            )
          )
        ))
        return .none
      }
    }
    .forEach(\.viewState.todos, action: /Action.todo, element: TodoReducer.init)
  }
}

extension AppReducer {
  struct ViewState: Equatable {
    var todos: IdentifiedArrayOf<TodoReducer.State>
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
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
