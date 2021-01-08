import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/widgets/insert_edit_task.dart';
import 'package:to_do_list/screens/list_screen/list_screen.dart';
import 'package:to_do_list/screens/settings_screen/settings_screen.dart';

///Handles the [PageView] to change between the [ListScreen] and the
///[SettingsScreen]. The [changeAppColor] passed to it as argument,
///is necessary to pass to the [SettingsScreen]. With the option to
///not to use a state management package, this was the easiest way
///I have found to pass the argument through the app.
class HomeScreen extends StatefulWidget {
  final Future<void> Function() changeAppColor;

  const HomeScreen({Key key, this.changeAppColor}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final helper = TaskHelper();
  final _pageController = PageController();
  double _currentPage = 0.0;
  List<Task> taskList = [];

  ///Every time it has a change in the [Task] list, it updates the UI to
  ///organize the list.
  void _updateTaskList() {
    helper.getAllTasks().then((list) {
      _sortTaskList(list);
      setState(() {
        taskList = list;
      });
    });
  }

  ///Sort the given list of [Task] to show the ones marked as not done above
  ///the ones marked as done. Then, it sorts them by [color] to group them
  ///given the color the user gave to them.
  void _sortTaskList(List<Task> list) {
    list.sort((a, b) {
      final int doneSort = a.done.toString().compareTo(b.done.toString());
      if (doneSort != 0) {
        return doneSort;
      }
      return a.color.toString().compareTo(b.color.toString());
    });
  }

  ///Updates the [Task] list when the page is created and creates the
  ///[PageView] controller to store the current page in [_currentPage].
  @override
  void initState() {
    super.initState();

    _updateTaskList();

    _pageController.addListener(() {
      if (_pageController.page != _currentPage) {
        setState(() {
          _currentPage = _pageController.page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ///Creates the [PageView] with two pages: [ListScreen] and [SettingsScreen].
  ///The color of the selected tab in [BottomAppBar] will change from black to
  ///the app main color depending on the [_currentPage].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListScreen(
            taskList: taskList,
            saveTask: helper.updateTask,
            updateList: _updateTaskList,
            deleteTask: helper.deleteTask,
            deleteAllDoneFn: helper.deleteAllDoneTasks,
          ),
          SettingsScreen(changeAppColor: widget.changeAppColor),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => InsertEditTask(
              saveTask: helper.saveTask,
              updateList: _updateTaskList,
            ),
          );
        },
        elevation: 0,
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _pageController.jumpToPage(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        size: 30,
                        color: _currentPage == 0.0
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      if (_currentPage == 0)
                        Text(
                          "Lista de tarefas",
                          style: TextStyle(
                            color: _currentPage == 0.0
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _pageController.jumpToPage(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        size: 30,
                        color: _currentPage == 1.0
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      if (_currentPage == 1.0)
                        Text(
                          "Configurações",
                          style: TextStyle(
                            color: _currentPage == 1.0
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
