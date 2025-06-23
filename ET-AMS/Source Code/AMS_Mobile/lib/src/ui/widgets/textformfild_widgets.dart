

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFildWidgets extends StatelessWidget {
  final String title;
  final IconData? icon;
  final IconButton? iconButton;
  final Function()? onPressd;
  final bool? read;
  final TextEditingController? txtcontroller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;

  TextFormFildWidgets({
    Key? key,
    required this.title,
    this.icon,
    this.iconButton,
    this.onPressd,
    this.txtcontroller,
    this.focusNode,
    this.read,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .7,
      child: TextFormField(
        controller: txtcontroller,
        focusNode: focusNode,
        onTap: onPressd,
        readOnly: read ?? false,
        decoration: InputDecoration(
          hintText: title,
          suffixIcon: iconButton,
        ),
        textInputAction: TextInputAction.done,
        autocorrect: false,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s$')), // Prevent trailing spaces
        ],
        validator: validator,
      ),
    );
  }
}
