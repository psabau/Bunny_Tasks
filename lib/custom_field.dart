import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? hint;
  final Widget? widget;

  const InputField({
    required this.title,
    this.controller,
    required this.hint,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleText,
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 14.0),
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 1.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: false,
                    cursorColor: Get.isDarkMode
                        ? Colors.grey[100]
                        : Colors.grey[600],
                    readOnly: widget == null ? false : true,
                    controller: controller,
                    style: smallTitle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: smallTitle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                widget == null ? Container() : widget!,
              ],
            ),
          )
        ],
      ),
    );
  }
}
