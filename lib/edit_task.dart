import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/provider.dart';

import 'model.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  var _editTodo = Task(id: null, title: '');
  var _initValues = {
    'title': '',
  };
  var _isInit = true;
  var _isLodding = false;
  // @override
  // void initState() {
  //   _imageUrlFocusNode.addListener(_updateUrl);
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final todoId = ModalRoute.of(context)!.settings.arguments;
      if (todoId != null) {
        _editTodo = Provider.of<TodosModel>(context, listen: false)
            .findById(todoId as String);
        _initValues = {
          'title': _editTodo.title!,
        };
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLodding = true;
    });
    if (_editTodo.id != null) {
      Provider.of<TodosModel>(context, listen: false)
          .updateTodo(_editTodo.id!, _editTodo);
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<TodosModel>(context, listen: false)
            .addTodo(_editTodo);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An eerror Occurred!'),
            content: Text('Something went Wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okey'))
            ],
          ),
        );
      } finally {
        setState(() {
          _isLodding = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: _saveForm, icon: Icon(Icons.save, color: Colors.white))
        ],
      ),
      body: _isLodding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Value';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocusNode);
                        // },
                        onSaved: (value) {
                          _editTodo = Task(id: _editTodo.id, title: value!);
                        },
                      ),
                    ],
                  )),
            ),
    );
  }
}
