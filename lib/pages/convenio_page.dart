import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';
import 'package:prova_zummit/pages/convenio_page.dart';
import 'package:prova_zummit/providers/convenio.dart';
import 'package:prova_zummit/widgets/botao.dart';
import 'package:prova_zummit/widgets/titulo_pagina.dart';
import 'package:prova_zummit/widgets/list_tile_selecao.dart';

import '../providers/emprestimo.dart';
import '../service/sincronismo_service.dart';
import '../widgets/progress.dart';
import 'parcelas_page.dart';

class ConvenioPage extends ConsumerStatefulWidget {
  const ConvenioPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConvenioPageState();
}

class _ConvenioPageState extends ConsumerState<ConvenioPage> {
  bool _carregando = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.watch(convenioProvider);
    final listaConvenio = ref.watch(convenioProvider.notifier).listarConvenios();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(FontAwesomeIcons.arrowLeft)),
            centerTitle: true,
            title: const Text('Passo 3 de 6'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TituloPagina(
                  icon: FontAwesomeIcons.building,
                  label: "Convênio",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "Selecione um ou mais Convênio(s):",
                    style: TextStyle(fontSize: Dimensoes().fonte),
                  ),
                ),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listaConvenio.length,
                      itemBuilder: (_, i) => ListTieSelecao(
                        label: listaConvenio[i].nome,
                        selecionado: listaConvenio[i].selecionado,
                        marcar: () => ref.read(convenioProvider.notifier).selecionarConvenio(listaConvenio[i].id),
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
    final convenios = ref.read(convenioProvider.notifier).listarConveniosSelecionados();
    ref.read(emprestimoProvider.notifier).editarEmprestimo(emprestimoId: 0, convenios: convenios);

    setState(() {
      _carregando = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const ParcelaPage()),
    );
  }
}
