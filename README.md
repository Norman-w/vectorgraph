# vectorgraph

以矢量图为中心的图形库和工具

## 为什么要做这个
之前搜索在flutter中显示xmind的组件没有找到.

之前绘制泳道图觉得现有的软件满足不了自己的需求(虽然并不复杂)

之前有过想法是做那种带动画的UML图,但是没有找到合适的工具.

想做一个可以给客户展示项目时,类似PPT的工具,但是又不是PPT.可以一个端来进行手势等操作,另外一个端(屏幕)展示效果

想做一个可视化的数据生成器,类似DSP连线图那种感觉的,从二进制开始产生数据,然后通过视图展示出来过程

想做一个可视化调试器,通过程序内置的组件向外输送数据,然后用调试器展示逻辑的变化等,比如一个函数的输入输出,或者一个类的属性变化,一个事件被触发等,传入了哪些内容,输出了哪些内容,然后通过视图展示出来过程

前一阵分公司有项目关于矢量图绘制的,之前做过一些矢量图的绘制编辑等但是不全面,没有涉及到曲线和复杂图形,所以就想着自己做一个.


基于这些想法,就有了这个项目.这些想法的核心都是需要一些矢量相关的操作,比如视图的缩放,内容的拖拽,编辑,关系管理等.

## 为什么要用flutter
因为在学习flutter


## 分支
当前对未来的规划是,先做一个基础的矢量图绘制编辑器,然后再做一些其他的功能.
比如矢量图编辑差不多了以后,会开一个分支做xmind,再开别的分支做其他的功能.就不单独立项做别的软件了.


## 参考资料
在线编辑svg的工具,支持css和js的
https://c.runoob.com/codedemo/3634/


svg的基本教程
https://www.runoob.com/svg/svg-polygon.html

在线预览svg代码的工具,轻量版 https://www.bejson.com/ui/svg_editor/
示例代码
`<?xml version="1.0" standalone="no"?>
<svg width="325px" height="325px" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <path d="M100 100 A 100 50, 0, 1, 1, 200 150" fill="blue"/>
  <path d="M100 100 A 100 50, 0, 0, 1, 200 150" fill="red"/>
  <path d="M100 100 A 100 50, 0, 1, 0, 200 150" fill="orange"/>
  <path d="M100 100 A 100 50, 0, 0, 0, 200 150" fill="green"/>
  <line x1="100" y1="0" x2="100" y2="200"
  style="stroke:rgb(255,0,0);stroke-width:2"/>
  <line x1="0" y1="100" x2="300" y2="100"
  style="stroke:rgb(255,0,0);stroke-width:2"/>
  <line x1="200" y1="0" x2="200" y2="200"
  style="stroke:rgb(255,0,0);stroke-width:2"/>
</svg>`

根据SVG Arc求出其开始角、摆动角和椭圆圆心,目前没参考上 https://www.cnblogs.com/ryzen/p/15832672.html


SVG路径中圆弧的语法和计算逻辑文章 https://www.cnblogs.com/igin/p/16919891.html

上面链接中引用的官方SVG圆弧计算逻辑文章 https://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes

之前参考的C#代码写圆弧 https://www.cnblogs.com/ryzen/p/15832672.html (这个链接和w3的链接都是copilot的结果,他竟然都答对了.监控我?啊~ 是因为上面记录过参考信息了.注:此链接内的内容有错误,自己对照w3的公式重写后获取圆心正确了)

一个react编写的数数学工具,可视化做的还可以,没有弧线 https://mafs.dev/guides/examples/bezier-curves

## 当前进度
2023年03月28日:正在做曲线(Arc)的绘制
