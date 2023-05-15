import 'dart:convert';
import 'dart:io';

import 'package:arcusrev/model/despesa.dart';
import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:dio/dio.dart';

class ViagemRepository{
  List<Transporte> transportes = [];

  Future<List<Viagem>> getAll() async{
    List<Viagem> viagens = [];

    var http = Dio();
    try{
      Response response = await http.get(
          'http://mundolivre.dyndns.info:8083/api/v5/et2erp/query/getall',
          options: Options(headers: {'tenant': 'arcusrev_25650383000174'}));
      if(response.statusCode == 200){
        var results = response.data['resultSelects'];
        results['transporte'].forEach((element) async{
          Transporte transporte = Transporte.fromJson(element);
          transportes.add(transporte);
        });
        results['viagem'].forEach((element) async{
          Viagem viagem = Viagem.fromJson(element);
          transportes.where((transporte) => transporte.id == element['TRANSPORTE']).forEach((transporte) {
            viagem.transporte = transporte;
          });
          results['despesa'].where((map)=> map['VIAGEM'] == viagem.id).forEach((elemento){
            Despesa despesa = Despesa.fromJson(elemento);
            viagem.despesas.add(despesa);
          });
          results['responsavel'].where((campo)=> campo['ID'] == element['RESPONSAVEL']).forEach((responsavel){
            Usuario usuario = Usuario.fromJson(responsavel);
            viagem.responsavel = usuario;
          });
          viagens.add(viagem);
        });
      }
    }catch(e){

    }
    return viagens;
  }

  updateViagem(Viagem viagem) async{
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson()]});
      print(viagem.toJson());
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/atualiza_viagem',
        options: Options(headers:{
          'tenant': 'arcusrev_25650383000174',
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: viagemEncoded
      );
      if(response.statusCode == 200){
        print("salvou");
      }
    }catch(e){
      print("erro a atualizar viagem $e");
    }
  }

  Future<bool> insertViagem(Viagem viagem) async {
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson()]});
      print(viagem.toJson());
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/viagem',
          options: Options(headers:{
            'tenant': 'arcusrev_25650383000174',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: viagemEncoded
      );
      if(response.statusCode == 200){
        print("salvou");
      }
    }catch(e){
      print("erro ao salvar viagem $e");
    }
    return true;
  }
}