/// 在视口上有标尺,可以根据用户选择是否开启


import 'dart:math';

import 'package:flutter/material.dart';

import 'dash_line_painter.dart';
class Ruler extends StatelessWidget {
  final Rect rect;
  Ruler(this.rect);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RulerPainter(rect),
    );
  }
}

List<List<double>> allDrawDivideList = [
  [0.005, 0.01, 0.05, 0.1],
  [0.001, 0.02, 0.1],
  [0.002, 0.05, 0.2],
  [0.005, 0.01, 0.5],
  [0.01, 0.02, 0.05, 0.1],
  [0.02, 0.1, 0.2, 0.5],
  [0.05, 0.1, 0.5, 1],
  [0.1, 0.25, 0.5, 1],
  [0.2, 0.5, 1, 2],
  [0.5, 1, 2.5, 5],
  [1, 2.5, 5, 10],
  [2.5, 12.5, 25],
  [5, 25, 50],
  [10, 50, 100],
  [25, 125, 250],
  [50, 250, 500],
  [100, 500, 1000],
  [250, 125, 2500],
  [500, 250, 5000],
  [1000, 5000, 10000],
  [2500, 12500, 25000],
  [5000, 25000, 50000],
  [10000, 50000, 100000],
  [25000, 125000, 250000],
  [50000, 250000, 1000000],
];

class RulerPainter extends CustomPainter {
  final Rect usingPaperRect;

  RulerPainter(this.usingPaperRect);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    /*画线的的时候始终保持两级
    思路A:
    比如宽度640,正常绘制是10一个小格
    放大:
      当每个格子的宽度超过10的时候,绘制更精细的一级
    缩小:
      当每个格子的宽度不够15的时候,绘制更粗糙的一级
    inkScape的层级:5000(都分10个小格),2500,1000,500,250,100,50,25,10,5,2,1(分10份),1分50份,1分100份(此时640分辨率只能显示1)

    思路B:从上往下算,每200个画一条长线.当每个小格子中间的像素超过20,那就往下继续算一级,算好当前的级别以后再进行绘制.
    如果每一个小格子是1毫米,20个像素,那么640的区域可以表示32毫米大小.
    当放大一倍时,640的区域只能显示16毫米,也就是40个像素为一个格了.这显然超出了20的大小.所以要精细一级,在每一个空当中再塞一个.
    当放大1.5倍时,640的区域可以显示24毫米,也就是30像素为一个格,也是超出了20的大小,所以也要分成两半,每一半是15像素.
    每次渲染的时候计算单步的大小方法是
    用宽度1920/显示区域100个单位,每个单位是19.2,大于12.5且小于20.可以直接显示.
    用宽度1920/显示区域1000个单位,每个单位是1.92,小于12.5,需要算出12.5是1.92的多少倍.是12.5/1.92=6.51041666667倍.
    这个方案好像不行

    思路C:
    加入左上角就是base plate和view port的重合点
    用1000屏幕画100大小,每10个像素一格,100个一显示数字,正好. 数字显示为0,10,20,30,40,50,60,70,80,90
    用1000屏幕画1000大小,每1个一格,太小,1个的都忽略,10个一显示,0,100,200,300,400,500,600,700,800,900
    用1000屏幕画10000大小,每0.1个一格,太太小,小于10个的都忽略,100个一显示,显示内容为 0,1000,2000,3000,4000,5000,6000,7000,8000,9000
    用1000屏幕画10大小,每100个像素一格,太大了,往里面再加入10等分的,在每个100处显示一个数字 为: 0,1,2,3,4,5,6,7,8,9
    用1000屏幕画1大小,每1000个像素显示为1太大了,往里面再加入10等分,结果每个格子100还是太大了,再加入10等分,结果为10个像素一个格子
    正好.由于拆分了两次,所以最小的一个格也就代表1/10/10=0.01了. 每0.1显示一次数字,就是 0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9

    用1000屏幕画0.1大小,1000个像素显示1,也就是1000/0.1得到的.
    往里面加入等分的次数为3次.最后10个像素一个格子显示0.001.每0.01显示一次数字 也就是 0, 0.01, 0.02 这样的

    所以推算一下,数字量级为 1000/0.1为一个像素的大小0.001.
    10个像素的大小为0.01
    显示文字的地方为100个像素的大小0.01

    没完成 想不下去了

    思路D:
    像InkScape一样,使用层级 1, 2, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000
    但是怎么用?
    当显示的总大小为1的时候,最小格0.01,然后是
                     0.05    0.1   0.5   1 一个比一个长
    加大窗口显示范围后,  0.02   0.1   0.2   1  一个比一个长.
    再次加大以后        0.1     0.5   1
                      0.2     1     2
                      0.5     2.5   5
                      1       5     10
                      2.5     12.5  25
                      5       25    50
                      10      50    100
                      25      125   250
                      50      250   500
                      100     500   1,000
                      ......        100,000

    定义一个最小可以展示的两个格子之间的间距.比如8
    用视窗的短边比如 16:10的视窗,10就是高,为短,显示区域是800,那么
    800/8为100,也就是最大能画到100个小格子.所以使用  10  50  100 来画线,到100的地方做一个数字标记.
    如果最小距离设置为4的话,
    800/4为200,也就是最大能画200个格子,所以还是使用10,50,100来画线和标记,因为没达到250不能改变格子大小.
    800/250=3.2是不满足最小格子的条件的.

    综上所述我们
    1,定义不同尺寸的画线距离DrawDivideList
    2,知道传入的要绘制的区间DrawingPaperRect
    3,知道视窗的大小(像素)ViewRect
    4,设定两个最小格子之间的最小间距MinPixelsPerTinyGrid
    5,获取要绘制的区间的短面ShorterSide  可选的 可以没有
    6,短面/最小间距向上取档得出最小格步进Step=ViewRect.Width/99↑100
    7,按最小格步进拆分DrawingPaperRect:  DrawingPaperRect/10 并
    8,往后依次绘制线条.每到100,画一个文字.

    试试这个方法吧2023-02-12 15:07:17
     */
    //region 1
    //allDrawDivideList
    //endregion
    //region 2
    //usingPaperRect
    //endregion
    //region 3
    var viewRect = Rect.fromLTWH(0, 0, size.width, size.height);
    //endregion
    //region 4
    double minPixelsPerTinyGrid10000 = 5 * 10000;
    //endregion
    //region 5 略过
    //endregion
    //一个小格代表多长/最短的线的间隔.
    double tinyGridValue10000 = 0;
    //要展示的区域要被分成分多少段
    double divideCount = 0;
    //每一段的像素步长
    double perTinyStepPixels10000 = 0;
    List<double> subDivideList = [];
    //region 6 7 按照最小格子在显示上必须要满足多少像素的要求,来选择最小格子的值,同时计算要拆分成多少段
    for (var level in allDrawDivideList) {
      //6
      tinyGridValue10000 = level[0] * 10000;
      //7
      divideCount = usingPaperRect.width * 10000 / tinyGridValue10000;
      perTinyStepPixels10000 = viewRect.width * 10000 / divideCount;
      if (perTinyStepPixels10000 > minPixelsPerTinyGrid10000) {
        subDivideList = level;
        break;
      }
    }
    //endregion
    //region 如果检测了完了以后最小的格子都不满足最小像素要求,那么就不画了
    if (perTinyStepPixels10000 < minPixelsPerTinyGrid10000) {
      return;
    }
    //endregion
    //要绘制的世界坐标的最小值,也就是画面的最左边的值
    var usingPaperLeft10000 = usingPaperRect.left * 10000;
    var usingPaperTop10000 = usingPaperRect.top * 10000;
    //最小段的偏移量,比如从左边开始,一个小格子是10,如果要显示的100,那从0开始直接画线就可以,当前要显示的是101.1,那么偏移出来1.1以后再画线
    double subDivideXOffset10000 = (usingPaperLeft10000 % (tinyGridValue10000));
    double subDivideYOffset10000 = (usingPaperTop10000 % (tinyGridValue10000));
    //8 绘制
    //最大的线时的画笔
    //region 各个层级的线的绘制参数
    double maxDivideDrawingLineStart = 2;
    double midDivideDrawingLineStart = 5;
    double smallDivideDrawingLineStart = 8;
    double tinyDivideDrawingLineStart = 10;
    double allDivideDrawingLineEnd = 15;



    var maxDividePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    var midDividePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    var smallDividePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.8;
    var tinyDividePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;
    //竖排时,文字和横线之间的缝隙
    double verticalTextGap = 2;
    //endregion


    var subDividesStart = subDivideList.length - 1;
    //最长的线的间隔
    var subDivideLongest10000 = subDivideList[subDividesStart] * 10000;
    //次长的线的间隔
    var subDivideMid10000 = subDivideList[subDividesStart - 1] * 10000;
    //次短的线的间隔
    double? subDivideSmall10000 = subDivideList.length == 4 ? subDivideList[1] *
        10000 : null;
    //要绘制的纸张上的区域的宽度.这个宽度是世界坐标中的宽度,不是像素宽度
    double usingPaperWidth10000 = usingPaperRect.width * 10000;
    //要绘制的纸张上的区域的高度.这个高度是世界坐标中的高度,不是像素高度
    double usingPaperHeight10000 = usingPaperRect.height * 10000;
    //8
    //把要绘制的区间的值当做是世界坐标中的值.把矩形框中作为本地坐标.
    //本地坐标从0开始绘制,绘制到usingPaperWidth10000结束.
    //每次绘制的步长是每一个小格子的值,也就是tinyGridValue10000

    //region 绘制横尺
    for (
    double currentLocalValue10000 = 0;
    currentLocalValue10000 < usingPaperWidth10000;
    currentLocalValue10000 += tinyGridValue10000) {
      //region 坐标计算
      //当前世界坐标上的值为
      var currentWorldValue10000 = usingPaperLeft10000 + currentLocalValue10000;
      //当前坐落在坐标上的下一个本地坐标点为:
      var currentStepValue10000 = (currentWorldValue10000 -
          subDivideXOffset10000) + tinyGridValue10000;
      //当前坐落在坐标上的下一个本地坐标点的像素值为:
      var x = currentStepValue10000 / tinyGridValue10000 *
          perTinyStepPixels10000;
      var a = usingPaperLeft10000 / tinyGridValue10000 * perTinyStepPixels10000;
      var f = x - a;
      //上面三行加上下面这一行具体咋回事我也不知道了.一点一点瞎猫碰死耗子测试出来的反正显示是正确的.
      x = f / 10000;
      //endregion
      //region 检查长的,如果当前的数值匹配到长的,就画长的.最长的那个上要画出来数字文字
      //如果匹配到了最长的,别的就不画了
      if (currentStepValue10000.toInt() % subDivideLongest10000.toInt() == 0) {
        canvas.drawLine(Offset(x, maxDivideDrawingLineStart), Offset(x, allDivideDrawingLineEnd), maxDividePaint);
        // print(currentValue10000);
        var currentStepString = (currentStepValue10000 / 10000).toStringAsFixed(
            2).replaceAll('.00', '');
        TextPainter(
          text: TextSpan(
            text: currentStepString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        )
          ..layout()
          ..paint(canvas, Offset(x, allDivideDrawingLineEnd));
        continue;
      }
      //endregion
      //region 如果匹配到了中等长度的,别的就不画了.
      if (currentStepValue10000 % subDivideMid10000 == 0) {
        canvas.drawLine(Offset(x, midDivideDrawingLineStart), Offset(x, allDivideDrawingLineEnd), midDividePaint);
        continue;
      }
      //endregion
      //region 四个规格中的第二短的如果存在并且match到了.绘制
      if (subDivideSmall10000 != null &&
          currentStepValue10000 % subDivideSmall10000 == 0) {
        canvas.drawLine(Offset(x, smallDivideDrawingLineStart), Offset(x, allDivideDrawingLineEnd), smallDividePaint);
        continue;
      }
      //endregion
      //region 绘制最短的
      canvas.drawLine(Offset(x, tinyDivideDrawingLineStart), Offset(x, allDivideDrawingLineEnd), tinyDividePaint);
      //endregion
    }
    //endregion
    //region 绘制竖尺
    for (
    double currentLocalValue10000 = 0;
    currentLocalValue10000 < usingPaperHeight10000;
    currentLocalValue10000 += tinyGridValue10000) {
      //region 坐标计算
      //当前世界坐标上的值为
      var currentWorldValue10000 = usingPaperTop10000 + currentLocalValue10000;
      //当前坐落在坐标上的下一个本地坐标点为:
      var currentStepWorldValue10000 = (currentWorldValue10000 -
          subDivideYOffset10000) + tinyGridValue10000;
      //当前坐落在坐标上的下一个本地坐标点的像素值为:
      var y = currentStepWorldValue10000 / tinyGridValue10000 *
          perTinyStepPixels10000;
      var a = usingPaperTop10000 / tinyGridValue10000 * perTinyStepPixels10000;
      var f = y - a;
      //上面三行加上下面这一行具体咋回事我也不知道了.一点一点瞎猫碰死耗子测试出来的反正显示是正确的.
      y = f / 10000;
      //endregion
      //region 检查长的,如果当前的数值匹配到长的,就画长的.最长的那个上要画出来数字文字
      //如果匹配到了最长的,别的就不画了
      if (currentStepWorldValue10000.toInt() % subDivideLongest10000.toInt() == 0) {
        canvas.drawLine(Offset(maxDivideDrawingLineStart, y), Offset(allDivideDrawingLineEnd, y), maxDividePaint);
        // print(currentValue10000);
        var currentStepString = (currentStepWorldValue10000 / 10000).toStringAsFixed(
            2).replaceAll('.00', '');
        var fill = TextPainter(
          text: TextSpan(
            text: currentStepString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
          fill.layout();
        canvas.save();
        var offset = Offset(allDivideDrawingLineEnd, y);
        final pivot = fill.size.topLeft(offset);
        canvas.translate(pivot.dx + fill.size.height, pivot.dy+ verticalTextGap);
        canvas.rotate(pi/2);
        canvas.translate(-pivot.dx, -pivot.dy);
        fill.paint(canvas, offset);
        canvas.restore();


        continue;
      }
      //endregion
      //region 如果匹配到了中等长度的,别的就不画了.
      if (currentStepWorldValue10000 % subDivideMid10000 == 0) {
        canvas.drawLine(Offset(midDivideDrawingLineStart, y), Offset(allDivideDrawingLineEnd, y), midDividePaint);
        continue;
      }
      //endregion
      //region 四个规格中的第二短的如果存在并且match到了.绘制
      if (subDivideSmall10000 != null &&
          currentStepWorldValue10000 % subDivideSmall10000 == 0) {
        canvas.drawLine(Offset(smallDivideDrawingLineStart, y), Offset(allDivideDrawingLineEnd, y), smallDividePaint);
        continue;
      }
      //endregion
      //region 绘制最短的
      canvas.drawLine(Offset(tinyDivideDrawingLineStart, y), Offset(allDivideDrawingLineEnd, y), tinyDividePaint);
      //endregion
    }
    //endregion
  }
}