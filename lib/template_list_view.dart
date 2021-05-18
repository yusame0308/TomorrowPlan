import 'package:flutter/material.dart';
import 'package:tomorrow_plan/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tomorrow_plan/todo.dart';
import 'package:tomorrow_plan/todo_list_view.dart';

class TemplateListView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final todoState = useProvider(todoViewModelProvider);
    final _todoList = todoState.todoList;
    return Scaffold(
      appBar: AppBar(
        title: Text('やることリスト'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              transitionToNextScreen(context, Const.routeNameUpsertTodo);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final _todo = _todoList[index];
          return Card(
            elevation: 2,
            child: Dismissible(
              key: UniqueKey(),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_todo.title),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_sharp,
                          size: 14,
                          color: Colors.teal[300],
                        ),
                        Text(
                          '20',
                          style: TextStyle(
                            color: Colors.teal[300],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  transitionToNextScreen(context, Const.routeNameUpsertTodo,
                      todo: _todo);
                },
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final result = await showDialog<Belong>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('追加'),
                          content: Text('${_todo.title}を明日やることに追加しますか？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context
                                    .read(todoViewModelProvider.notifier)
                                    .updateTodo(
                                        id: _todo.id,
                                        title: _todo.title,
                                        isDone: _todo.isDone,
                                        belong: Belong.Sure);
                                Navigator.pop(context, Belong.Sure);
                              },
                              child: const Text('絶対やる'),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read(todoViewModelProvider.notifier)
                                    .updateTodo(
                                        id: _todo.id,
                                        title: _todo.title,
                                        isDone: _todo.isDone,
                                        belong: Belong.Unsure);
                                Navigator.pop(context, Belong.Unsure);
                              },
                              child: const Text('できればやる'),
                            ),
                          ],
                        );
                      },
                    );
                    if (result == Belong.Sure) {
                      Navigator.pop(context, '明日、${_todo.title}を絶対にやります');
                    } else if (result == Belong.Unsure) {
                      Navigator.pop(context, '明日、${_todo.title}をできればやります');
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
