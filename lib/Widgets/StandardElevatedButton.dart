import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';

class StandardElevatedButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final VoidCallback onPress;
  final EdgeInsets padding;
  const StandardElevatedButton({
    Key key,
    @required this.backgroundColor,
    @required this.text,
    this.onPress, this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPress ?? null,
      style: ElevatedButton.styleFrom(
          padding: padding?? EdgeInsets.symmetric(
              horizontal: Util.responsiveSize(context, 102),
              vertical: Util.responsiveSize(context, 12)),
          primary: backgroundColor),
      child: Text(
        this.text,
        style: TextStyle(fontSize: Util.responsiveSize(context, 20)),
      ),
    );
  }
}
