import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends Padding{

  final TextEditingController control;
  final TextInputType? keyboard;
  final String labelTxt;
  final String hintTxt;
  final bool obscureState;
  final bool? isReadOnly;
  final List<TextInputFormatter>? maxInput;
  final Widget? suffixPic;
  final String? counterDisplay;
  final VoidCallback? suffixEvent;
  final void Function(String)? changeEvent;
  final String? Function(String, String?) validateInput;

  CustomTextField({super.key, required this.control, this.keyboard, required this.labelTxt, required this.hintTxt, required this.obscureState, this.isReadOnly, 
  this.maxInput, this.counterDisplay, this.suffixPic, this.suffixEvent, this.changeEvent, required this.validateInput}):super(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: control,
      keyboardType: keyboard,
      obscureText: obscureState,
      inputFormatters: maxInput,
      enabled: (isReadOnly != null) ? !isReadOnly : null,
      readOnly: (isReadOnly != null) ? isReadOnly : false,
      decoration: InputDecoration(
        labelText: labelTxt,
        hintText: hintTxt,
        counterText: counterDisplay,
        suffixIcon: (suffixPic != null && suffixEvent != null) ? IconButton(onPressed: suffixEvent, icon: suffixPic) : null 
      ),
      onChanged: changeEvent,
      validator: (value) {
        value = value?.trim();
        return validateInput(labelTxt, value);
      },
    )
  );
}