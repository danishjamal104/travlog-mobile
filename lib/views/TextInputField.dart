import 'package:flutter/material.dart';
import 'package:travlog/utils/constants.dart';

shiftFocus(BuildContext context, FocusNode from, [FocusNode to]) {
  from.unfocus();
  if(to != Null) {
    FocusScope.of(context).requestFocus(to);
  }
}

Widget getDefaultTextInputFiled(
    BuildContext context,
    TextEditingController controller,
    FocusNode currentFocus,
    FocusNode nextFocus,
    String labelText,
    String hintText) {
  return Padding(
    padding:
    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 5),
    //padding: EdgeInsets.symmetric(horizontal: 15),
    child: TextFormField(
      style: TextStyle(fontFamily: 'sans-serif', fontSize: 17),
      controller: controller,
      focusNode: currentFocus,
      onFieldSubmitted: (term) {
        shiftFocus(context, currentFocus, nextFocus);
      },
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: kPrimaryColor)),
          border: const OutlineInputBorder(),
          labelText: labelText,
          labelStyle: TextStyle(fontFamily: 'sans-serif', color: kTextColor),
          hintStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 15),
          hintText: hintText),
    ),
  );
}