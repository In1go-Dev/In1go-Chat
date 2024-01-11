import 'package:flutter/material.dart';

//Widget Display for Loading Button - Customized for Text Input Validation

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.label, required this.width, required this.formKey, required this.authEvent});

  final String label;
  final double width;
  final GlobalKey<FormState> formKey;
  final void Function(VoidCallback) authEvent;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isEnabled = true;

  void buttonEvent(void Function(VoidCallback) authEvent) {
    FocusScope.of(context).unfocus();
    
    final FormState? form = widget.formKey.currentState;
    if(form != null && form.validate()) {    //Validates the corresponding conditions
      if(context.mounted) {
        setState(() {    //Changes to a loading circle
          if(isEnabled == true) isEnabled = false;
        });
        Future.delayed(const Duration(seconds: 1), () => authEvent(changeLoading));  //Wait for a second before implementing the functionality parameter
      }
    }
  }

  void changeLoading() {  //Disables the loading circle if an exception is found
    if(context.mounted) {
      setState(() {
        if(isEnabled == false) isEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      width: widget.width,
      child: Theme.of(context).useMaterial3
      ? FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: (isEnabled == true) ? Theme.of(context).primaryColor : Colors.grey,
          ),
          onPressed: (isEnabled != true) ? null : () => buttonEvent(widget.authEvent),
          child: (isEnabled == true)
           ? Text(widget.label, style: const TextStyle(color: Colors.white))
           : Transform.scale(scale: 0.5, child: const CircularProgressIndicator(strokeWidth: 8))
        )

      : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: (isEnabled == true) ? Theme.of(context).primaryColor : Colors.grey,
          ),
          onPressed: (isEnabled != true) ? null : () => buttonEvent(widget.authEvent),
          child: (isEnabled == true)
           ? Text(widget.label, style: const TextStyle(color: Colors.white))
           : Transform.scale(scale: 0.5, child: const CircularProgressIndicator(strokeWidth: 8))
        )
    );
  }
}