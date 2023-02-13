//space中包含多个层,层中再包含图元和组,图元由点和线等组成.组就是图元的集合

class SpaceLayer{
  String name;
  int zIndex;
  //dynamic objects list
  final objects = <Object>[];
  SpaceLayer(this.zIndex, {this.name = ''});
}