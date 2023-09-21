import 'package:flutter/material.dart';

class MenuBackground extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget content;
  const MenuBackground(
      {super.key, this.width, this.height, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: (height ?? MediaQuery.of(context).size.height) * 0.9,
        width: (width ?? MediaQuery.of(context).size.width) * 0.66,
        alignment: Alignment.topLeft,
        padding:
            EdgeInsets.all((width ?? MediaQuery.of(context).size.width) * 0.02),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15)),
        child: content);
  }
}
