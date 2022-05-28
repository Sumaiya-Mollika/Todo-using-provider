import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todos_app/model.dart';

class TodosModel extends ChangeNotifier {
  List<Task> _tasks = [];

  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(_tasks);
  UnmodifiableListView<Task> get incompleteTasks =>
      UnmodifiableListView(_tasks.where((todo) => !todo.completed));
  UnmodifiableListView<Task> get completedTasks =>
      UnmodifiableListView(_tasks.where((todo) => todo.completed));

  // void addTodo(Task task) {
  //   var url = "https://todo-app-3bc2b-default-rtdb.firebaseio.com/todos.json";
  //   http.post(url, body: json.encode({
  //     'title':
  //   }));
  //   _tasks.add(task);
  //   notifyListeners();
  // }

  Task findById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  Future<void> fetchAndSetTasks() async {
    var url = Uri.parse(
        'https://todo-app-3bc2b-default-rtdb.firebaseio.com/todos.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://todo-app-3bc2b-default-rtdb.firebaseio.com/todos.json');

      final List<Task> loadedTasks = [];
      extractedData.forEach((taskId, taskData) {
        loadedTasks.add(Task(
          id: taskId,
          title: taskData['title'],
        ));
      });
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTodo(Task task) async {
    var url = Uri.parse(
        'https://todo-app-3bc2b-default-rtdb.firebaseio.com/todos.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': task.title,
          }));

      final newTask = Task(
        title: task.title,
        id: json.decode(response.body)['name'],
      );
      _tasks.add(newTask);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTodo(String id, Task newTask) async {
    final taskIndex = _tasks.indexWhere((prod) => prod.id == id);
    if (taskIndex >= 0) {
      var url = Uri.parse(
          'https://todo-app-3bc2b-default-rtdb.firebaseio.com/todos.json');
      await http.patch(url,
          body: json.encode({
            'title': newTask.title,
          }));
      _tasks[taskIndex] = newTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void toggleTodo(Task task) {
    final taskIndex = _tasks.indexOf(task);
    _tasks[taskIndex].toggleCompleted();
    notifyListeners();
  }

  void deleteTodo(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
