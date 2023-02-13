//space中包含多个层,层中再包含图元和组,图元由点和线等组成.组就是图元的集合

class Layer{
  String name;
  int zIndex;
  Layer(this.zIndex, {this.name = ''});
}