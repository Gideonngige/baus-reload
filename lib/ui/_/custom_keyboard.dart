import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomKeyboard extends StatelessWidget {
  final TextEditingController tController;

  const CustomKeyboard({super.key, required this.tController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton('1'),
            _buildButton('2'),
            _buildButton('3'),
          ],
        ),
        Row(
          children: [
            _buildButton('4'),
            _buildButton('5'),
            _buildButton('6'),
          ],
        ),
        Row(
          children: [
            _buildButton('7'),
            _buildButton('8'),
            _buildButton('9'),
          ],
        ),
        Row(
          children: [
            _buildButton(''),
            _buildButton('0'),
            _buildButton('⌫', onPressed: _backspace, color: Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String text, {VoidCallback? onPressed, Color? color}) {
    return Expanded(
      child: Container(
        color: Colors.blue.withOpacity(.1),
        height: 90,
        child: InkWell(
          onTap: onPressed ?? () => _input(text),
          splashColor: Colors.white,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 35,
                color: color ?? Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _input(String text) {
    final value = tController.text + text;
    tController.text = value;
  }

  void _backspace() {
    final value = tController.text;
    if (value.isNotEmpty) {
      tController.text = value.substring(0, value.length - 1);
    }
  }
}
