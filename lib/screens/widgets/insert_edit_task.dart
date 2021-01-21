import 'package:flutter/material.dart';

import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/widgets/color_picker_dialog.dart';

///This dialog is used to both create and edit a [Task]. If no [Task] is
///passed as an argument to this widget, it opens an empty form to the user
///fill the desired fields. If a [Task] is passed as an argument, the form
///is initially filled with title and color so the user can edit those fields.
class InsertEditTask extends StatefulWidget {
  final void Function(Task task) saveTask;
  final void Function() updateList;
  final Task task;

  const InsertEditTask({
    Key key,
    this.saveTask,
    this.updateList,
    this.task,
  }) : super(key: key);

  @override
  _InsertEditTaskState createState() => _InsertEditTaskState();
}

class _InsertEditTaskState extends State<InsertEditTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController;
  Color taskColor;

  ///When this widget is created, it verifies if a task was passed. If it was,
  ///it fills the title and color fields with the [Task] info. If not, it
  ///leaves the title field empty and gives a black color to the [Task]. This
  ///prevents a task being created without color.
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
        text: widget.task == null ? "" : widget.task.title);

    taskColor = widget.task == null ? Colors.black : widget.task.color;
  }

  @override
  Widget build(BuildContext context) {
    void changeTaskColor(Color newColor) {
      setState(() {
        taskColor = newColor;
      });
    }

    return AlertDialog(
      title: Text(
        widget.task == null ? "Inserir tarefa" : "Editar tarefa",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: dialogContent(context, changeTaskColor),
      actions: [
        FlatButton(
          onPressed: Navigator.of(context).pop,
          child: Text(
            "CANCELAR",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        FlatButton(
          ///When the user saves the form, it verifies if it is valid (the title
          ///field cannot be empty) and saves the information, writing the [Task]
          ///in the database.
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            _saveForm();
            Navigator.of(context).pop();
          },
          child: Text(
            "SALVAR",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  ///When the form is saved, it checks the [saveTask] function passed to the widget.
  ///If it is a new [Task], it saves a new entry in the database. If it a [Task]
  ///being edited, it updates the entry in the database.
  void _saveForm() {
    if (widget.task == null) {
      widget.saveTask(
        Task(
          title: titleController.text,
          color: taskColor,
        ),
      );
    } else {
      widget.saveTask(
        Task(
          id: widget.task.id,
          title: titleController.text,
          color: taskColor,
        ),
      );
    }
    widget.updateList();
  }

  Widget dialogContent(
    BuildContext context,
    void Function(Color color) changeColorFn,
  ) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Tarefa",
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                hintText: "Digite sua tarefa...",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, preencha o campo acima.";
                } else {
                  return null;
                }
              },
            ),
            Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Cor:"),
                    Container(
                      height: 30,
                      width: 30,
                      color: taskColor,
                    ),
                    OutlineButton(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        final Color selectedColor = await showDialog<Color>(
                          context: context,
                          builder: (_) => ColorPickerDialog(
                            taskColor: taskColor,
                          ),
                        );
                        if (selectedColor != null) {
                          changeColorFn(selectedColor);
                        }
                      },
                      child: const Text(
                        "Selecione uma cor",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
