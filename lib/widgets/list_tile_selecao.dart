import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTieSelecao extends StatelessWidget {
  bool selecionado;
  String label;
  Function marcar;
  ListTieSelecao({required this.label, required this.selecionado, required this.marcar, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(1),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        selected: selecionado,
        selectedColor: Theme.of(context).colorScheme.outline,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: selecionado ? const FaIcon(FontAwesomeIcons.solidSquareCheck) : const FaIcon(FontAwesomeIcons.square),
        onTap: () => marcar(),
      ),
    );
  }
}
