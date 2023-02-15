import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';
import 'package:prova_zummit/pages/convenio_page.dart';
import 'package:prova_zummit/providers/instituicao.dart';
import 'package:prova_zummit/widgets/botao.dart';
import 'package:prova_zummit/widgets/titulo_pagina.dart';
import 'package:prova_zummit/widgets/list_tile_selecao.dart';

import '../providers/emprestimo.dart';
import '../service/sincronismo_service.dart';
import '../widgets/progress.dart';

class InstituicaoPage extends ConsumerStatefulWidget {
  const InstituicaoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InstituicaoPageState();
}

class _InstituicaoPageState extends ConsumerState<InstituicaoPage> {
  bool _carregando = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.watch(instituicaoProvider);
    final listaInstituicao = ref.watch(instituicaoProvider.notifier).listarInstituicao();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(FontAwesomeIcons.arrowLeft)),
            centerTitle: true,
            title: const Text('Passo 2 de 6'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TituloPagina(
                  icon: FontAwesomeIcons.building,
                  label: "Instituição",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "Selecione uma ou mais Instituição(ções):",
                    style: TextStyle(fontSize: Dimensoes().fonte),
                  ),
                ),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listaInstituicao.length,
                      itemBuilder: (_, i) => ListTieSelecao(
                        label: listaInstituicao[i].nome,
                        selecionado: listaInstituicao[i].selecionado,
                        marcar: () => ref.read(instituicaoProvider.notifier).selecionarInstituicao(listaInstituicao[i].id),
                      ),
                    )
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

  Future<void> _onProximoClick() async {
    setState(() {
      _carregando = true;
    });
    await SincronismoService().carregarConvenio(ref);
    final instituicoes = ref.read(instituicaoProvider.notifier).listarInstituicoesSelecionadas();
    ref.read(emprestimoProvider.notifier).editarEmprestimo(emprestimoId: 0, instituicoes: instituicoes);

    setState(() {
      _carregando = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const ConvenioPage()),
    );
  }
}
