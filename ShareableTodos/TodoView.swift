import SwiftUI
import ComposableArchitecture

struct TodoView: View {
  let store: StoreOf<TodoReducer>
  
  var body: some View {
    WithViewStore(store, observe: \.viewState) { viewStore in
      HStack {
        Button {
          viewStore.send(.todoIsCompleteToggled)
        } label: {
          Image(systemName: viewStore.todo.isComplete ? "checkmark.square" : "square")
        }
        .buttonStyle(.plain)
        
        TextField("", text: viewStore.binding(
          get: { $0.todo.description},
          send: { .todoDescriptionEdited($0) }
        ))
      }
      .foregroundColor(viewStore.todo.isComplete ? .secondary : .primary)
      .strikethrough(viewStore.todo.isComplete)
      .swipeActions {
        Button.init(role: .destructive) {
          viewStore.send(.delegate(.todoSwipedToDelete))
        } label: {
          Image(systemName: "trash")
        }
      }
    }
  }
}

struct TodoReducer: Reducer {
  struct State: Equatable, Identifiable {
    var id: Todo.ID { viewState.todo.id }
    var viewState: ViewState
  }
  
  enum Action: Equatable {
    case todoIsCompleteToggled
    case todoDescriptionEdited(String)
    case delegate(DelegateAction)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .todoIsCompleteToggled:
        state.viewState.todo.isComplete.toggle()
        return .none
      case let .todoDescriptionEdited(newDescription):
        state.viewState.todo.description = newDescription
        return .none
      case .delegate:
        return .none
      }
    }
  }
}

extension TodoReducer {
  enum DelegateAction {
    case todoSwipedToDelete
  }
}
extension TodoReducer {
  struct ViewState: Equatable {
    var todo: Todo
  }
}

struct TodoView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      TodoView(store: .init(
        initialState: .init(
          viewState: .init(
            todo: .init(id: .init(), description: "Write Swift", isComplete: true)
          )
        ),
        reducer: TodoReducer(),
        prepareDependencies: { _ in
          
        }
      ))
    }
  }
}
