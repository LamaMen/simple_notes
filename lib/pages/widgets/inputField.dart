import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
    borderRadius: BorderRadius.circular(15.0),
  );

  final String hintText;
  final TextEditingController controller;
  final Function onChanged;
  final bool obscureText;
  final Function onSubmitted;

  InputField(
      {Key key,
      this.controller,
      this.onChanged,
      this.obscureText,
      this.onSubmitted,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      onChanged: onChanged,
      maxLines: 1,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hintText,
        filled: true,
        fillColor: Theme.of(context).accentColor,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: border,
        focusedBorder: border,
      ),
      onSubmitted: onSubmitted,
    );
  }
}
