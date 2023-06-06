import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/repository/usuario_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class LoginController{
  TextEditingController tecUsuario = TextEditingController();
  TextEditingController tecSenha = TextEditingController();
  TextEditingController tecEmpresa = TextEditingController();
  UsuarioRepository usuarioRepository = UsuarioRepository();
  Usuario? usuarioLogado;
  final formKey = GlobalKey<FormState>();
  bool? existe = false;
  bool isLogging = false;
  bool isVisible = false;

  hidePassword(){
    isVisible == true ? isVisible = false : isVisible = true;
  }

  Future<bool> doLogin() async{
    try {
      usuarioLogado = Usuario.fromJson(await usuarioRepository.doLogin(
          tecUsuario.text,
          tecSenha.text,
          UtilBrasilFields.removeCaracteres(tecEmpresa.text)
      ));
      existe = usuarioLogado!.nome == null ? false : true;
    }catch(e){
      existe = false;
    }
    return existe!;
  }
}