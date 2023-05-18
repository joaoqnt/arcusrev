import 'dart:convert';
import 'dart:io';
import 'package:arcusrev/model/despesa.dart';
import 'package:dio/dio.dart';

class DespesaRepository{

  Future<bool> insertDespesa(Despesa despesa,{int? viagem}) async {
    var http = Dio();
    try{
      String despesaEncoded = jsonEncode({"1" : [despesa.toJson(viagem: viagem)]});
      print(despesaEncoded);
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/cadastra_despesa',
          options: Options(headers:{
            'tenant': 'arcusrev_25650383000174',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: despesaEncoded
      );
      if(response.statusCode == 200){
        print("salvou");
      }
    }catch(e){
      print("erro ao salvar despesa $e");
    }
    return true;
  }

  Future updateDespesa(Despesa despesa, int viagem) async{
    var http = Dio();
    try{
      String despesaEncoded = jsonEncode({"1" : [despesa.toJson(viagem: viagem)]});
      print(despesaEncoded);
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/atualiza_despesa',
          options: Options(headers:{
            'tenant': 'arcusrev_25650383000174',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: despesaEncoded
      );
      if(response.statusCode == 200){
        print("salvou");
      }
    }catch(e){
      print("erro ao atualizar despesa $e");
    }
  }

  Future deleteDespesa(Despesa despesa, int viagem) async{
    var http = Dio();
    try{
      String despesaEncoded = jsonEncode({"1" : [despesa.toJson(viagem: viagem)]});
      print(despesaEncoded);
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/deleta_despesa',
          options: Options(headers:{
            'tenant': 'arcusrev_25650383000174',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: despesaEncoded
      );
      if(response.statusCode == 200){
        print("salvou");
      }
    }catch(e){
      print("erro ao deletar despesa $e");
    }
  }

}