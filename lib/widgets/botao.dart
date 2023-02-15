import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  final void Function()? _onClick;
  final String _label;

  const Botao(this._label, this._onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _onClick,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              _label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
