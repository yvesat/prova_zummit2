import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/providers/convenio.dart';
import 'package:prova_zummit/providers/emprestimo.dart';
import 'package:prova_zummit/providers/instituicao.dart';
import 'package:prova_zummit/service/http_service.dart';

import '../models/http_exception.dart';

class SincronismoService {
  Future<dynamic> carregarInstituicoes(WidgetRef ref) async {
    final listaInstituicoes = ref.read(instituicaoProvider.notifier).listarInstituicao();
    if (listaInstituicoes.isEmpty) {
      try {
        await Future.delayed(const Duration(seconds: 1)); //Simular carregamento web

        final retorno = await HttpService.listarInstituicoes();
        if (retorno is HttpException) throw retorno;
        for (final instituicao in retorno) {
          ref.read(instituicaoProvider.notifier).adicionarInstituicao(Instituicao(
                id: instituicao["id"],
                nome: instituicao["nome"],
                selecionado: false,
              ));
        }
      } catch (e) {
        return e;
      }
    }
  }

  Future<dynamic> carregarConvenio(WidgetRef ref) async {
    final listaConvenios = ref.read(convenioProvider.notifier).listarConvenios();

    if (listaConvenios.isEmpty) {
      try {
        await Future.delayed(const Duration(seconds: 1)); //Simular carregamento web

        final retorno = await HttpService.listarConvenios();
        if (retorno is HttpException) throw retorno;
        for (final convenio in retorno) {
          ref.read(convenioProvider.notifier).adicionarConvenio(Convenio(
                id: convenio["id"],
                nome: convenio["nome"],
                selecionado: false,
              ));
        }
      } catch (e) {
        return e;
      }
    }
  }

  Future<dynamic> simulacao(WidgetRef ref) async {
    final emprestimo = ref.read(emprestimoProvider.notifier).recuperarEmprestimo();

    if (emprestimo != null) {
      try {
        await Future.delayed(const Duration(seconds: 1)); //Simular carregamento web

        final retorno = await HttpService.simular(emprestimo.toJson(emprestimo));

        if (retorno is HttpException) throw retorno;

        //Gravando dados fictícios
        ref.read(emprestimoProvider.notifier).editarEmprestimo(
              emprestimoId: emprestimo.id,
              taxaJuros: retorno[0]["taxaJuros"],
              valorParcela: retorno[0]["valorParcela"],
              parcelas: retorno[0]["parcelas"],
              valor: retorno[0]["valorEmprestimo"],
            );

        //Gravando dados como seriam com conexão a API
        // ref.read(emprestimoProvider.notifier).editarEmprestimo(emprestimoId: emprestimo.id, taxaJuros: retorno[0]["taxaJuros"], valorParcela: retorno[0]["valorParcela"]);
      } catch (e) {
        return e;
      }
    }
  }
}
