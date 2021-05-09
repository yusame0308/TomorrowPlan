import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tomorrow_plan/main.dart';
import 'package:tomorrow_plan/todo.dart';
import 'package:tomorrow_plan/template_list_view.dart';
import 'package:tomorrow_plan/upsert_todo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Const {
  static const routeNameTemplateList = 'template-list';
  static const routeNameUpsertTodo = 'upsert-todo';
}

Future<void> transitionToNextScreen(BuildContext context, String routeName,
    {Todo? todo}) async {
  final result = await Navigator.pushNamed(context, routeName, arguments: todo);

  if (result != null) {
    await Fluttertoast.showToast(
      msg: result.toString(),
      backgroundColor: Colors.grey,
      timeInSecForIosWeb: 2,
    );
  }
}

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.greenAccent),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        Const.routeNameTemplateList: (BuildContext context) =>
            TemplateListView(),
        Const.routeNameUpsertTodo: (BuildContext context) => UpsertTodoView(),
      },
      home: TodoList(),
    );
  }
}

class TodoList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('明日の予定'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                transitionToNextScreen(context, Const.routeNameTemplateList),
          ),
        ],
      ),
      body: SafeArea(child: _buildLists()),
    );
  }

  Widget _buildLists() {
    final todoState = useProvider(todoViewModelProvider);
    final _todoList = todoState.todoList;
    final _sureTodoList =
        _todoList.where((todo) => todo.belong == Belong.Sure).toList();
    final _unsureTodoList =
        _todoList.where((todo) => todo.belong == Belong.Unsure).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          color: Colors.grey[300],
          child: Text('絶対やる'),
        ),
        Expanded(
          child: _listView(_sureTodoList),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          color: Colors.grey[300],
          child: Text('できればやる'),
        ),
        Expanded(
          child: _listView(_unsureTodoList),
        ),
      ],
    );
  }

  Widget _listView(List<Todo> _todoList) {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: _dismissible(_todoList[index], context),
        );
      },
    );
  }

  Widget _dismissible(Todo todo, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        final confirmResult =
            await _showDeleteConfirmDialog(todo.title, context);
        return confirmResult;
      },
      onDismissed: (DismissDirection direction) {
        context.read(todoViewModelProvider.notifier).deleteTodo(todo.id);
        Fluttertoast.showToast(
          msg: '${todo.title}を削除しました',
          backgroundColor: Colors.grey,
          timeInSecForIosWeb: 2,
        );
      },
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: ListTile(
        title: Text(todo.title),
        onTap: () {
          transitionToNextScreen(context, Const.routeNameUpsertTodo,
              todo: todo);
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmDialog(
      String title, BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除'),
          content: Text('$titleを明日の予定から削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
