import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class HttpService {
  static Future<dynamic> listarInstituicoes() async {
    return await _listarOrgs("instituicoes");
  }

  static Future<dynamic> listarConvenios() async {
    return await _listarOrgs("convenios");
  }

  static Future<dynamic> _listarOrgs(String tipo) async {
    //TODO: Para operação com API
    // final Uri url = Uri.parse("caminho/api/$tipo");

    // try {
    //   final response = await http.get(url);

    //   if (response.statusCode >= 400) {
    //     throw HttpException("Falha ao recuperar documento Instituicoes");
    //   }

    //   final map = List<Map<String, dynamic>>.from(jsonDecode(response.body));
    //   return map;
    // } catch (e) {
    //   return e;
    // }

    //TODO: Método usado para testes offline
    List<Map<String, dynamic>> map = [];
    String response;

    if (tipo == "instituicoes") {
      response = await rootBundle.loadString('assets/instituicoes.json');
    } else {
      response = await rootBundle.loadString('assets/convenios.json');
    }
    map = List<Map<String, dynamic>>.from(jsonDecode(response));

    return map;
  }

  static Future<dynamic> simular(Map<String, dynamic> parametros) async {
    //TODO: Para operação com API

    // final Uri url = Uri.parse("caminho/api/simular");

    // try {
    //   final response = await http.post(url, body: jsonEncode(parametros));

    //   if (response.statusCode >= 400) {
    //     throw HttpException("Falha na comunicação com o servidor. Tente novamente.");
    //   }

    // final simulacao = List<Map<String, dynamic>>.from(jsonDecode(response.body));
    // return simulacao;
    // } catch (e) {
    //   return e;
    // }

    //TODO: Método usado para testes offline
    final response = await rootBundle.loadString('assets/simulacao.json');

    final simulacao = List<Map<String, dynamic>>.from(jsonDecode(response));
    return simulacao;
  }
}
