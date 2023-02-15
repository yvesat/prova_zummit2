import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';
import 'package:prova_zummit/service/http_service.dart';
import 'package:prova_zummit/service/sincronismo_service.dart';
import 'package:prova_zummit/widgets/botao.dart';
import 'package:prova_zummit/widgets/titulo_pagina.dart';
import '../providers/emprestimo.dart';
import '../widgets/campo_revisao.dart';
import '../widgets/progress.dart';

class SimulacaoPage extends ConsumerStatefulWidget {
  const SimulacaoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SimulacaoPageState();
}

class _SimulacaoPageState extends ConsumerState<SimulacaoPage> {
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ref.watch(emprestimoProvider);
    final emprestimo = ref.watch(emprestimoProvider.notifier).recuperarEmprestimo();

    MoneyFormatter formatacaoTotal = MoneyFormatter(
      amount: emprestimo!.valor,
      settings: MoneyFormatterSettings(symbol: 'R\$', thousandSeparator: '.', decimalSeparator: ','),
    );

    MoneyFormatterOutput vTotalEmprestimoFormatado = formatacaoTotal.output;

    MoneyFormatter formatacaoParcela = MoneyFormatter(
      amount: emprestimo.valorParcela!,
      settings: MoneyFormatterSettings(symbol: 'R\$', thousandSeparator: '.', decimalSeparator: ','),
    );

    MoneyFormatterOutput vParcelaEmprestimoFormatada = formatacaoParcela.output;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(FontAwesomeIcons.arrowLeft)),
            centerTitle: true,
            title: const Text('Passo 6 de 6'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TituloPagina(
                    icon: FontAwesomeIcons.handHoldingDollar,
                    label: "Simulação",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      "Pronto! Aqui está sua simulação.",
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
                            valor: Text(vTotalEmprestimoFormatado.symbolOnLeft),
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
                              valor: Text(
                                "${vParcelaEmprestimoFormatada.symbolOnLeft.toString()} x ${emprestimo.parcelamento.toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          if (emprestimo.parcelamento! > 1)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              height: size.height * 0.15,
                              child: Scrollbar(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: emprestimo.parcelamento,
                                    itemBuilder: (_, i) {
                                      final int parcela = i + 1;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(parcela.toString()),
                                            Text(
                                              vParcelaEmprestimoFormatada.symbolOnLeft.toString(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          CampoSimulacao(
                            icon: FontAwesomeIcons.fileInvoiceDollar,
                            label: 'Taxa de Juros:',
                            valor: Text("${emprestimo.taxaJuros.toString()}%"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16),
                  //   child: Botao("SIMULAR", () async => _onSimularClick(emprestimo)),
                  // ),
                ],
              ),
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
    // SincronismoService().simulacao(ref);

    setState(() {
      _carregando = false;
    });
    // ignore: use_build_context_synchronously
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (BuildContext context) => const ResumoPage()),
    // );
  }
}
