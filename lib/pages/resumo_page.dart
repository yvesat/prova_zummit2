import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';
import 'package:prova_zummit/pages/simluacao_page.dart';
import 'package:prova_zummit/service/http_service.dart';
import 'package:prova_zummit/service/sincronismo_service.dart';
import 'package:prova_zummit/widgets/botao.dart';
import 'package:prova_zummit/widgets/titulo_pagina.dart';
import '../providers/emprestimo.dart';
import '../widgets/campo_revisao.dart';
import '../widgets/progress.dart';

class ResumoPage extends ConsumerStatefulWidget {
  const ResumoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResumoPageState();
}

class _ResumoPageState extends ConsumerState<ResumoPage> {
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.watch(emprestimoProvider);
    final emprestimo = ref.watch(emprestimoProvider.notifier).recuperarEmprestimo();

    MoneyFormatter fmf = MoneyFormatter(
      amount: emprestimo!.valor,
      settings: MoneyFormatterSettings(symbol: 'R\$', thousandSeparator: '.', decimalSeparator: ','),
    );

    MoneyFormatterOutput fo = fmf.output;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(FontAwesomeIcons.arrowLeft)),
            centerTitle: true,
            title: const Text('Passo 5 de 6'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TituloPagina(
                  icon: FontAwesomeIcons.magnifyingGlassDollar,
                  label: "Revisão",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "Confirme se os dados estão corretos:",
                    style: TextStyle(fontSize: Dimensoes().fonte),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1.5,
                      color: Theme.of(context).colorScheme.primary,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        CampoSimulacao(
                          icon: FontAwesomeIcons.sackDollar,
                          label: 'Valor do Empréstimo:',
                          valor: Text(fo.symbolOnLeft),
                        ),
                        if (emprestimo.instituicoes != null)
                          if (emprestimo.instituicoes!.isNotEmpty)
                            CampoSimulacao(
                              icon: FontAwesomeIcons.building,
                              label: "Instituição",
                            ),
                        if (emprestimo.instituicoes != null)
                          if (emprestimo.instituicoes!.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: emprestimo.instituicoes!.length,
                              itemBuilder: (_, i) => Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  emprestimo.instituicoes![i].nome,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                        if (emprestimo.convenios != null)
                          if (emprestimo.convenios!.isNotEmpty)
                            CampoSimulacao(
                              icon: FontAwesomeIcons.briefcase,
                              label: "Convênio",
                            ),
                        if (emprestimo.convenios != null)
                          if (emprestimo.convenios!.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: emprestimo.convenios!.length,
                              itemBuilder: (_, i) => Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  emprestimo.convenios![i].nome,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                        CampoSimulacao(
                          icon: FontAwesomeIcons.calculator,
                          label: 'Parcelamento:',
                          valor: Text("x ${emprestimo.parcelamento.toString()}"),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Botao("SIMULAR", () async => _onSimularClick(emprestimo)),
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

  Future<void> _onSimularClick(Emprestimo emprestimo) async {
    setState(() {
      _carregando = true;
    });
    await SincronismoService().simulacao(ref);
    setState(() {
      _carregando = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const SimulacaoPage()),
    );
  }
}
