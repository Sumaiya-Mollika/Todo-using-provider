import 'package:flutter/material.dart';

class Task with ChangeNotifier{
  String ?title;
  bool completed;
  final String? id;
  Task({@required this.title, this.completed = false,this.id});

  void toggleCompleted() {
    completed = !completed;
  }
}