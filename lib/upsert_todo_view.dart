import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tomorrow_plan/todo.dart';
import 'package:tomorrow_plan/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpsertTodoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo?;
    return Scaffold(
      appBar: AppBar(
        title: Text('やることを${todo == null ? '作成' : '編集'}'),
      ),
      body: TodoForm(),
    );
  }
}

//ignore: must_be_immutable
class TodoForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo?;
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              initialValue: todo != null ? todo.title : '',
              maxLength: 20,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: const InputDecoration(
                hintText: 'Todoタイトルを入力してください',
                labelText: 'Todoタイトル',
              ),
              validator: (String? title) {
                return title!.isEmpty ? 'Todoタイトルを入力してください' : null;
              },
              onSaved: (String? title) {
                _title = title!;
              },
            ),
            ElevatedButton(
              onPressed: () => _submission(context, todo),
              child: Text('Todoを${todo == null ? '作成' : '更新'}する'),
            )
          ],
        ),
      ),
    );
  }

  void _submission(BuildContext context, Todo? todo) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (todo != null) {
        context.read(todoViewModelProvider.notifier).updateTodo(
            id: todo.id,
            title: _title,
            isDone: todo.isDone,
            belong: todo.belong);
      } else {
        context.read(todoViewModelProvider.notifier).createTodo(title: _title);
      }
      Navigator.pop(context, '$_titleを${todo == null ? '作成' : '更新'}しました');
    }
  }
}
