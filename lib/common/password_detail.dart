import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/widget.dart';

class PasswordDetail extends StatefulWidget {
  final String keyText;
  final String value;

  const PasswordDetail(this.keyText, this.value, {Key? key}) : super(key: key);

  @override
  _PasswordDetailState createState() => _PasswordDetailState();
}

class _PasswordDetailState extends State<PasswordDetail> {
  bool _obscureText = true;  // Password is hidden by default

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            widget.keyText,
            style: bodyText4(colorGray),
          ),
          Text(
            _obscureText ? '•' * widget.value.length : widget.value,
            style: bodyText4(colorBlack),
          ),
          IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            iconSize: 20.0,
            color: colorGray,
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          // IconButton(
          //   padding: const EdgeInsets.all(1),
          //   constraints: const BoxConstraints(),
          //   icon: Icon(
          //     _obscureText ? Icons.visibility : Icons.visibility_off,
          //     size: 20,
          //     color: colorGray,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       _obscureText = !_obscureText;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
