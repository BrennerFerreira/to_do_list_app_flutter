import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/widgets/insert_edit_task.dart';
import 'package:to_do_list/theme/app_theme.dart';

enum MenuEntries { deleteAll }

///This tab shows all the [Task] in the database.
class ListScreen extends StatefulWidget {
  final List<Task> taskList;
  final void Function(Task task) saveTask;
  final void Function() updateList;
  final void Function(int id) deleteTask;
  final Future<void> Function(List<Task> list) deleteAllDoneFn;
  const ListScreen({
    Key key,
    this.taskList,
    this.saveTask,
    this.updateList,
    this.deleteTask,
    this.deleteAllDoneFn,
  }) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool deleteWarning = true;
  bool deleteAllWarning = true;

  Future<void> _getDeleteWarning() async {
    deleteWarning = await AppTheme.getDeleteWarning();
    setState(() {});
  }

  Future<void> _getDeleteAllWarning() async {
    deleteAllWarning = await AppTheme.getDeleteAllWarning();
    setState(() {});
  }

  ///On creation, it recovers the user [deleteWarning] and [deleteAllWarning]
  ///preferences to decides whether it will show alerts to delete [Task] or not.
  @override
  void initState() {
    super.initState();
    _getDeleteWarning();
    _getDeleteAllWarning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Lista de Tarefas"),
        actions: [
          ///This [PopUpMenuButton] at the moment has only one option: delete
          ///all [Task] marked as done. In the future, it can have more
          ///functionalities to help the user to organize their list.
          PopupMenuButton(itemBuilder: (_) {
            return <PopupMenuEntry<MenuEntries>>[
              const PopupMenuItem<MenuEntries>(
                value: MenuEntries.deleteAll,
                child: Text("Limpar tarefas concluídas"),
              )
            ];
          },

              ///When the user select this option, it can do two things: show an
              ///[AlertDialog] asking the user to confirm their choice or call the
              ///[deleteAllDoneFn] right away. This depends on whether the user has
              ///chosen to show the [deleteAllWarning] or not in the [SettingsScreen].
              onSelected: (_) async {
            if (deleteAllWarning) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Excluir tarefas concluídas",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  content: const Text(
                    "Deseja realmente excluir todas as tarefa marcadas como concluídas?",
                  ),
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
                      onPressed: () async {
                        await widget.deleteAllDoneFn(widget.taskList);
                        widget.updateList();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "EXCLUIR",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              await widget.deleteAllDoneFn(widget.taskList);
              widget.updateList();
            }
          })
        ],
      ),
      body: widget.taskList.isEmpty

          ///If there are no [Task] in the list, the screen will show a picture
          ///with some text to reflect the empty list.
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tudo pronto!",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Hora de relaxar!",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    SvgPicture.asset(
                      "assets/images/undraw_relaxation_1_wbr7.svg",
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  ],
                ),
              ),
            )

          ///If the list is not empty, the screen will show the list where
          ///each [Task] has its own [ListTile], with a colored [CircleAvatar]
          ///in the leading area, the title in the middle and two [IconButton]
          ///in the trailing area: one to edit the [Task] and one to delete it.
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: widget.taskList.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: widget.taskList[index].color,
                    child: Icon(
                      widget.taskList[index].done ? Icons.done : Icons.error,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    widget.taskList[index].title,
                    style: TextStyle(
                      color: widget.taskList[index].done ? Colors.grey : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => InsertEditTask(
                              saveTask: widget.saveTask,
                              updateList: widget.updateList,
                              task: widget.taskList[index],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),

                        ///Here, depending on what the user chose as the
                        ///[deleteWarning] option in the [SettingsScreen], it
                        ///can have one of two effects: delete the [Task]
                        ///right away or show an [AlertDialog] asking the user
                        ///to confirm their choice.
                        onPressed: deleteWarning
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Excluir tarefa",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    content: const Text(
                                      "Deseja realmente excluir esta tarefa?",
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: Navigator.of(context).pop,
                                        child: Text(
                                          "CANCELAR",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          widget.deleteTask(
                                              widget.taskList[index].id);
                                          widget.updateList();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "EXCLUIR",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            : () async {
                                widget.deleteTask(widget.taskList[index].id);
                                widget.updateList();
                              },
                      ),
                    ],
                  ),

                  ///When the user tap anywhere in the [ListTile], except the
                  ///trailing buttons, it calls the [invertDone] function and
                  ///updates the UI to reflect this change.
                  onTap: () {
                    setState(() {
                      widget.taskList[index].invertDone(widget.taskList[index]);
                      widget.updateList();
                    });
                  },
                );
              }),
    );
  }
}
