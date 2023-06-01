import 'package:arcusrev/model/empresa.dart';
import 'package:dio/dio.dart';

class EmpresaRepositoy{
  Future<Empresa> getAll(String cnpj) async{
    Empresa empresa = Empresa();
    var http = Dio();
    try{
      Response response = await http.get(
          'http://mundolivre.dyndns.info:8083/api/v5/et2erp/query/getempresa?CNPJ=$cnpj',
          options: Options(headers: {'tenant': 'arcusrev_$cnpj'}));
      if(response.statusCode == 200){
        var results = response.data['resultSelects'];
        results['empresa'].forEach((element) async{
          Empresa _empresa = Empresa.fromJson(element);
          empresa = _empresa;
        });
      }
    }catch(e){

    }
    return empresa;
  }
}