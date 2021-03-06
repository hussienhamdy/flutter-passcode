library passcode_screen;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/shake_curve.dart';

typedef PasswordEnteredCallback = void Function(String text);
typedef IsValidCallback = void Function();
typedef CancelCallback = void Function();

class PasscodeScreen extends StatefulWidget {
  final Widget title;
  final List digits;
  final int passwordDigits;
  final Color titleColor;
  final Color backgroundColor;
  final Color keyboardColor;
  final EdgeInsetsGeometry keyboardPadding;
  final EdgeInsetsGeometry circlesMargin;
  final double keyboardHeight;
  final double circlesHeight;
  final double upperViewHeight;
  final PasswordEnteredCallback passwordEnteredCallback;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback isValidCallback;
  final CancelCallback cancelCallback;
  final String cancelLocalizedText;
  final String deleteLocalizedText;
  final Stream<bool> shouldTriggerVerification;
  final Widget bottomWidget;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  PasscodeScreen({
    Key key,
    @required this.title,
    this.digits,
    this.passwordDigits = 6,
    @required this.passwordEnteredCallback,
    @required this.cancelLocalizedText,
    @required this.deleteLocalizedText,
    @required this.shouldTriggerVerification,
    this.isValidCallback,
    this.circleUIConfig,
    this.keyboardUIConfig,
    this.bottomWidget,
    this.titleColor = Colors.white,
    this.keyboardColor,
    this.keyboardPadding,
    this.circlesMargin,
    this.upperViewHeight,
    this.circlesHeight,
    this.keyboardHeight,
    this.backgroundColor,
    this.cancelCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<bool> streamSubscription;
  String enteredPasscode = '';
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    streamSubscription = widget.shouldTriggerVerification
        .listen((isValid) => _showValidation(isValid));
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            enteredPasscode = '';
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  Widget renderUpperView() {
    return Container(
      height: widget.upperViewHeight,
      child: Column(
        children: <Widget>[
          widget.title,
          Container(
            margin: widget.circlesMargin,
            height: widget.circlesHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildCircles(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            renderUpperView(),
            Container(
              height: widget.keyboardHeight,
              color: widget.keyboardColor,
              padding: widget.keyboardPadding,
              child: Keyboard(
                onDeleteCancelTap: _onDeleteCancelButtonPressed,
                onKeyboardTap: _onKeyboardButtonPressed,
                shouldShowCancel: enteredPasscode.length == 0,
                cancelLocalizedText: widget.cancelLocalizedText,
                deleteLocalizedText: widget.deleteLocalizedText,
                keyboardUIConfig: widget.keyboardUIConfig != null
                    ? widget.keyboardUIConfig
                    : KeyboardUIConfig(),
              ),
            ),
            // widget.bottomWidget != null ? widget.bottomWidget : Container()
          ],
        ));
  }

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    var config = widget.circleUIConfig != null
        ? widget.circleUIConfig
        : CircleUIConfig();
    config.extraSize = animation.value;
    for (int i = 0; i < widget.passwordDigits; i++) {
      list.add(Circle(
        filled: i < enteredPasscode.length,
        circleUIConfig: config,
      ));
    }
    return list;
  }

  _onDeleteCancelButtonPressed() {
    if (enteredPasscode.length > 0) {
      setState(() {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      });
    }
  }

  _onKeyboardButtonPressed(int value) {
    setState(() {
      if (enteredPasscode.length < widget.passwordDigits) {
        enteredPasscode += value.toString();
        if (enteredPasscode.length == widget.passwordDigits) {
          widget.passwordEnteredCallback(enteredPasscode);
        }
      }
    });
  }

  @override
  didUpdateWidget(PasscodeScreen old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerVerification
          .listen((isValid) => _showValidation(isValid));
    }
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
    streamSubscription.cancel();
  }

  _showValidation(bool isValid) {
    if (isValid) {
       _validationCallback();
    } else {
      controller.forward();
    }
  }

  _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback();
    } else {
      print(
          "You didn't implement validation callback. Please handle a state by yourself then.");
    }
  }
}

