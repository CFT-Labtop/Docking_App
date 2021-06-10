import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';

class StandardTextFormField extends StatefulWidget {
  const StandardTextFormField({
    Key key,
    @required TextEditingController textController,
    this.hintText,
    this.prefixWidget,
    this.prefixOnPress,
    this.textInputType,
    this.fontSize,
    this.fontColor, this.focusNode, this.enable, this.validator,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final String hintText;
  final double fontSize;
  final Color fontColor;
  final Widget prefixWidget;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final bool enable;
  final void Function() prefixOnPress;
  final void Function(String text) validator;

  @override
  _StandardTextFormFieldState createState() => _StandardTextFormFieldState();
}

class _StandardTextFormFieldState extends State<StandardTextFormField> {
  FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, 16)),
      child: TextFormField(
        style: TextStyle(fontSize: widget.fontSize ?? Util.responsiveSize(context, 14), color: widget.fontColor ?? Colors.black),
        controller: widget._textController,
        focusNode: widget.focusNode ?? _focusNode,
        enabled: widget.enable ?? true,
        validator: widget.validator,
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
