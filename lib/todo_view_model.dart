import 'package:tomorrow_plan/todo.dart';
import 'package:tomorrow_plan/todo_state.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

class TodoViewModel extends StateNotifier<TodoState> {
  TodoViewModel() : super(const TodoState());

  void createTodo({required String title, int? time}) {
    final uuid = Uuid();
    final id = uuid.v4();
    final newList = [...state.todoList, Todo(id: id, title: title, time: time)];
    saveTodo(newList);
  }

  void updateTodo(
      {required String id,
      required String title,
      int? time,
      required bool isDone,
      required Belong belong}) {
    final newList = state.todoList
        .map((todo) => todo.id == id
            ? Todo(
                id: id,
                title: title,
                time: time,
                isDone: isDone,
                belong: belong)
            : todo)
        .toList();
    saveTodo(newList);
  }

  void deleteTodo(String id) {
    final newList = state.todoList.where((todo) => todo.id != id).toList();
    saveTodo(newList);
  }

  void saveTodo(List<Todo> newList) {
    state = state.copyWith(todoList: newList);
    //shared_preferencesに保存
  }
}
