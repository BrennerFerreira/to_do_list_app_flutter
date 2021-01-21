import 'package:flutter/material.dart';

import 'package:to_do_list/screens/widgets/color_picker_dialog.dart';
import 'package:to_do_list/settings/app_settings.dart';

///At the moment, the settings controls three parameters: the app main color,
///whether to show the delete task alert or not and whether to show the delete
///all tasks alert or not. There are plans to update this screen with more
///functionalities, specially one to change the app language.
class SettingsScreen extends StatefulWidget {
  final Future<void> Function() changeAppColor;
  const SettingsScreen({
    this.changeAppColor,
  });
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool deleteWarning = true;
  bool deleteAllWarning = true;
  String theme = 'automatic';

  Future<void> _getDeleteWarning() async {
    deleteWarning = await AppSettings.getDeleteWarning();
    setState(() {});
  }

  Future<void> _getDeleteAllWarning() async {
    deleteAllWarning = await AppSettings.getDeleteAllWarning();
    setState(() {});
  }

  ///When this page initializes, it retrieves the user alter preferences and
  ///stores them in [deleteWarning] and [deleteAllWarning] variables.
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
        title: const Text("Configurações"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: "Lista de Tarefas",
              applicationVersion: "Versão 1.0.1",
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 64.0,
          horizontal: 32.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Cor Principal:",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    ///When the user taps on the circle, it will open the
                    ///[ColorPickerDialog] giving them options to change
                    ///the app main color. When the user taps on a color,
                    ///this dialog closes and the [setMainAppColor] function
                    ///is called, change the app primary color and using
                    ///setState to update the UI.
                    onTap: () async {
                      final Color selectedColor = await showDialog<Color>(
                        context: context,
                        builder: (_) => ColorPickerDialog(
                          taskColor: Theme.of(context).primaryColor,
                        ),
                      );
                      if (selectedColor != null) {
                        setState(() {
                          AppSettings.setMainAppColor(selectedColor);
                          widget.changeAppColor();
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ///Both switches here control the user alert preferences. The first
              ///controls a single [Task] delete warning and the second controls
              ///the delete all done [Task] warning. If the option is set to false,
              ///the corresponding delete function will be called without showing
              ///[AlertDialog] to confirm it.
              SwitchListTile.adaptive(
                value: deleteWarning,
                onChanged: (newValue) async {
                  await AppSettings.setDeleteWarning(newValue: newValue);
                  setState(() {
                    deleteWarning = newValue;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Confirmar exclusão?",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: const Text(
                  "Ao excluir uma tarefa, será necessário confirmar este pedido.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: deleteAllWarning,
                onChanged: (newValue) async {
                  await AppSettings.setDeleteAllWarning(newValue: newValue);
                  setState(() {
                    deleteAllWarning = newValue;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Confirmar exclusão das tarefas concluídas?",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: const Text(
                  "Ao excluir todas as tarefas concluídas, será necessário confirmar este pedido.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tema:"),
                  DropdownButton<String>(
                    onChanged: (newValue) {
                      setState(() {
                        theme = newValue;
                      });
                    },
                    value: theme,
                    items: const [
                      DropdownMenuItem<String>(
                        value: "automatic",
                        child: Text("Automático"),
                      ),
                      DropdownMenuItem<String>(
                        value: "light",
                        child: Text("Claro"),
                      ),
                      DropdownMenuItem<String>(
                        value: "dark",
                        child: Text("Escuro"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
