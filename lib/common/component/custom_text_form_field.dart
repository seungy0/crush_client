import 'package:crush_client/common/const/colors.dart';
import 'package:flutter/material.dart';


class CustomTeextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText; //비밀번호 입력시 * 으로 나오는거
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTeextFormField({
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
        cursorColor: PRIMARY_COLOR,
        obscureText: obscureText,
        autofocus: autofocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          errorText: errorText,
          hintStyle: TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14.0,
          ),
          fillColor: INPUT_BG_COLOR,
          filled: true, //배경색 채우기 true로 해야 나옴
          //모든 Input 상태의 기본 스타일 세팅
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide : baseBorder.borderSide.copyWith(
              color: PRIMARY_COLOR,
            ),
          ), //포커스 상태의 스타일 세팅
        )
    );
  }
}