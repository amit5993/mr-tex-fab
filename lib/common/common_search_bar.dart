// common_search_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:td/utils/color.dart';

class CommonSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onEditingComplete;
  final String labelText;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color backgroundColor;
  final Color iconColor;

  const CommonSearchBar({
    Key? key,
    required this.onSearchChanged,
    this.onEditingComplete,
    this.labelText = 'Search',
    this.labelStyle,
    this.inputStyle,
    this.backgroundColor = colorWhite,
    this.iconColor = colorGray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                style: inputStyle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none,
                  labelStyle: labelStyle,
                ),
                onEditingComplete: onEditingComplete,
                onChanged: onSearchChanged,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Icon(Icons.search, color: iconColor),
          )
        ],
      ),
    );
  }
}
