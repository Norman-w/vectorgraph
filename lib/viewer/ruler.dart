/// 在视口上有标尺,可以根据用户选择是否开启


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
    //1
    Map<double, List<double>> allDrawDivideList = {
      0.1: [0.005, 0.01, 0.05, 0.1],
      0.2: [0.001, 0.02, 0.1],
      0.5: [0.002, 0.05, 0.2],
      0.8: [0.005, 0.01, 0.5],
      0.9:[0.01,0.02,0.05,0.1],
      1: [0.02, 0.1, 0.2, 0.5],
      2: [0.05, 0.1, 0.5, 1],
      5: [0.1,0.25, 0.5, 1],
      10: [0.2,0.5, 1, 2],
      25: [0.5,1, 2.5, 5],
      50: [1,2.5, 5, 10],
      100: [2.5, 12.5, 25],
      250: [5, 25, 50],
      500: [10, 50, 100],
      1000: [25, 125, 250],
      2500: [50, 250, 500],
      5000: [100, 500, 1000],
      5002: [250, 125, 2500],
      5003: [500, 250, 5000],
      10000: [1000, 5000, 10000],
      25000: [2500, 12500, 25000],
      50000: [5000, 25000, 50000],
      100000: [10000, 50000, 100000],
      250000: [25000, 125000, 250000],
      500000: [50000, 250000, 1000000],
    };
    //3
    var viewRect = Rect.fromLTWH(0, 0, size.width, size.height);
    //4
    double minPixelsPerTinyGrid10000 = 10 * 10000;
    //5
    //6
    //7
    //一个小格代表多长
    double tinyGridValue10000 = 0;
    //一个最大格代表多长
    double bigGridValue10000 = 0;
    //要展示的区域要被分成分多少段
    int divideCount = 0;
    //每一段的像素步长
    double perTinyStepPixels10000 = 0;
    var currentUsingLevel = 0;
    List<double> subDivideList = [];
    for(var level in allDrawDivideList.keys){
      currentUsingLevel ++;
      tinyGridValue10000 = allDrawDivideList[level]![0]* 10000;
      bigGridValue10000 = allDrawDivideList[level]![allDrawDivideList[level]!.length-1]*10000;
      // print('tinyGridValue:$tinyGridValue');
      divideCount = usingPaperRect.width*10000 ~/ tinyGridValue10000;
      perTinyStepPixels10000 = viewRect.width * 10000 / divideCount;
      if(perTinyStepPixels10000>minPixelsPerTinyGrid10000)
        {
          subDivideList = allDrawDivideList[level]!;
          break;
        }
    }
    if(perTinyStepPixels10000<minPixelsPerTinyGrid10000) {
      return;
    }
    var usingPaperLeft10000 = usingPaperRect.left *10000;
    //最小段的偏移量
    double subDivideOffset10000 = (usingPaperLeft10000 % (tinyGridValue10000));
    //8
    var maxDividePaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 5;
    var subDividesStart = subDivideList.length-1;
    var subDivideLongest10000 = subDivideList[subDividesStart]*10000;
    var subDivideMid10000 = subDivideList[subDividesStart-1]*10000;
    double? subDivideSmall10000 = subDivideList.length == 4 ?subDivideList[1]*10000 : null;
    double usingPaperWidth10000 = usingPaperRect.width * 10000;
    print(currentUsingLevel);
    print(perTinyStepPixels10000);
    //从0开始,绘制到要展示的纸张的最宽位置,每次步进最小格的值
    for(
    double currentLocalValue10000=0;
    currentLocalValue10000<usingPaperWidth10000;
    currentLocalValue10000+=tinyGridValue10000){
      //当前世界坐标上的值为
      var currentWorldValue10000 = usingPaperLeft10000 + currentLocalValue10000;
      //当前坐落在坐标上的下一个点为:
      var currentStepValue10000 = (currentWorldValue10000 - subDivideOffset10000) + tinyGridValue10000;
      if(subDivideOffset10000/10000 == 0){
        currentStepValue10000 += subDivideOffset10000;
      }
      // print(subDivideOffset10000/10000);
      var x = currentStepValue10000 / tinyGridValue10000 * perTinyStepPixels10000;
      var a = usingPaperLeft10000 / tinyGridValue10000 * perTinyStepPixels10000;
      var f = x -a;
      x = f / 10000;
      //检查长的,如果当前的数值匹配到长的,就画长的.最长的那个上要画出来数字文字
      // for(var j=subDividesStart;j>0;j--){
      //如果匹配到了最长的,别的就不画了
      // print("s1: $t1, s2:$t2");
        if(currentStepValue10000.toInt()%subDivideLongest10000.toInt() ==0){
          canvas.drawLine(Offset(x, 0), Offset(x, 40), maxDividePaint);
          // print(currentValue10000);
          var currentStepString = (currentStepValue10000/10000).toStringAsFixed(2);
          TextPainter(
            text: TextSpan(
              text: currentStepString,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
            ),
            textDirection: TextDirection.ltr,
          )
            ..layout()
            ..paint(canvas, Offset(x, 40));
          continue;
        }
        //如果匹配到了中等长度的,别的就不画了.
        if(currentStepValue10000%subDivideMid10000 == 0){
          canvas.drawLine(Offset(x, 0), Offset(x, 24), maxDividePaint);
          continue;
        }
      // }
      //四个规格中的第二短的如果存在并且match到了.绘制
      if(subDivideSmall10000!= null && currentStepValue10000%subDivideSmall10000 == 0){
        canvas.drawLine(Offset(x, 0), Offset(x, 16), maxDividePaint);
        continue;
      }
      canvas.drawLine(Offset(x, 0), Offset(x, 8), maxDividePaint);



      // TextPainter(
      //   text: TextSpan(
      //     text: '$currentStepString',
      //     style: TextStyle(
      //       color: Colors.red,
      //       fontSize: 10,
      //     ),
      //   ),
      //   textDirection: TextDirection.ltr,
      // )
      //   ..layout()
      //   ..paint(canvas, Offset(x, 40));
      
    }

    //draw vertical long lines and numbers start with 0 from left
    // for(double i=rect.left;i<rect.width;i+=10){
    //   double x = (i-rect.left)*stepX;
    //   canvas.drawLine(Offset(x, 0), Offset(x, longLineLength), longLinePaint);
    //   TextPainter(
    //     text: TextSpan(
    //       text: '${i ~/ 2}',
    //       style: TextStyle(
    //         color: color,
    //         fontSize: 10,
    //       ),
    //     ),
    //     textDirection: TextDirection.ltr,
    //   )
    //     ..layout()
    //     ..paint(canvas, Offset(x, longLineLength));
    // }
  }
}