import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/edit_task.dart';
import 'package:todos_app/model.dart';
import 'package:todos_app/provider.dart';

class TaskListItem extends StatelessWidget {
  final Task? task;
  final String? id;
  TaskListItem({@required this.task, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task!.completed,
        onChanged: (bool? checked) {
          Provider.of<TodosModel>(context, listen: false).toggleTodo(task!);
        },
      ),
      title: Text(task!.title!),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text('Do you want to remove the item?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('NO'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Provider.of<TodosModel>(context,
                                          listen: false)
                                      .deleteTodo(task!);
                                  Navigator.of(ctx).pop(true);
                                },
                                child: Text('Yes'))
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
