import 'package:flutter/material.dart';

///This widget is used as a bottom app bar tab to change between the
///[ListScreen] and the [SettingsScreen].
class BottomAppBarItem extends StatefulWidget {
  final PageController pageController;
  final int pageNumber;
  final double currentPage;
  final IconData icon;
  final String label;
  final void Function() changeCurrentPage;

  const BottomAppBarItem({
    Key key,
    this.pageController,
    this.pageNumber,
    this.currentPage,
    this.icon,
    this.label,
    this.changeCurrentPage,
  }) : super(key: key);

  @override
  _BottomAppBarItemState createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<BottomAppBarItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          widget.pageController.jumpToPage(widget.pageNumber);
          widget.changeCurrentPage();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 30,
              color: widget.currentPage == widget.pageNumber
                  ? Theme.of(context).primaryColor
                  : null,
            ),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.currentPage == widget.pageNumber
                    ? Theme.of(context).primaryColor
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
