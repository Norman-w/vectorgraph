import 'dart:math';

import '../model/geometry/points/point_ex.dart';
import '../model/geometry/rect/RectEX.dart';
import '../objects/arc_object.dart';
import '../space/space_layer.dart';
import '../utils/num_utils.dart';

///添加弧线的测试数据到SpaceLayer中
void addTestArcList2SpaceLayer(SpaceLayer layer) {
  // //这样因为弧线所在的椭圆上得不到这样一个弧,所以绘制时候直接绘制为直线.
  // ArcObject arcObject = ArcObject.fromSVG(
  //   PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
  //   Decimal.fromInt(100),
  //   Decimal.fromInt(50),
  //   Decimal.fromInt(90),
  //   true,
  //   false,
  //   PointEX(Decimal.fromInt(100), Decimal.fromInt(50)),
  // );
  // //给定的参数没有有效的弧线,显示一条红色的线段
  // ArcObject arcObject1 = ArcObject.fromSVG(
  //   PointEX(Decimal.fromInt(0), Decimal.fromInt(0)),
  //   Decimal.fromInt(100),
  //   Decimal.fromInt(50),
  //   Decimal.fromInt(30),
  //   true,
  //   true,
  //   PointEX(Decimal.fromInt(100), Decimal.fromInt(50)),
  // );
  //
  // //测试svg参数到canvas参数填充的有效性
  //
  // //测试将转化来的canvas参数再转换回svg参数,看看方法有没有问题
  //
  // ArcObject arcObject2 = ArcObject.fromSVG(
  //   PointEX(Decimal.fromInt(400), Decimal.fromInt(300)),
  //   Decimal.fromInt(100),
  //   Decimal.fromInt(50),
  //   Decimal.fromInt(90),
  //   true,
  //   true,
  //   PointEX(Decimal.fromInt(450), Decimal.fromInt(350)),
  // );
  //
  // // print(arcObject2.toString());
  //
  // ArcObject arcObject3 = ArcObject.fromCanvas(
  //   //矩形,如果是正圆的时候,旋转也能正常检测鼠标交互点
  //   //   Rect.fromLTWH(100,-100,200,200),
  //   RectEX.fromLTWH(Decimal.fromInt(100), Decimal.fromInt(-100), Decimal.fromInt(400), Decimal.fromInt(200)),
  //   //旋转,如果是正圆的时候,旋转是没有问题的
  //   // 30.0.toDecimal()*decimalPerDegree,
  //   0.0.toDecimal() * decimalPerDegree,
  //   //圆弧的起始角度
  //   50.0.toDecimal() * decimalPerDegree,
  //   //圆弧的旋转角度,旋转正20度和旋转负340度是一样的终点
  //   20.0.toDecimal() * decimalPerDegree,
  //   // -340.0.toDecimal()*decimalPerDegree
  // );
  // // print("arcObject3 = $arcObject3");
  // arcObject3 = ArcObject.fromSVG(
  //     arcObject3.startPoint,
  //     arcObject3.rx,
  //     arcObject3.ry,
  //     arcObject3.rotationDegrees,
  //     false,
  //     true,
  //     arcObject3.endPoint);
  //
  // // layer9.addArc(arcObject);
  // // layer9.addArc(arcObject1);
  // // layer9.addArc(arcObject2);
  // layer.addArc(arcObject3);

  //region 随机的弧线
  for (int i = 0; i < 1000; i++) {
    var radiusX = Decimal.fromInt(Random().nextInt(100) + 50);
    var radiusY = Decimal.fromInt(Random().nextInt(100) + 50);
    var startX = Decimal.fromInt(Random().nextInt(40000) - 20000);
    var startY = Decimal.fromInt(Random().nextInt(20000) - 10000);
    var endX = Decimal.fromInt(Random().nextInt(200) - 100) + startX;
    var endY = Decimal.fromInt(Random().nextInt(200) - 100) + startY;
    var rotationDegrees = Decimal.fromInt(Random().nextInt(360));
    var laf = Random().nextBool();
    var sf = Random().nextBool();
    ArcObject arcObject = ArcObject.fromSVG(
      PointEX(startX, startY),
      radiusX,
      radiusY,
      rotationDegrees,
      laf,
      sf,
      PointEX(endX, endY),
    );
    layer.addArc(arcObject);
  }
  //endregion

  //添加的弧线按照跨越象限来分
  //第一种不只在单独一个象限中
  //第二种跨越相邻的下一个象限
  //第三种跨越相邻的两个象限
  //第四种跨越相邻的三个象限
  //第五种四个象限都跨越

  //每种当中都有两种情况,一种是顺时针,一种是逆时针
  var position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(-400));
  //从横向x轴作为起点,0点坐标的右下角作为第一个象限.
  //第一条样本弧线为起始角度22.5度,所占45度,顺时针
  //第二条样本弧线在第二个象限,起始角度为22.5+90度,所占45度,顺时针
  //第三条样本弧线在第三个象限,起始角度为22.5+180度,所占45度,顺时针
  //第四条样本弧线在第四个象限,起始角度为22.5+270度,所占45度,顺时针

  var startAngle = Decimal.fromInt(22) * decimalPerDegree;
  var sweepAngle = Decimal.fromInt(45) * decimalPerDegree;
  var radiusX = Decimal.fromInt(50);
  var radiusY = Decimal.fromInt(50);
  var arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(-200));
  //第二种情况,跨越相邻的象限
  //第一条样本弧线为起始角度22.5度,所占180-45=135度,顺时针
  //第二条样本弧线在第二个象限,起始角度为22.5+90度,所占180-45=135度,顺时针
  //第三条样本弧线在第三个象限,起始角度为22.5+180度,所占180-45=135度,顺时针
  //第四条样本弧线在第四个象限,起始角度为22.5+270度,所占180-45=135度,顺时针

  startAngle = Decimal.fromInt(22) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(135) * decimalPerDegree;
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(0));
  //第三种情况,跨越相邻的两个象限
  //第一条样本弧线为起始角度22.5度,所占180+45=225度,顺时针
  //第二条样本弧线在第二个象限,起始角度为22.5+90度,所占180+45=225度,顺时针
  //第三条样本弧线在第三个象限,起始角度为22.5+180度,所占180+45=225度,顺时针
  //第四条样本弧线在第四个象限,起始角度为22.5+270度,所占180+45=225度,顺时针

  startAngle = Decimal.fromInt(22) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(225) * decimalPerDegree;
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  position = PointEX(Decimal.fromInt(-400), Decimal.fromInt(200));
  //第五种情况,跨越所有的象限
  //第一条样本弧线为起始角度90-22.5=67.5度,所占360-45=315度,顺时针
  //第二条样本弧线在第二个象限,起始角度为67.5+90度,所占360-45=315度,顺时针
  //第三条样本弧线在第三个象限,起始角度为67.5+180度,所占360-45=315度,顺时针
  //第四条样本弧线在第四个象限,起始角度为67.5+270度,所占360-45=315度,顺时针

  startAngle = Decimal.fromInt(67) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(315) * decimalPerDegree;
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  startAngle += Decimal.fromInt(90) * decimalPerDegree;
  position += PointEX(Decimal.fromInt(100), Decimal.zero);
  arcObject = ArcObject.fromCanvas(
    RectEX.fromLTWH(
        position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
    Decimal.zero,
    startAngle,
    sweepAngle,
  );
  layer.addArc(arcObject);

  //下面是逆时针弧
  // 象限的顺序还是跟之前一样,只是弧线的方向变了
  // 第一条弧线是从67.5度开始,逆时针,旋转-45度,后面的三个横向位移跟之前一样,每一个都是角度+90度,旋转-45度
  // 第一种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(-400));
  startAngle = Decimal.fromInt(67) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-45) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      RectEX.fromLTWH(
          position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //第二种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(-200));
  startAngle = Decimal.fromInt(67 + 90) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-135) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      RectEX.fromLTWH(
          position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //第三种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(0));
  startAngle = Decimal.fromInt(67 + 180) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-225) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      RectEX.fromLTWH(
          position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //第四种的逆时针4个象限的弧线
  position = PointEX(Decimal.fromInt(0), Decimal.fromInt(200));
  startAngle = Decimal.fromInt(67 + 270) * decimalPerDegree;
  sweepAngle = Decimal.fromInt(-315) * decimalPerDegree;
  for (int i = 0; i < 4; i++) {
    arcObject = ArcObject.fromCanvas(
      RectEX.fromLTWH(
          position.x, position.y, radiusX * Decimal.two, radiusY * Decimal.two),
      Decimal.zero,
      startAngle,
      sweepAngle,
    );
    layer.addArc(arcObject);
    startAngle += Decimal.fromInt(90) * decimalPerDegree;
    position += PointEX(Decimal.fromInt(100), Decimal.zero);
  }
  //2023年09月24日00:25:50经过验证,使用如下检测方法
  /*
  var isInAngle = false;

    if(sweepAngle>Decimal.zero){
      if(startAngle <= centerToMouseAngle && centerToMouseAngle <= endAngle){
        isInAngle = true;
      }
    }
    else{
      if(endAngle <= centerToMouseAngle && centerToMouseAngle <= startAngle){
        isInAngle = true;
      }
    }

    if(!isInAngle){
      return false;
    }
  * */
  /*
  如果弧线是跨越过了 0,0 -> 0,>0(3点)方向的线,那么就会出现问题
  计算时,3点方向为0,顺时针旋转到9点的时候为π,旋转回到3点的时候为2π
  如果一个弧线,从1点到5点,判断条件不可以为: 1点<=鼠标角度<=5点
  而是使用: 1点<=鼠标角度<=2π 或者 0<=鼠标角度<=5点 区间的点都是有效的,如不在这个区间,就是无效的
  所以改进后的逻辑应该为
  先判断是否跨越3点线(0,2π)
  如果通过一般的方式没有判断到圆弧角度内,那么就判断是否跨越了3点线(0,2π)
  如果旋转角度是顺时针的,从起点加上旋转角度,如果大于2π,就是跨越了3点线
  如果旋转角度是逆时针的,从起点减去旋转角度,如果小于0,就是跨越了3点线,因为旋转角度这个时候本身就是负数,所以就是判断startAngle+sweepAngle是否小于0
  如果跨越了3点线,那么就要拆分成两段来判断,一段是从起点到3点线的,一段是从3点线到终点的
   */

  /*
  2023年09月27日15:11:25
  一个矩形为
  180,100,20,20 的 left top width height矩形
  里面从270度到90度做一个弧线
  看弧线的起始点和终止点
  * */

  // var test270_90 =
  // ArcObject.fromCanvas(
  //   RectEX.fromLTWH(
  //       Decimal.fromInt(180), Decimal.fromInt(100), Decimal.fromInt(20), Decimal.fromInt(20)),
  //   Decimal.zero,
  //   Decimal.fromInt(270) * decimalPerDegree,
  //   Decimal.fromInt(90) * decimalPerDegree,
  // );
  // print("起始点:${test270_90.startPoint} 终止点:${test270_90.endPoint}");
}
