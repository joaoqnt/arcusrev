import 'package:arcusrev/controller/login_controller.dart';
import 'package:arcusrev/view/viagens_view.dart';
import 'package:arcusrev/widgets/circularprogress_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController loginController = LoginController();
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();

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
                child: Form(
                  key: loginController.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textFormFieldWidget.criaTff(loginController.tecUsuario, "Usuário",tamanho: 15),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                        child: textFormFieldWidget.criaTff(
                            loginController.tecSenha,
                            "Senha",
                            tamanho: 10,
                            password: true,
                            visible: !loginController.isVisible,
                            icone: IconButton(
                                onPressed: (){
                                  loginController.hidePassword();
                                  setState(() {});
                                },
                                icon: loginController.isVisible == false ?
                                Icon(Icons.visibility) : Icon(Icons.visibility_off))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                        child: textFormFieldWidget.criaTff(loginController.tecEmpresa, "Cnpj da empresa",tamanho: 14),
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
                                  if (loginController.formKey.currentState!.validate() ) {
                                    circularProgressWidget.showCircularProgress(context);
                                    await loginController.doLogin();
                                    circularProgressWidget.hideCircularProgress(context);
                                    loginController.existe == false ? null : Navigator.push(
                                        context, MaterialPageRoute(builder: (BuildContext) =>
                                        ViagensView(loginController.usuarioLogado!,loginController.tecEmpresa.text)
                                    ));
                                  }
                                },
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
