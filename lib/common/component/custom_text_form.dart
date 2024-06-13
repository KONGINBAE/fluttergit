import 'package:flutter/material.dart';

import '../const/colors.dart';
class Custom_Text_Form extends StatelessWidget {

  final String? hinText ;
  final String? errorText;
  final bool obsecureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

   Custom_Text_Form
       ({Key? key,
     this.obsecureText = false,
     this.autofocus=false,
     this.hinText,
     this.errorText,
     required this.onChanged  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      )
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: false,
      autofocus: false,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hinText,
        errorText: errorText,
          hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
            fontSize: 14.0,
        ),
        filled: true,
        fillColor: INPUT_BG_COLOR,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          )
        )
      ),
    );
  }
}
