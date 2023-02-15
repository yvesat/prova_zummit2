import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Convenio {
  const Convenio({required this.id, required this.nome, required this.selecionado});

  final int id;
  final String nome;
  final bool selecionado;

  Convenio copyWith({int? id, String? nome, bool? selecionado}) {
    return Convenio(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      selecionado: selecionado ?? this.selecionado,
    );
  }
}

class ConvenioNotifier extends StateNotifier<List<Convenio>> {
  ConvenioNotifier() : super([]);

  List<Convenio> listarConveniosSelecionados() {
    return state.where((convenio) => convenio.selecionado == true).toList();
  }

  List<Convenio> listarConvenios() {
    return state;
  }

  void limparConvenios() {
    state = [];
  }

  void adicionarConvenio(Convenio convenio) {
    state = [...state, convenio];
  }

  void selecionarConvenio(int convenioId) {
    state = [
      for (final convenio in state)
        if (convenio.id == convenioId) convenio.copyWith(selecionado: !convenio.selecionado) else convenio,
    ];
  }
}

final convenioProvider = StateNotifierProvider<ConvenioNotifier, List<Convenio>>((ref) {
  return ConvenioNotifier();
});
