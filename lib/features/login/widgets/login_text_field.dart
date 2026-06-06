import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const LoginTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Card(
          elevation: 5,
          child: TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
