import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils/componentes.dart';
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController txtCidade = TextEditingController();
  GlobalKey<FormState> cForm = GlobalKey<FormState>();

  String temperatura = "0";
  String descricao = "";
  String cidade = "Pesquise uma cidade";
  String data = "";
  String humidade = "";
  String velVento = "";
  String nascerSol = "";
  String porSol = "";
  String tempMin = "";
  String tempMax = "";
  String hora = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0XFF00BFFF), Color(0XFF1565C0)])),
          child: Column(
            children: [
              Form(
                key: cForm,
                child: Container(
                    alignment: Alignment.topCenter,
                    height: 60,
                    width: 350,
                    padding: EdgeInsets.only(top: 15),
                    child: Componentes.barraPesquisa(
                        "Buscar Cidade", txtCidade, buscaCidade)),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Componentes.resultado(cidade),
              ),
              Container(
                padding: EdgeInsets.only(top: 75, left: 26),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Componentes.temperatura(temperatura),
                    Text("°C",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 100),
                child: Componentes.resultado(descricao),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.4088,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: Colors.white38,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 35, left: 30),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/img/tempMin.png",
                                            height: 18, width: 18),
                                        Componentes.rotulo(" Temp. mínima")
                                      ],
                                    ),
                                    Componentes.resultado(tempMin),
                                  ])),
                          Container(
                              padding: EdgeInsets.only(top: 35, left: 15),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/img/tempMax.png",
                                            height: 18, width: 18),
                                        Componentes.rotulo(" Temp. máxima")
                                      ],
                                    ),
                                    Componentes.resultado(tempMax),
                                  ])),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 45, left: 30),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/img/humidity.png",
                                            height: 18, width: 18),
                                        Componentes.rotulo(" Humidade")
                                      ],
                                    ),
                                    Componentes.resultado(humidade),
                                  ])),
                          Container(
                              padding: EdgeInsets.only(top: 45, left: 15),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/img/wind.png",
                                            height: 18, width: 18),
                                        Componentes.rotulo(" Vel. do vento")
                                      ],
                                    ),
                                    Componentes.resultado(velVento),
                                  ])),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 45, left: 30),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/img/sunrise.png",
                                            height: 18, width: 18),
                                        Componentes.rotulo(" Nascer do Sol")
                                      ],
                                    ),
                                    Componentes.resultado(nascerSol),
                                  ])),
                          Container(
                            padding: EdgeInsets.only(top: 45, left: 15),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/img/sunset.png",
                                          height: 18, width: 18),
                                      Componentes.rotulo(" Pôr do Sol")
                                    ],
                                  ),
                                  Componentes.resultado(porSol),
                                ]),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          hora,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void buscaCidade() async {
    if (!cForm.currentState.validate()) return null;

    String url =
        "https://api.hgbrasil.com/weather?key=4c7b5729&city_name=${txtCidade.text}";
    Response resposta = await get(url);
    Map clima = json.decode(resposta.body);
    setState(() {
      temperatura = clima["results"]["temp"].toString();
      descricao = clima["results"]["description"].toString();
      cidade = clima["results"]["city_name"].toString();
      data = clima["results"]["date"].toString();
      humidade = clima["results"]["humidity"].toString() + "%";
      velVento = clima["results"]["wind_speedy"].toString();
      nascerSol = clima["results"]["sunrise"].toString();
      porSol = clima["results"]["sunset"].toString();
      tempMin = clima["results"]["forecast"][0]["min"].toString() + "°C";
      tempMax = clima["results"]["forecast"][0]["max"].toString() + "°C";
      hora = "Atualizado às " + clima["results"]["time"].toString();
    });
  }
}
