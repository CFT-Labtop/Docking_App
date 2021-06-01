import 'package:flutter/material.dart';

class StandardTextField extends StatefulWidget {
  const StandardTextField({
    Key key,
    @required TextEditingController textController,
    this.hintText,
    this.prefixWidget,
    this.prefixOnPress,
    this.textInputType,
    this.fontSize,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final String hintText;
  final double fontSize;
  final Widget prefixWidget;
  final TextInputType textInputType;
  final void Function() prefixOnPress;

  @override
  _StandardTextFieldState createState() => _StandardTextFieldState();
}

class _StandardTextFieldState extends State<StandardTextField> {
  FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        style: TextStyle(fontSize: widget.fontSize ?? 14.0),
        controller: widget._textController,
        focusNode: _focusNode,
        keyboardType: widget.textInputType ?? TextInputType.text,
        decoration: InputDecoration(
          fillColor: Color(0xffEEEEEE),
          filled: true,
          isDense: true,
          prefixIcon: (widget.prefixWidget != null)
              ? GestureDetector(onTap: widget.prefixOnPress??null ,
                child: widget.prefixWidget)
              : null,
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          hintText: widget.hintText ?? "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          contentPadding:
              EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0, right: 12.0),
          suffixIcon: (_focusNode.hasFocus)
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  iconSize: 18.0,
                  padding: EdgeInsets.all(0.0),
                  color: Colors.grey,
                  onPressed: () {
                    widget._textController.clear();
                  },
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
