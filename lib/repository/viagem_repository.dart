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

  Future<List<Viagem>> getAll(String cnpj) async{
    List<Viagem> viagens = [];
    var http = Dio();
    try{
      transportes.clear();
      Response response = await http.get(
          'http://mundolivre.dyndns.info:8083/api/v5/et2erp/query/getall',
          options: Options(headers: {'tenant': 'arcusrev_$cnpj'}));
      if(response.statusCode == 200){
        var results = response.data['resultSelects'];
        results['transporte'].forEach((element) async{
          Transporte transporte = Transporte.fromJson(element);
          transportes.add(transporte);
        });
        results['funcionarios'].forEach((funcionarios){
          Usuario usuario = Usuario.fromJson(funcionarios);
          print(usuario.toJson());
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

  Future updateViagem(Viagem viagem, String cnpj) async{
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson()]});
      print(viagem.toJson());
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/atualiza_viagem',
        options: Options(headers:{
          'tenant': 'arcusrev_$cnpj',
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

  Future<bool> insertViagem(Viagem viagem,String cnpj) async {
    var http = Dio();
    try{
      String viagemEncoded = jsonEncode({"1" : [viagem.toJson()]});
      print(viagem.toJson());
      Response response = await http.post(
          'http://mundolivre.dyndns.info:8083/api/v5/json/et2erp/query/cadastra_viagem',
          options: Options(headers:{
            'tenant': 'arcusrev_$cnpj',
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