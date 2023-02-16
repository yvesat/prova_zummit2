import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CampoSimulacao extends StatelessWidget {
  IconData icon;
  String label;
  Widget? valor;

  CampoSimulacao({required this.icon, required this.label, this.valor, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 40,
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(child: FaIcon(icon)),
              ),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
          if (valor != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 8, 0, 0),
              child: valor ??= const Text(""),
            )
        ],
      ),
    );
  }
}
