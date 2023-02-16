import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/constantes/dimensoes.dart';
import 'package:prova_zummit/pages/instituicao_page.dart';
import 'package:prova_zummit/providers/emprestimo.dart';
import 'package:prova_zummit/service/sincronismo_service.dart';
import 'package:prova_zummit/widgets/botao.dart';
import 'package:prova_zummit/widgets/titulo_pagina.dart';

import '../widgets/progress.dart';

class ValorEmprestimoPage extends ConsumerStatefulWidget {
  const ValorEmprestimoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValorEmprestimoPageState();
}

class _ValorEmprestimoPageState extends ConsumerState<ValorEmprestimoPage> {
  final _formKey = GlobalKey<FormState>();
  final _edtValorEmprestimo = TextEditingController();
  double valorEditado = 0;
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Passo 1 de 6'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TituloPagina(
                  icon: FontAwesomeIcons.sackDollar,
                  label: "Valor do Empréstimo",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "Para começarmos, nos informe qual o valor do empréstimo desejado:",
                    style: TextStyle(fontSize: Dimensoes().fonte),
                  ),
                ),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _edtValorEmprestimo,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            CurrencyTextInputFormatter(
                              locale: 'pt_BR',
                              decimalDigits: 2,
                              symbol: 'R\$ ',
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Informe um valor válido.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        valorEditado.toString(),
                        style: TextStyle(fontSize: Dimensoes().fonte),
                      ),
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

  Future<void> _onProximoClick() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _carregando = true;
      });
      await SincronismoService().carregarInstituicoes(ref);
      final emprestimo = ref.read(emprestimoProvider.notifier).recuperarEmprestimo();

      final valor = _edtValorEmprestimo.text.replaceAll(",", "").replaceAll(".", "").replaceAll("R\$ ", "");

      double valorDbl = double.parse(valor);

      valorDbl = valorDbl * 0.01;

      if (emprestimo != null) {
        ref.read(emprestimoProvider.notifier).editarEmprestimo(emprestimoId: emprestimo.id, valor: valorDbl);
      } else {
        ref.read(emprestimoProvider.notifier).criarEmprestimo(Emprestimo(id: 0, valor: valorDbl, parcelamento: 1));
      }
      setState(() {
        _carregando = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const InstituicaoPage()),
      );
    }
  }
}
