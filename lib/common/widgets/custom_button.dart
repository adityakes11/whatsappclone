import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    child:Text(text,style: const TextStyle(
      color: blackColor
    ),),
    onPressed: onPressed,style: ElevatedButton.styleFrom(
      backgroundColor:tabColor,
      minimumSize: const Size(double.infinity,50),
    ));
  }
}
