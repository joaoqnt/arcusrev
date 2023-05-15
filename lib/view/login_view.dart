import 'dart:math';

import 'package:arcusrev/controller/login_controller.dart';
import 'package:arcusrev/view/viagens_view.dart';
import 'package:arcusrev/widgets/circularprogress_widget.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController loginController = LoginController();
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width/1.2,
                height: MediaQuery.of(context).size.height/1.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                    boxShadow:[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 7,
                          offset: Offset(0, 5)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Usuário",
                          border: OutlineInputBorder()),
                      controller: loginController.tecUsuario,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Senha",
                            border: OutlineInputBorder()),
                        controller: loginController.tecSenha,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minHeight: 50),
                                decoration: BoxDecoration(color: Colors.blueAccent),
                                child: Text("Entrar",style: TextStyle(color: Colors.white,fontSize: 18))),
                              onTap: () async{
                                circularProgressWidget.showCircularProgress(context);
                                await loginController.doLogin();
                                circularProgressWidget.hideCircularProgress(context);
                                loginController.existe == false ? null : Navigator.push(
                                   context, MaterialPageRoute(builder: (BuildContext) => ViagensView(loginController.usuarioLogado!)
                               ));
                              },
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
