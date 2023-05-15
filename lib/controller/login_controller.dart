import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/repository/usuario_repository.dart';
import 'package:flutter/material.dart';

class LoginController{
  TextEditingController tecUsuario = TextEditingController(text: '1104');
  TextEditingController tecSenha = TextEditingController(text: '0');
  UsuarioRepository usuarioRepository = UsuarioRepository();
  Usuario? usuarioLogado;
  bool? existe = false;
  bool isLogging = false;

  Future<bool> doLogin() async{
    try {
      usuarioLogado = Usuario.fromJson(await usuarioRepository.doLogin(tecUsuario.text, tecSenha.text));
      existe = usuarioLogado!.nome == null ? false : true;
    }catch(e){
      existe = false;
    }
    return existe!;
  }
}