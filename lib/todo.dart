import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo(
      {required this.id,
      required this.title,
      this.time,
      this.isDone = false,
      this.belong = Belong.None});

  final int id; //一意のid
  final String title; //タイトル
  final int? time; //所要時間(nullable)
  final bool isDone; //完了したかどうか
  final Belong belong; //やらない or 絶対やる or できればやる
}

enum Belong {
  None,
  Sure,
  Unsure,
}
