import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo({this.id, this.title, this.time, this.isDone, this.belong});

  final int id;
  final String title;
  final int time;
  final bool isDone;
  final Belong belong;
}

enum Belong {
  None,
  Sure,
  Unsure,
}
