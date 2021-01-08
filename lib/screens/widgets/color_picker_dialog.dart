import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

///This widget creates an AlertDialog with different colors to choose. It is
///used during the creation of a [Task] and in the [SettingsScreen] to change
///the app primary color. When the user taps on a color, it closes the dialog
///and passes the chosen color back to the previous screen with the pop function.
class ColorPickerDialog extends StatefulWidget {
  final Color taskColor;

  const ColorPickerDialog({Key key, this.taskColor}) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color _mainColor;

  @override
  void initState() {
    super.initState();
    _mainColor = widget.taskColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6),
      title: Text(
        "Escolha uma cor",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 225),
        child: MaterialColorPicker(
          allowShades: false,
          selectedColor: _mainColor,
          onMainColorChange: (color) {
            setState(() {
              Navigator.of(context).pop(color);
            });
          },
        ),
      ),
    );
  }
}
