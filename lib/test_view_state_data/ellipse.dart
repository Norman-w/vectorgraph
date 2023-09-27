// import '../model/geometry/planes/ellipse.dart';
import '../model/geometry/points/point_ex.dart';
import '../objects/ellipse_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

void addEllipseList2SpaceLayer(SpaceLayer layer) {
  // Ellipse ellipse = Ellipse()
  //   ..radiusX = Decimal.fromInt(50)
  //   ..radiusY = Decimal.fromInt(25);

  // for(var i=0;i<360;i++){
  //   var pt = ellipse.getOnEdgePointByAngle(Decimal.fromInt(i));
  //   PointObject pointObject = PointObject(pt.x,pt.y);
  //   layer8.addPoint(pointObject);
  // }

  layer.addEllipse(
      EllipseObject(PointEX.zero, Decimal.fromInt(100), Decimal.fromInt(50)));

  // var pt = ellipse.getOnEdgePointByAngle(Decimal.fromInt(15));
  // print(pt);
}
