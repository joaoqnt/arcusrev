import 'dart:convert';
import 'dart:io';
import 'package:arcusrev/model/despesa.dart';
import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:dio/dio.dart';

class ViagemRepository{
  List<Transporte> transportes = [];
  List<Usuario> usuarios = [];

  Future updateViagem(Viagem viagem, String cnpj) async{
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson()]});
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/atualiza_viagem',
        options: Options(headers:{
          'tenant': 'arcusrev_$cnpj',
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: viagemEncoded
      );
    }catch(e){
      print("erro a atualizar viagem $e");
    }
  }

  Future<List<Viagem>> filterDate(String cnpj, String date) async{
    List<Viagem> viagens = [];
    var http = Dio();
    Response response = await http.get(
        'http://mundolivre.dyndns.info:8083/api/v5/et2erp/query/filter_date?FILTRO=$date',
        options: Options(headers: {'tenant': 'arcusrev_$cnpj'}));
    if(response.statusCode == 200){
      var results = response.data['resultSelects'];
      results['viagem'].forEach((element) async {
        Viagem viagem = Viagem.fromJson(element);
        viagens.add(viagem);
        transportes.where((transporte) => transporte.id == element['TRANSPORTE']).forEach((transporte) {
          viagem.transporte = transporte;
        });
        results['despesa'].where((map)=> map['VIAGEM'] == viagem.id).forEach((elemento){
          Despesa despesa = Despesa.fromJson(elemento);
          viagem.despesas.add(despesa);
        });
      });
    }
    return viagens;
  }

  Future<List<Viagem>> getAll(String cnpj, {int? index}) async{
    List<Viagem> viagens = [];
    var http = Dio();
    try{
      if(index == null || index < 49){
        transportes.clear();
      }
      Response response = await http.get(
          'http://mundolivre.dyndns.info:8083/api/v5/et2erp/query/getall?FIRST=100&SKIP=${index == null ? 0 : index + 1}',
          options: Options(headers: {'tenant': 'arcusrev_$cnpj'}));
      if(response.statusCode == 200){
        var results = response.data['resultSelects'];
        if(index == null || index < 49){
          results['transporte'].forEach((element) async{
            Transporte transporte = Transporte.fromJson(element);
            transportes.add(transporte);
          });
        }
        results['funcionarios'].forEach((funcionarios){
          Usuario usuario = Usuario.fromJson(funcionarios);
          usuarios.add(usuario);
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
          viagens.add(viagem);
        });
      }
    }catch(e){

    }
    return viagens;
  }

  Future<bool> insertViagem(Viagem viagem,String cnpj) async {
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson(cnpj: cnpj)]});
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/cadastra_viagem',
          options: Options(headers:{
            'tenant': 'arcusrev_$cnpj',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: viagemEncoded
      );
    }catch(e){
      print("erro ao salvar viagem $e");
    }
    return true;
  }

  Future deleteViagem(Viagem viagem, String cnpj) async{
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson()]});
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/deleta_viagem',
          options: Options(headers:{
            'tenant': 'arcusrev_$cnpj',
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: viagemEncoded
      );
    }catch(e){
      print("erro ao deletar viagem $e");
    }
  }

}