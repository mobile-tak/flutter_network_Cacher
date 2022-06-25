import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String? label;
  final Function()? onTap;
  const CustomTextButton({Key? key, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.pink.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
