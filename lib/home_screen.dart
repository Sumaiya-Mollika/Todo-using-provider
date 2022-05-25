import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/all_task.dart';
import 'package:todos_app/complete_task.dart';
import 'package:todos_app/incomplete_task.dart';
import 'package:todos_app/model.dart';
import 'package:todos_app/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final taskTitleController = TextEditingController();
  bool completedStatus = false;

  @override
  void dispose() {
    taskTitleController.dispose();
    super.dispose();
  }

  void onAdd() {
    final String textVal = taskTitleController.text;
    final bool completed = completedStatus;
    if (textVal.isNotEmpty) {
      final Task todo = Task(
        title: textVal,
        completed: completed,
      );
      Provider.of<TodosModel>(context, listen: false).addTodo(todo);
      Navigator.pop(context);
    }
  }

  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<void>(
                isDismissible: false,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    //color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),

                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(40, 10, 40, 80),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      TextField(
                                          controller: taskTitleController),
                                      CheckboxListTile(
                                        value: completedStatus,
                                        onChanged: (checked) => setState(() {
                                          completedStatus = checked!;
                                        }),
                                        title: Text('Complete?'),
                                      ),
                                      RaisedButton(
                                        child: Text('Add'),
                                        onPressed: onAdd,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            right: 3,
                            top: -6,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                            ))
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Tab(text: 'All'),
            Tab(text: 'Incomplete'),
            Tab(text: 'Complete'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          AllTasksTab(),
          IncompleteTasksTab(),
          CompletedTasksTab(),
        ],
      ),
    );
  }
}
