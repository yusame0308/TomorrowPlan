import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomorrow_plan/main.dart';
import 'package:tomorrow_plan/todo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.greenAccent),
      debugShowCheckedModeBanner: false,
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
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
