import 'package:arcusrev/model/usuario.dart';
import 'package:dio/dio.dart';

class UsuarioRepository{
  Future<Map<String,dynamic>> doLogin(String usuario, String senha, String cnpj) async{
    var http = Dio();
    Map<String,dynamic> mapUsuario = Map();
    try{
      Response response = await http.get(
          'http://mundolivre.dyndns.info:8083/api/v5/et2erp/login/usuario?FUNUSUARIO=${usuario}&FUNSENHAAPP=${senha}',
          options: Options(headers: {'tenant': 'arcusrev_$cnpj'}));
      if(response.statusCode == 200){
        var results = response.data['resultSelects'];
        results['login'].forEach((element) async{
          if(!element.isEmpty){
            Usuario usuario = Usuario.fromJson(element);
            mapUsuario = usuario.toJson();
          }
        });
      }
    }catch(e){
    }
    return mapUsuario;
  }
}