import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:flutter/material.dart';

class DespesasView extends StatefulWidget {
  Viagem viagemSelected;
  Usuario usuarioLogado;
  DespesasView(this.usuarioLogado,this.viagemSelected,{Key? key}) : super(key: key);

  @override
  State<DespesasView> createState() => _DespesasViewState();
}

class _DespesasViewState extends State<DespesasView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Despesas Viagem ${widget.viagemSelected.id}")),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: widget.viagemSelected.despesas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${widget.viagemSelected.despesas[index].id} - "),
                                        Text("${widget.viagemSelected.despesas[index].nome}"),
                                        // Text("R\$: ${widget.viagemSelected.despesas[index].valor}")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("${widget.viagemSelected.despesas[index].fornecedor} - "),
                                        Text("${widget.viagemSelected.despesas[index].local}")
                                      ],
                                    )
                                  ],
                                )),
                            ),
                            Text("R\$: ${widget.viagemSelected.despesas[index].valor}",
                              style: TextStyle(color: Colors.green),)
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
