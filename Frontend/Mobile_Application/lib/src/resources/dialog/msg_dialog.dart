import 'package:fl_nynberapp/src/resources/home_page.dart';
import 'package:fl_nynberapp/src/resources/login_page.dart';
import 'package:flutter/material.dart';

class MsgDialog {
  static void showMsgDialog(BuildContext context, String title, String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    print("END showMsgDialog");
  }

  static void showMsgDialogAndBackToLogin(
      BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  static void showAlertDialog(
      BuildContext context, String title, String msg, Function onContinue) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Hủy bỏ"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Tiếp tục"),
      onPressed: () {
        Navigator.of(context).pop();
        onContinue();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showMsgDialogWithUsernameAndEmail(BuildContext context,
      String title, String msg, String fullname, String email) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              Map data = {'fullname': fullname, 'email': email};

              Navigator.of(context).pop(data);
            },
          ),
        ],
      ),
    );
  }

  static void showMsgDialogAndPushToScreenPage(
      BuildContext context, String title, String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(MsgDialog);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
