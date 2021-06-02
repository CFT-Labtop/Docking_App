import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';

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
      padding: EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, 16)),
      child: TextField(
        style: TextStyle(fontSize: widget.fontSize ?? Util.responsiveSize(context, 14)),
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
              EdgeInsets.only(left: Util.responsiveSize(context, 12), top: Util.responsiveSize(context, 8), bottom: Util.responsiveSize(context, 8), right: Util.responsiveSize(context, 12)),
          suffixIcon: (_focusNode.hasFocus)
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  iconSize: Util.responsiveSize(context, 18),
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
