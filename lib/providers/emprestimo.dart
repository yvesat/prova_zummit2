import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/providers/convenio.dart';
import 'package:prova_zummit/providers/instituicao.dart';

@immutable
class Emprestimo {
  const Emprestimo({
    required this.id,
    required this.valor,
    this.parcelamento,
    this.instituicoes,
    this.convenios,
    this.valorParcela,
    this.taxaJuros,
  });

  final int id;
  final double valor;
  final int? parcelamento;
  final List<Instituicao>? instituicoes;
  final List<Convenio>? convenios;
  final double? valorParcela;
  final double? taxaJuros;

  Emprestimo copyWith({
    int? id,
    double? valor,
    int? parcelamento,
    List<Instituicao>? instituicoes,
    List<Convenio>? convenios,
    double? valorParcela,
    double? taxaJuros,
  }) {
    return Emprestimo(
      id: id ?? this.id,
      valor: valor ?? this.valor,
      parcelamento: parcelamento ?? this.parcelamento,
      instituicoes: instituicoes ?? this.instituicoes,
      convenios: convenios ?? this.convenios,
      valorParcela: valorParcela ?? this.valorParcela,
      taxaJuros: taxaJuros ?? this.taxaJuros,
    );
  }

  Map<String, dynamic> toJson(Emprestimo emprestimo) {
    Map<String, dynamic> parametros = {};

    parametros["id"] = emprestimo.id;
    parametros["parcelas"] = emprestimo.parcelamento;
    parametros["valorEmprestimo"] = emprestimo.valor;
    parametros["instituicoes"] = [];
    parametros["convenios"] = [];

    if (emprestimo.instituicoes != null) {
      if (emprestimo.instituicoes!.isNotEmpty) {
        for (final item in emprestimo.instituicoes!) {
          Map<String, dynamic> instituicao = {};
          instituicao["id"] = item.id;
          instituicao["nome"] = item.nome;
          parametros["instituicoes"].add(instituicao);
        }
      }
    }

    if (emprestimo.convenios != null) {
      if (emprestimo.convenios!.isNotEmpty) {
        for (final item in emprestimo.convenios!) {
          Map<String, dynamic> convenio = {};
          convenio["id"] = item.id;
          convenio["nome"] = item.nome;
          parametros["convenios"].add(convenio);
        }
      }
    }

    return parametros;
  }
}

class EmprestimoNotifier extends StateNotifier<List<Emprestimo>> {
  EmprestimoNotifier() : super([]);

  Emprestimo? recuperarEmprestimo() {
    return state.isEmpty ? null : state[0];
  }

  void criarEmprestimo(Emprestimo emprestimo) {
    state = [...state, emprestimo];
  }

  void editarEmprestimo({
    required int emprestimoId,
    double? valor,
    int? parcelas,
    List<Instituicao>? instituicoes,
    List<Convenio>? convenios,
    double? valorParcela,
    double? taxaJuros,
  }) {
    state = [
      for (final emprestimo in state)
        if (emprestimo.id == emprestimoId)
          emprestimo.copyWith(
            valor: valor,
            parcelamento: parcelas,
            instituicoes: instituicoes,
            convenios: convenios,
            valorParcela: valorParcela,
            taxaJuros: taxaJuros,
          )
        else
          emprestimo,
    ];
  }
}

final emprestimoProvider = StateNotifierProvider<EmprestimoNotifier, List<Emprestimo>>((ref) {
  return EmprestimoNotifier();
});
