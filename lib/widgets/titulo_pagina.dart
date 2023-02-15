import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';

class TituloPagina extends StatelessWidget {
  IconData icon;
  String label;

  TituloPagina({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensoes().fonte),
          ),
        ),
      ],
    );
  }
}
