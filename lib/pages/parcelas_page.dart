import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';
import 'package:prova_zummit/pages/resumo_page.dart';
import 'package:prova_zummit/widgets/botao.dart';
import 'package:prova_zummit/widgets/titulo_pagina.dart';
import 'package:prova_zummit/widgets/list_tile_selecao.dart';

import '../providers/emprestimo.dart';
import '../service/sincronismo_service.dart';
import '../widgets/progress.dart';

class ParcelaPage extends ConsumerStatefulWidget {
  const ParcelaPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ParcelaPageState();
}

class _ParcelaPageState extends ConsumerState<ParcelaPage> {
  bool _carregando = false;
  int _parcelaSelecionada = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.watch(emprestimoProvider);
    final emprestimo = ref.watch(emprestimoProvider.notifier).recuperarEmprestimo();
    _parcelaSelecionada = emprestimo!.parcelamento!;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(FontAwesomeIcons.arrowLeft)),
            centerTitle: true,
            title: const Text('Passo 4 de 6'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TituloPagina(
                  icon: FontAwesomeIcons.calculator,
                  label: "Parcelas",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "Selecione o melhor parcelamento pra você:",
                    style: TextStyle(fontSize: Dimensoes().fonte),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTieSelecao(
                      label: "36",
                      selecionado: _parcelaSelecionada == 36,
                      marcar: () {
                        _selecionaParcela(36, emprestimo);
                      },
                    ),
                    ListTieSelecao(
                      label: "48",
                      selecionado: _parcelaSelecionada == 48,
                      marcar: () {
                        _selecionaParcela(48, emprestimo);
                      },
                    ),
                    ListTieSelecao(
                      label: "60",
                      selecionado: _parcelaSelecionada == 60,
                      marcar: () {
                        _selecionaParcela(60, emprestimo);
                      },
                    ),
                    ListTieSelecao(
                      label: "72",
                      selecionado: _parcelaSelecionada == 72,
                      marcar: () {
                        _selecionaParcela(72, emprestimo);
                      },
                    ),
                    ListTieSelecao(
                      label: "84",
                      selecionado: _parcelaSelecionada == 84,
                      marcar: () {
                        _selecionaParcela(84, emprestimo);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Botao("PRÓXIMO", () async => _onProximoClick()),
                ),
              ],
            ),
          ),
        ),
        if (_carregando)
          Progress(
            size,
            mensagem: "",
          )
      ],
    );
  }

  void _selecionaParcela(int parcelaAtual, Emprestimo emprestimo) {
    int definirParcela;
    _parcelaSelecionada == parcelaAtual ? definirParcela = 1 : definirParcela = parcelaAtual;
    ref.read(emprestimoProvider.notifier).editarEmprestimo(emprestimoId: emprestimo.id, parcelas: definirParcela);
  }

  Future<void> _onProximoClick() async {
    setState(() {
      _carregando = true;
    });
    await SincronismoService().carregarConvenio(ref);
    ref.read(emprestimoProvider.notifier).editarEmprestimo(emprestimoId: 0, parcelas: _parcelaSelecionada);

    setState(() {
      _carregando = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const ResumoPage()),
    );
  }
}
