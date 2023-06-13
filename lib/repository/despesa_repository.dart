import 'dart:convert';
import 'dart:io';
import 'package:arcusrev/model/despesa.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:dio/dio.dart';

class DespesaRepository{

  Future getDespesa(Viagem viagem, String cnpj) async{
    var http = Dio();
    try{
      Response response = await http.get(
          'http://mundolivre.dyndns.info:8083/api/v5/et2erp/query/get_despesa?VIAGEM=${viagem.id}',
          options: Options(headers: {'tenant': 'arcusrev_$cnpj'}));
      if(response.statusCode == 200){
        var results = response.data['resultSelects'];
        viagem.despesas.clear();
        results['despesa'].forEach((elemento){
          Despesa despesa = Despesa.fromJson(elemento);
          viagem.despesas.add(despesa);
        });
      }
    }catch(e){
      print("Erro ao pegar as despesas atuais $e");
    }
  }

  Future<bool> insertDespesa(Despesa despesa, Viagem viagem,String cnpj) async {
    var http = Dio();
    try{
      String despesaEncoded = jsonEncode({"1" : [despesa.toJson(viagem: viagem.id)]});
      await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/cadastra_despesa',
          options: Options(headers:{
            'tenant': 'arcusrev_$cnpj',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: despesaEncoded
      );
    }catch(e){
      print("erro ao cadastrar despesa $e");
    }
    return true;
  }

  Future updateDespesa(Despesa despesa, Viagem viagem, String cnpj) async{
    var http = Dio();
    try{
      String despesaEncoded = jsonEncode({"1" : [despesa.toJson(viagem: viagem.id)]});
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/atualiza_despesa',
          options: Options(headers:{
            'tenant': 'arcusrev_$cnpj',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: despesaEncoded
      );
    }catch(e){
      print("erro ao atualizar despesa $e");
    }
  }

  Future deleteDespesa(Viagem viagem,int index, String cnpj) async{
    var http = Dio();
    try{
      String despesaEncoded = jsonEncode({"1" : [viagem.despesas[index].toJson(viagem: viagem.id)]});
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/deleta_despesa',
          options: Options(headers:{
            'tenant': 'arcusrev_$cnpj',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: despesaEncoded
      );
    }catch(e){
      print("erro ao deletar despesa $e");
    }
  }

}