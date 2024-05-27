import 'dart:ui';

class ModeloNodo{
  String etiqueta;
  double x,y,radio;
  Color color;

  ModeloNodo(this.etiqueta,this.x,this.y,this.radio,this.color);
}

class ModeloEnlace {
  int nodoInicio;
  int nodoFinal;
  String valor;
  bool esCurva; // true para curva, false para línea recta

  ModeloEnlace(this.nodoInicio, this.nodoFinal, this.valor, this.esCurva);
}
