import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCode extends StatefulWidget {
  /// is completed
  final ValueChanged<String> onCompleted;

  /// is in process of editing
  final ValueChanged<bool> onEditing;

  /// keyboard type
  final TextInputType keyboardType;

  /// quantity of boxes
  final int length;

  /// size of box for code
  final double itemSize;

  /// the color for underline, in case underline color is null it will use primaryColor from Theme
  final Color underlineColor;

  /// the color for underline when not focused, grey by default
  final Color underlineUnfocusedColor;

  /// the color for TextField background
  final Color fillColor;

  /// the line width for underline
  final double underlineWidth;

  /// style of the input text
  final TextStyle textStyle;

  /// auto focus when screen appears
  final bool autofocus;

  ///takes any widget, display it, when tap on that element - clear all fields
  final Widget clearAll;

  /// to secure the TextField
  final bool isSecure;

  VerificationCode({
    Key key,
    @required this.onCompleted,
    @required this.onEditing,
    this.keyboardType = TextInputType.number,
    this.length = 4,
    this.itemSize = 50,
    this.underlineColor,
    this.underlineUnfocusedColor,
    this.fillColor,
    this.underlineWidth,
    this.textStyle = const TextStyle(fontSize: 25.0),
    this.autofocus = false,
    this.clearAll,
    this.isSecure = false,
  }) : super(key: key);

  @override
  VerificationCodeState createState() => VerificationCodeState();
}

class VerificationCodeState extends State<VerificationCode> {
  final List<FocusNode> _listFocusNode = <FocusNode>[];
  final List<TextEditingController> _listControllerText =
      <TextEditingController>[];
  List<String> _code = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _listFocusNode.clear();
    for (var i = 0; i < widget.length; i++) {
      _listFocusNode.add(FocusNode());
      _listControllerText.add(TextEditingController());
      _code.add('');
    }
    super.initState();
  }

  void clearAll() {
    widget.onEditing(true);
    for (var i = 0; i < widget.length; i++) {
      _listControllerText[i].text = '';
    }
    setState(() {
      _currentIndex = 0;
      FocusScope.of(context).requestFocus(_listFocusNode[0]);
    });
  }

  String _getInputVerify() {
    String verifyCode = "";
    for (var i = 0; i < widget.length; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != "") {
          verifyCode += _listControllerText[i].text[index];
        }
      }
    }
    return verifyCode;
  }

  Widget _buildInputItem(int index) {
    return TextField(
      keyboardType: widget.keyboardType,
      maxLines: 1,
      maxLength: index == widget.length - 1 ? 1 : 2,
      controller: _listControllerText[index],
      focusNode: _listFocusNode[index],
      showCursor: true,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autocorrect: false,
      textAlign: TextAlign.center,
      autofocus: widget.autofocus,
      style: widget.textStyle,
      decoration: InputDecoration(
        fillColor: widget.fillColor,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.underlineUnfocusedColor ?? Colors.grey,
            width: widget.underlineWidth ?? 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.underlineColor ?? Theme.of(context).primaryColor,
            width: widget.underlineWidth ?? 1,
          ),
        ),
        counterText: "",
        contentPadding: EdgeInsets.all(((widget.itemSize * 2) / 10)),
        errorMaxLines: 1,
      ),
//      textInputAction: TextInputAction.previous,
      onChanged: (String value) {
        if ((_currentIndex + 1) == widget.length && value.length > 0) {
          widget.onEditing(false);
        } else {
          widget.onEditing(true);
        }

        if (value.length > 0 && index < widget.length || index == 0) {
          if (index < widget.length - 1) {
            if (value.length == 2 && index != widget.length - 1) {
              _listControllerText[index].value =
                  TextEditingValue(text: value[0]);
              _next(index);
              _listControllerText[index + 1].value =
                  TextEditingValue(text: value[1]);
            }
            if (_listControllerText[widget.length - 1].value.text.length == 1 &&
                _getInputVerify().length == widget.length) {
              widget.onEditing(false);
              widget.onCompleted(_getInputVerify());
            }
          }

          return;
        }
        if (value.length == 0 && index >= 0) {
          _prev(index);
        }
      },
    );
  }

  void _next(int index) {
    if (index != widget.length - 1) {
      setState(() {
        _currentIndex = index + 1;
      });
      FocusScope.of(context).requestFocus(_listFocusNode[_currentIndex]);
    }
  }

  void _prev(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {}
        _currentIndex = index - 1;
      });
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(_listFocusNode[_currentIndex]);
    }
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = [];
    for (int index = 0; index < widget.length; index++) {
      double left = (index == 0) ? 0.0 : (widget.itemSize / 10);
      listWidget.add(Container(
          height: widget.itemSize,
          width: widget.itemSize,
          margin: EdgeInsets.only(left: left),
          child: _buildInputItem(index)));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildListWidget(),
              ),
              widget.clearAll != null
                  ? _clearAllWidget(widget.clearAll)
                  : Container(),
            ],
          )),
    );
  }

  Widget _clearAllWidget(child) {
    return GestureDetector(
      onTap: () {
        clearAll();
      },
      child: child,
    );
  }
}
