import 'package:flutter/material.dart';

class AlertDialogLayout extends AlertDialog {

  final double width;
  final String? titleName;
  final BuildContext appContext;
  final Widget? widget;

  AlertDialogLayout({super.key, required this.width, this.titleName, required this.appContext, this.widget}) : super(
    title: (titleName != null) ? Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(appContext).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)
        )
      ),
      child: Text(
        titleName,
        style: const TextStyle(color: Colors.white, fontSize: 18)
      )
    ) : null,
    titlePadding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    insetPadding: const EdgeInsets.symmetric(horizontal: 15),
    contentPadding: const EdgeInsets.all(15),
    content: Container(
      width: width,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: (widget != null) ? widget : const SizedBox()
    )
  );
}


class ConfirmationAlert extends StatelessWidget {
  const ConfirmationAlert({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 15),
            child: Text(
              message,
              //style: const TextStyle(fontSize: 18),
            )
          ),
          
          const ChoiceButtonDialog()
        ]
      )
    );
  }
}


class ChoiceButtonDialog extends StatelessWidget {
  const ChoiceButtonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

          DialogButtons(
            buttonFunction: () => Navigator.pop(context, false),
            text: 'Cancel'
          ),
          
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: DialogButtons(
              buttonFunction: () {
                Navigator.pop(context, true);
              },
              text: 'Confirm',
            )
          )
        ]
      )
    );
  }
}

class DialogButtons extends StatelessWidget {
  const DialogButtons({super.key, required this.buttonFunction, required this.text});

  final VoidCallback buttonFunction;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).useMaterial3
      ? FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            )
          ),
          onPressed: buttonFunction,
          child: Text(text)
        )
      : ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            )
          ),
          onPressed: buttonFunction,
          child: Text(text)
        );
  }
}