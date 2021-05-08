import 'package:flutter/material.dart';
import 'package:tomorrow_plan/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
              })
        ],
      ),
      body: ListView.builder(
        // padding: const EdgeInsets.all(16),
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_todoList[index].title),
          );
        },
      ),
    );
  }
}
