import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomorrow_plan/todo_list_view.dart';
import 'package:tomorrow_plan/todo_view_model.dart';

final todoViewModelProvider = StateNotifierProvider(
  (ref) => TodoViewModel(),
);

void main() {
  runApp(
    ProviderScope(
      child: TodoListView(),
    ),
  );
}
