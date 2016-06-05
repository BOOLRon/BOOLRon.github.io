---
layout: post
title: CoreAnimation Sumary
date: 2016-06-05 17:00:30
comments: true
categories: ios
---

# CoreAnimation 总结

转载自: 

---

### 关于CALayer

和UIView一样，CALayer也有一个树🌲

- 图层树：
    - Model tree：，设置layer属性的时候访问的就是这个
    - Presentation tree ：做动画的时候，出现在屏幕上每一帧的layer在这个tree上
    - Render tree：CoreAnimation私有并管理，是真正渲染动画的tree
    
- CALayer能力：
    - 不能处理交互事件
    - 用- (nullable CALayer *)hitTest:(CGPoint)p;来检测是layer否被点击
    
- CALayer的常用属性：

| 属性        | 说明  |
| --------   | -----: |
| anchorPoint| 范围(0,0)~(1,1),决定position的比例位置 |
| backgroundColor|背景颜色|
| borderColor|边框颜色|
| borderWidth|边框宽度|
| bounds|宽高|
| contents|显示的内容，可以是图片|
| contentsRect|显示Content的大小和位置,[0,0,0,0]~[1,1,1,1]|
|cornerRadius|圆角半径|
|doubleSided|是否显示图层背面,默认yes|
|frame|基本不用，不支持隐式动画|
|hidden|隐藏|
|mask|图层蒙版，可以提供形状|
|maskToBounds|是否剪掉subLayer超出边界的部分，默认No|
|opacity|类似alpha|
|position|类似UIView的Center|
|shadowColor|阴影颜色|
|shadowOffset|阴影偏移量,默认(0,3)|
|shadowOpacity|阴影透明度，取值[0,1]|
|shadowPath|阴影形状|
|shadowRadius|阴影模糊半径|
|subLayers|子图层|
|sublayerTransform|子图层的变换，CATransform3D类型|
|transform|transform变换，CATransform3D类型|
|shouldRasterize|解决组透明问题，图层与其自图层混合成一张图片|

> - 上面的属性，除了frame，都可以进行CALayer的`隐式动画`
> - 能进行动画的无论是显式还是隐式，在.h文件里面都会有`Animatable`说明

像这样：
![Animatable说明](http://7xii9w.com1.z0.glb.clouddn.com/1D1A0ED8-03C1-4DD7-8E67-E158F67483BE.png)

### CALayer的变换

- 仿射变换(CGAffineTransform)

> 无论怎么变换，原来平行的2条线变化之后仍然保持平行，就是仿射变换
> 主要用于二维空间的平移，缩放，旋转

常用的几个函数：

```objc
CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
CGAffineTransformMakeRotation(CGFloat angle)

CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
```

- 3D变换(CATransform3D)
常用的几个函数：

```objc
CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloat tz)
CATransform3DMakeScale (CGFloat sx, CGFloat sy, CGFloat sz)
CATransform3DMakeRotation (CGFloat angle, CGFloat x, CGFloat y, CGFloat z)

CATransform3DTranslate (CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz)
CATransform3DScale (CATransform3D t, CGFloat sx, CGFloat sy, CGFloat sz)
CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
```
- 透视和灭点:
透视效果通过设置`transform.m34`的值来进行简单控制
![transform.m34](http://7xii9w.com1.z0.glb.clouddn.com/517018F5-7C10-4B4B-899E-C548881AFF45.png)
m34默认为0，透视处理公式：`m34 = -1.0/d`，d取值一般为`[500,1000]`

>  - 为了让一屏的layey更有3D效果，通常所有layer的灭点都设置在屏幕中央。
>  - 然后调整m34的值，然后把layer transform到指定位置

### CoreAnimation 提供的专用Layer

- **CAShapeLayer**
    - 指定`CGPath`来创建形状，一般用`UIBezierPath`来指定
    - GPU渲染，快速
    - 占用内存少，不需像普通Layer要创建contents
    - 不会被图层边界剪裁掉
    - 不会出现像素化，差不多就是不需要设置scale的意思

- **CATextLayer**
    - 以Layer的形式包含了UILabel的几乎所有绘制特性
    - 可以用这个来适配iOS 5以及以下对富文本的支持

- **CATransformLayer**
    - 主要用于方便构造一个3D结构，如立方体
    - 解决`Core Animation的图层都存在于3D空间之内，但它们并不都存在同一个3D空间`造成的图层扁平化问题

- **CAGradientLayer**
    - 用于生成两种或者多种颜色平滑渐变效果
    - 使用的是GPU绘制

- **CAReplicatorLayer**
    - 用于高效生成许多重复的图层
    - 做Layer的反射，如倒影效果

- **CAScrollLayer**
    - 可以用UIScrollView来类比

- **CATiledLayer**
    - 高效绘制超大像素图片

- **CAEmitterLayer**
    - 创建粒子动画，如烟雾，火，雨等。
    - 它能实现粒子的很多随机属性

- **CAEAGLLayer**
    - OpenGL相关

- **AVPlayerLayer**
    - MPMoivePlayer的底层实现

选几个简单的效果演示一下：

- CAGradientLayer效果：

![CAGradientLayer效果](http://7xii9w.com1.z0.glb.clouddn.com/ckp_GradientLayer.png?imageMogr2/thumbnail/!50p)


- CAReplicatorLayer效果：

![CAReplicatorLayer效果1](http://7xii9w.com1.z0.glb.clouddn.com/CAReplickp_catorLayer_rotate.png?imageMogr2/thumbnail/!50p)


倒影效果：

![CAReplicatorLayer效果2](http://7xii9w.com1.z0.glb.clouddn.com/CAReplicatorLayer.png?imageMogr2/thumbnail/!50p)

- CAEmitterLayer效果：

![CAEmitterLayer效果](http://7xii9w.com1.z0.glb.clouddn.com/ckp_CAEmitterLayer.gif)

### 隐式动画(Implicit Animation)

> CALayer中任何注释有`Animatable`属性被改变的时候会从之前的值平滑过渡到新值，这种是默认行为，`隐式动画`差不多就这意思

- 事务(CATransaction)

    - 任何用指定事务去改变可以做动画的图层属性都不会立刻发生变化，而是当事务一旦提交的时候开始用一个动画过渡到新值
    - Core Animation在每个runloop周期中自动开始一次新的事务，任何在一次runloop循环中属性的改变都会被集中起来，然后做一次0.25秒的动画
    - 常用方法：

 ```objc
[CATransaction begin];
[CATransaction setAnimationDuration:1.0];
[CATransaction setDisableActions:YES];
[CATransaction setCompletionBlock:^{
	//...
}];
[CATransaction commit];
```

- 图层行为

    - 把改变属性时CALayer自动应用的动画称作`行为`
    - UIView禁用了它的layer的隐式动画

> **图层行为检测顺序：** 
1、是否实现CALayerDelegate的-actionForLayer:forKey方法
2、属性名称是否在actions字典中
3、属性名是否在style字典中
4、调用-defaultActionForKey:方法 若空则无动画 或 返回CAAction对象，然后根据属性过去和当前值做动画

- 呈现(presentation)与模型(model)

    - 通过`layer.presentationLayer`来访问当前屏幕真正显示出来的值
    - 想通过`-hitTest:`来检测动画中的layer，需要去访问presentationLayer
                                    
### 显式动画(Explicit Animation)

> `CABasicAnimation`与`CAKeyframeAnimation`都继承自  `CAPropertyAnimation`，这两种就是所谓的`属性动画`

- **CABasicAnimation**
    
    - 一般用法

    ```objc
    CABasicAnimation *fade = [CABasicAnimation new];
    fade.keyPath = @"opacity";
    fade.fromValue = @(1);
    fade.toValue = @0;
    fade.duration = 0.5;
    [layer addAnimation:ani forKey:nil];
    ```
    - 这个和隐式动画，其实差不多，但写多了很多代码
    

- **CAKeyframeAnimation**

    - 一般用法
    
    ```objc
    CAKeyframeAnimation *x = [CAKeyframeAnimation new];
    x.keyPath = @"transform.translation.x";
    x.values = @[@(-15),@(15),@(-15),@(15)];
    x.duration = 0.5;
    x.additive = YES;
    ```
    - 可以用CGPath指定曲线运动路径
    
    ```objc
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addCurveToPoint:CGPointMake(300, 0) controlPoint1:CGPointMake(0, 100) controlPoint2:CGPointMake(0, 50)];
    
    CAKeyframeAnimation *po = [CAKeyframeAnimation new];
    po.keyPath = @"position";
    po.duration = 0.5;
    po.additive = YES;
    po.path = path.CGPath;
    po.rotationMode = kCAAnimationRotateAutoReverse;
    ```
    
- **一些常用设置**

    - 在delegate中判断不同的动画：
    
    ```objc
        //假设有move的动画与fade的动画
        //利用kvc给Animation设置值
        
        static NSString *const kAnimKVCKey = @"kvcKey";
        static NSString *const kFadeAnimKey = @"fade";
        static NSString *const kMoveAnimKey = @"move";
        
        [moveAnim setValue:kMoveAnimKey forKey:kAnimKVCKey];
        [fadeAnim setValue:kFadeAnimKey forKey:kAnimKVCKey];
    
        //在delegate中判断
        - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
            if ([[anim valueForKey:kAnimKVCKey] isEqualToString:kMoveAnimKey]) {
                //连击动画
            }
        
            if ([[anim valueForKey:kAnimKVCKey] isEqualToString:kFadeAnimKey]) {
                //隐藏动画
            }
        }
    
    ```


    - 设置动画做完后不恢复到原来状态：

    ```objc
    //如刚才的fade动画，做完动画之后不想让它回到初始的状态
    fadeAnim.removedOnCompletion = NO;
    fadeAnim.fillMode = kCAFillModeForwards;
    
    //注意要把layer设置到动画之后想要的状态，如本来不隐藏，后面要隐藏
    layer.opacity = 0;
    [layer addAnimation:fadeAnim forKey:kFadeAnimKey]；
    
    //然后在动画结束的delegate回调里面设置
    //设置了removedOnCompletion之后，动画不会自动移除
    [layer removeAnimationForKey:kFadeAnimKey];
    
    ```


    - 取消动画：
    
    ```objc
     - (void)removeAnimationForKey:(NSString *)key
     - (void)removeAllAnimations

    ```
    

>  动画一旦被移除，图层的外观就立刻更新到当前的modelLayer的值


- **动画组**

    - 使用方法
    
    ```objc
    //x
    CAKeyframeAnimation *x = [CAKeyframeAnimation new];
    x.keyPath = @"transform.translation.x";
    x.values = @[@(-15),@(15),@(-15),@(15)];
    x.duration = 0.25;
    x.additive = YES;
    
    //y
    CAKeyframeAnimation *y = [CAKeyframeAnimation new];
    y.keyPath = @"transform.translation.y";
    y.values = @[@(0),@(-100),@(-150),@(-200)];
    y.duration = 0.25;
    y.additive = YES;
    
    //组
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ x,y ];
    group.duration = 0.25;
    
    [layer addAnimation:group forKey:nil];
    ```

- **如何设置Animation的keyPath**

> -  `keyPath`一般是CALayer及其子类中`Animatable`的属性名称

> - `CAKeyframeAnimation`的values,`CABasicAnimation`中的fromValue与toValue的设置可以[在官方文档找到](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html#//apple_ref/doc/uid/TP40004514-CH12-SW3)，keyPath的值设置也可以在这里找到

- **过渡(CATransition)**

    - 当设置了CALayer的`contents`属性的时候，CATransition是默认的行为，这种称为`隐式过渡`

    - 对图层树的动画：要对图层树中某一个不确定图层做过渡，最好将Transition加到superLayer上，防止Transition与Layer一起被移除。如UITabBarController给切换controller的时候添加过渡动画，应该给tabbarcontroller.view.layer 添加Transition

    - 一般用法：

    ```objc

    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [layer addAnimation:transition forKey:nil];

    ```

> 属性动画只对图层的`Animatable属性`起作用，所以如果要改变一个不能动画的属性（比如图片），或者从层级关系中添加或者移除图层，属性动画将不起作用。这样用CATransition是不错的选择。


- **动画缓冲(CAMediaTimingFunction)**

    - Core Animation使用缓冲来使动画移动更平滑更自然，描述不同时间动画中的不同进行速度，TimingFunction曲线的斜率代表速率

    - 几种系统提供的属性：

    ```objc
    kCAMediaTimingFunctionLinear
    kCAMediaTimingFunctionEaseIn
    kCAMediaTimingFunctionEaseOut
    kCAMediaTimingFunctionEaseInEaseOut
    kCAMediaTimingFunctionDefault

    ```


    - 以过渡动画做示例：

    ```objc
    CATransition *transition = [CATransition animation];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    transition.type = kCATransitionFade;
    [layer addAnimation:transition forKey:nil];

    ```

    - CAKeyframeAnimation有一个NSArray类型的`timingFunctions`属性，可以用它来对每次动画的步骤指定不同的`TimingFunction`，但是指定函数的个数一定要等于`values`数组的元素个数减一，它是描述的是每一帧之间动画速度的函数

    - 自定义TimingFunction：

    ```objc
    //一条点在[(0,0), c1, c2, (1,1)]Bezier曲线
    [CAMediaTimingFunction functionWithControlPoints: 0.000 : 0.722 : 0.951 : 0.167];
    ```
    
> 推荐使用`CATweakerSense`插件来方便使用自定义的TimingFunction，效果如下

![CATweakerSense效果](http://7xii9w.com1.z0.glb.clouddn.com/ckp_TimingFunction.png)

- **基于定时器动画**

    - 用CADisplayLink做定时器，由硬件`垂直同步信号(vsync)`触发，每秒60次。
    - 把动画一秒分为60帧，把每一帧layer的状态计算好，然后每次触发CADisplayLink的时候改变layer的状态
    - 利用缓冲函数来计算Layer每一帧的状态，可以[在这里找到](http://robertpenner.com/easing/)很多缓冲函数
    
    
    
### 性能优化

**运行动画的过程**：

1、布局：设置layer各种属性(CPU阶段)
2、显示：contents被绘制的阶段(CPU阶段)
3、准备：CoreAnimation准备提交到系统渲染服务阶段(CPU阶段)
4、提交：提交到系统渲染服务进行渲染(CPU阶段)

5、OpenGL计算layer属性，并设置(GPU阶段)
6、屏幕上渲染(CPU阶段)

**会降低GPU绘制的事情**：

1、太多图层
2、重绘：由重叠的半透明图层引起
3、离屏渲染：主要由cornerRadius,mask,shadow相关属性，shouldRasterize强制CoreAnimation提前渲染图层的离屏渲染引起
4、过大的图片

**以下CPU操作会延迟动画开始时间**：

1、布局：View层级过于复杂、autolayout都会消耗CPU
2、View的懒加载：在Controller的View在Appear之前，繁重的CPU工作会导致加载过慢，如读取数据
3、Core Graphic绘制：实现了-drawRect:之类的方法等


**使用Instruments工具调优**：

**Core Animation工具**：

1、Color Blended Layers：绿到红的高亮，标识半透明混合图层
2、ColorHitsGreenandMissesRed：多用于检测shouldRasterize有没有生效
3、Color Copied Images：被CoreAnimation强制生成了一些图片（蓝色）
4、Color Misaligned Images：高亮没有被正确缩放或拉伸的图片
5、Color Offscreen-Rendered Yellow：黄色高亮，可能要用`shadowPath`或者`shouldRasterize`来优化

**OpenGL ES驱动工具**：

> 测量GPU的利用率，判断和GPU相关动画性能

1、Renderer Utilization：如果这个值超过了50%，意味着你的动画可能对帧率有所限制，很可能因为离屏渲染或者是重绘导致的
2、Tiler Utilization：如果这个值超过了50%，就意味着在屏幕上有太多的图层

### 其他相关

> 暂时没使用或学习过

- iOS9才有的`CASpringAnimation`
- `UIDynamic`是一个是一种物理引擎，能模拟和仿真现实生活中的物理现象，如：重力、弹性碰撞等现象


### 参考

- [官方文档](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514-CH1-SW1)
- [官方文档翻译电子书](http://7xii9w.com1.z0.glb.clouddn.com/ckp_CoreAnimation.epub)

> 2016-06-01 [Cooper](http://ckp1992.github.io/2016/06/01/CoreAnimation%E6%80%BB%E7%BB%93/)

