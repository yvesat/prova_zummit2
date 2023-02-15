import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Instituicao {
  const Instituicao({required this.id, required this.nome, required this.selecionado});

  final int id;
  final String nome;
  final bool selecionado;

  Instituicao copyWith({int? id, String? nome, bool? selecionado}) {
    return Instituicao(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      selecionado: selecionado ?? this.selecionado,
    );
  }
}

class InstituicaoNotifier extends StateNotifier<List<Instituicao>> {
  InstituicaoNotifier() : super([]);

  List<Instituicao> listarInstituicoesSelecionadas() {
    return state.where((instituicao) => instituicao.selecionado == true).toList();
  }

  List<Instituicao> listarInstituicao() {
    return state;
  }

  void adicionarInstituicao(Instituicao instituicao) {
    state = [...state, instituicao];
  }

  void selecionarInstituicao(int instituicaoId) {
    state = [
      for (final instituicao in state)
        if (instituicao.id == instituicaoId) instituicao.copyWith(selecionado: !instituicao.selecionado) else instituicao,
    ];
  }
}

final instituicaoProvider = StateNotifierProvider<InstituicaoNotifier, List<Instituicao>>((ref) {
  return InstituicaoNotifier();
});
