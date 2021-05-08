import 'package:flutter/material.dart';
import 'package:tomorrow_plan/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tomorrow_plan/todo.dart';

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
              context
                  .read(todoViewModelProvider.notifier)
                  .createTodo(title: 'やること');
            },
          ),
        ],
      ),
      body: ListView.builder(
        // padding: const EdgeInsets.all(16),
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final _todo = _todoList[index];
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
              title: Text(_todo.title),
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
          );
        },
      ),
    );
  }
}
