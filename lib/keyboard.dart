import 'package:flutter/material.dart';
import 'package:wallet_app/utils.dart';


typedef KeyboardTapCallback = void Function(int text);

class KeyboardUIConfig {
  final double digitHeight;
  final double digitWidth;
  final double digitBorderWidth;
  final TextStyle digitTextStyle;
  final TextStyle deleteButtonTextStyle;
  final Color primaryColor;
  final Color digitFillColor;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry deleteButtonMargin;

  KeyboardUIConfig({
    this.digitHeight,
    this.digitWidth,
    this.digitBorderWidth = 1,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15),
    this.primaryColor = Colors.white,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.white),
    this.deleteButtonMargin =
        const EdgeInsets.only(right: 25, left: 20, top: 15),
    this.deleteButtonTextStyle =
        const TextStyle(fontSize: 16, color: Colors.white),
  });
}

class Keyboard extends StatelessWidget {
  final KeyboardUIConfig keyboardUIConfig;
  final GestureTapCallback onDeleteCancelTap;
  final KeyboardTapCallback onKeyboardTap;
  final bool shouldShowCancel;
  final String cancelLocalizedText;
  final String deleteLocalizedText;

  Keyboard(
      {Key key,
      @required this.keyboardUIConfig,
      @required this.onDeleteCancelTap,
      @required this.onKeyboardTap,
      this.shouldShowCancel = true,
      @required this.cancelLocalizedText,
      @required this.deleteLocalizedText})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard();

  Widget _buildKeyboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(1, 0) , 1),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(2, 0) , 2),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(3, 0) , 3),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(4, 0) , 4),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(5, 0) , 5),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(6, 0) , 6),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(7, 0), 7),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(8, 0), 8),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(9, 0), 9),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            dummyKey(),
            _buildKeyboardDigit(Utils.convertNumberToLocalizedText(0, 0), 0),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget dummyKey() {
    return Container(
      width: keyboardUIConfig.digitWidth,
      height: keyboardUIConfig.digitHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildKeyboardDigit(String text, int value) {
    return Container(
      width: keyboardUIConfig.digitWidth,
      height: keyboardUIConfig.digitHeight,
      child: ClipOval(
        child: Material(
          color: keyboardUIConfig.digitFillColor,
          child: InkWell(
            highlightColor: keyboardUIConfig.primaryColor,
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: () {
              onKeyboardTap(value);
            },
            child: Center(
              child: Text(
                text,
                style: keyboardUIConfig.digitTextStyle,
              ),
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: keyboardUIConfig.primaryColor,
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      height: keyboardUIConfig.digitHeight,
      width: keyboardUIConfig.digitWidth,
      child: Material(
        color: keyboardUIConfig.digitFillColor,
        child: InkWell(
          highlightColor: keyboardUIConfig.primaryColor,
          splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
          onTap: onDeleteCancelTap,
          child: Center(
            child: Icon(
              Icons.backspace,
              size: keyboardUIConfig.digitHeight / 3,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.transparent,
      ),
    );
  }
}

