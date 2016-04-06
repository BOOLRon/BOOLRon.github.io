---
layout: post
title: "从Objective-C转移到Swift需要注意的地方"
date: 2014-09-02 20:41:46 +0800
comments: true
categories: 
---
我想通过这文章分享一下我从Objective-C转移到Swift过程中的一些想法。我会给你一些提示并讨论相关的陷阱，尽可能去比较两种语言的方法有何不同。废话不多说，马上开始！

### xxx.swift VS xxx.h&xxx.m

第一个要注意的大变化是，Swift不采用interface.h/implementation.m的结构。其实我是非常支持把需要共享的信息放头文件的，这样很安全。而Swift，不再分开头文件与实现文件了，只需要实现我们的class。

自从Xcode6 beta4开始，Swift加入了三个访问权限控制修饰词：

*  private 只能被相同源文件下被访问
*  internal 只能被当前target下的文件访问
*  public 可以被属于当前target的module下的所有文件访问


三个中internal是默认的，另外对属性加修饰词可以设置只对set方法成效，例如：
```swift
	// 这样对于其他文件是只读不可写了
	private(set) var UUID: NSUUID
```	
	
而当你需要重载声明了public修饰词的方法时，你也必须要加public的:
```swift
	public override func isEqual(object: AnyObject?) -> Bool{
		if let item = object as? ListItem {
			return self.UUID == item.UUID
		}	
	}
```
### 常量与变量
在写Objective-C时，我知道有些数据不应该被改变也是比较少用**const**的（请不要耻笑我）。而在Swift，苹果建议开发者更多去思考，能用常量(**let**)，就少用变量(**var**)。这样你只需要专注于如何使你定义的变量发挥作用。


### 只写需要的代码
举个栗子：
```swift	
	let wsURL:NSURL = NSURL(string:"http://wsurl.com");
	<!---->
	let wsURL = NSURL(string:"http://wsurl.com") 
```	
	
经过两周训练写Swift，我强迫自己去掉每行代码的分号。最后我感觉整个人都舒服了，然后我经常写Objective-C漏掉了分号，呵呵。

**Type inference**是指通过赋值时的声明来推断出实例的类型，这种方便的写法使得习惯了冗长派语言（如Objective-C）的我有点措手不及。

另一种情况是在if里买不一定需要括号：
```swift
	if (a > b) {}
	<!---->
	if a > b {}
```	
	
以上是一样的，另外如果你要在if里面赋值是不能加括号的：
```swift
	if (let x = data){} //Error!
	if let x = data{}  //OK!
```

### Optionals
很多时候函数返回的会是**值**或者**空**，而你会用什么方案来返回这个**空**呢？我会使用**NSNotFound**,**-1**,**0**或**nil**。得益于Optionals，现在**空**有了官方的完整定义，我们只需在数据类型后加问号就行了。

例如：

```swift
	class Car{
	    func accelerate(){
	        print("accelerate")
	    }
	}	
	class Person{
	    let name:String
	    let car:Car? // Optional value
	    init(name:String){
	        self.name = name
	    }
	}
	// ACCESSING THE OPTIONAL VALUE ***********
	var Mark = Person(name:"mark")
	// use optional binding
	if let car = Mark.car {
	    car.accelerate()
	}
	// unwrap the value
	Mark.car?.accelerate()
```
在这个例子中，Person有Car被定义成一个Optional。这意味着属性car可以为空，然后我们可以通过Optional binding(if let car =)或者unwrap(car?)来访问到里面的值。
如果我们定义某属性不为Optional，那么我们必须要设一个值给它，否则编译器就会不高兴了。我们需要决定好class的属性怎样与其它class相互调用，Optional完全改变了我们构思class的方式。

### Optionals Unwrapping
当你发现Optional很难用时，那是因为你对它还不够了解...
```swift	
	Mark.car?
```
建议你把Optional想象成一个封起来的盒子，当你不肯定里面有没有值时，可以在Optional后面加**?**就代表解封，你即可看到里面的值或者是一个空盒子。而你敢肯定里面绝对有值时，可以在后面加**!**就可以直接获取到值了，但这有个风险，程序运行发现跟你断言的不一样就会马上闪退。

### Delegate模式
写了多年的Objective-C，我们都已习惯了这种模式，下面用Swift实现一个简单的delegate:

```swift
	@objc protocol DataReaderDelegate{
	    @optional func DataWillRead()
	    func DataDidRead()
	}
	class DataReader: NSObject {
	    var delegate:DataReaderDelegate?
	    var data:NSData?
	    func buildData(){
	        delegate?.DataWillRead?() // Optional method check
	        data = _createData()
	        delegate?.DataDidRead()       // Required method check
	    }
	}
```	
以往我们需要用**respondToSelector**来判断对象是否响应这个方法(真心觉得太烦了)，现在有了Optional就可以简化成：
```swift
	delegate?.DataWillRead?()
```
然后就是在另外的class上实现delegate了：
```swift
	class ViewController: UIViewController, DataReaderDelegate {                     
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        let reader = DataReader()
	        reader.delegate = self
	    }
	    func DataWillRead() {...}
	    func DataDidRead() {...}
	}
```
### Target-Action模式
另一种常用模式是target-action模式，你会发现写法跟Objective-C差别不大：
```swift
	class ViewController: UIViewController {  
	    @IBOutlet var button:UIButton
	    override func viewDidLoad() {
	        super.viewDidLoad()
    	    button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
	    }
    	func buttonPressed(sender:UIButton){...}
	}
```
最大不同在于selector的定义。我们可以直接写用String写成:
```swift
	Selector("buttonPressed:") 
```
### 单例模式
无论你喜不喜欢，单例模式仍然是最常用开发设计模式之一。除了结合GDC和dispatch_once来实现之外，我们还可以使用线程安全的**let**实现。
	
	class DataReader: NSObject {
	    class var sharedReader:DataReader {
	        struct Static{
	            static let _instance = DataReader()
	        }
	        return Static._instance
	    }
	...
	}
	
分析一下

1.我们ShareReader可看成包装起来的静态属性；
2.而真正的静态属性我用struct来封起来不允许别的class修改；
3._instance是一个常量，它不能被修改成别的值。

使用：

	DataReader.sharedReader
	
	
自从Xcode6 beta4加入了访问修饰词，我们现在可以简单的写成：
```swift
	private let _instance = DataReader()
	class DataReader {
	    class var sharedReader:DataReader {
	        return _instance
	    }
	}
```	
### 结构体与枚举
Swift的结构体与枚举有很多强大特性你是在别的语言找不到的。

它们支持写方法：
```swift
	struct User{
	    // Struct properties
	    let name:String
	    let ID:Int
	    // Method!!!
	    func sayHello(){
	        println("I'm " + self.name + " my ID is: \(self.ID)")
	    }
	}
	let pamela = User(name: "Pamela", ID: 123456)
	pamela.sayHello()
```	
可以见到Swift对结构体有默认的initializer。而枚举的语法有很大不同是用了**case**:
```swift
	enum Fruit { 
	  case orange
	  case apple
	}
```
不再限制与整数：
```swift
	enum Fruit:String { 
	  case .orange = "Orange"
	  case .apple = "Apple"
	}
```	
甚至可以给它定义更多行为：
```swift
	enum Fruit{
	    // Available Fruits
	    case orange
	    case apple
	    // Nested type
	    struct Vitamin{
	        var name:String
	    }
	    // Compound property
	    var mainVitamin:Vitamin {
		    switch self{
			    case .orange:
		        return Vitamin(name: "C")
		    case .apple:
		        return Vitamin(name: "B")
    	}
	    }
	} 
	let Apple = Fruit.apple
	var Vitamin = Apple.mainVitamin
```
这段代码我们加了一个内嵌类型(Vitamin)和一个compound property(mainVitamin)，这样不同的枚举值出来的mainVitamin就不一样了，这功能真赞！

### Blocks VS Closures
我非常喜欢blocks，一些简单的delegate我都爱用blocks来替代，它灵活、快速、安全。而在Swift里是用Closures来代替Blocks的。它再续了Blocks的优点，简化了语法，令我爱不惜手。
以下是官方用Closures实现reversed的例子：
```swift
	reversed = sort(names, { (s1: String, s2: String) -> Bool in
	    return s1 > s2
	})
```	
简化成：
```swift
	reversed = sort(names, >) 
```	
这里我就不详解Closure的语法了，我来说说Closure的**capture values**。在Objective-C我们需要给变量加**__block**才能在block里面修改该外部变量。而用Closure，这不需要，我们能在Closures里访问和修改外部作用域的变量。另外，如果Closure里引用的实例包含或使用了Closure本身，这就会引起**循环引用**:
```swift
	class Person{
	    var age:Int = 0
	    @lazy var agePotion: (Int) -> Void = {
        (agex:Int)->Void in
	            self.age += agex
	    }
	    func modifyAge(agex:Int, modifier:(Int)->Void){
	        modifier(agex)
	    }   
	}
	var Mark:Person? = Person()
	Mark!.modifyAge(50, Mark!.agePotion)
	Mark = nil // Memory Leak
```	
看到agePotion里用了self，**循环引用**就发生了，要避免这问题，我们可以用**Capture List**，这会时分配进Closure的实例是weak或者unowned的，写法也很简单，只需在Closure的定义前加上**[unownded self]**，就可以得到一个unowned或者weak的self了。
```swift
	@lazy var agePotion: (Int) -> Void = {
	     [unowned self](agex:Int)->Void in
	         self.age += agex
	}
```	
### Unowned & Weak Reference
我们知道**weak Reference**在Objective-C的使用，在Swift上也是一样的。那么**unowned reference**又是什么呢？我就举个例子来解析吧。

我来描述一下一个人与他的银行账号的关系：

1.一个人可以有一个银行账号(optional)

2.一个银行账号必须有拥有者(required)
```swift
	//We can describe this relation with code: 
	class Person{
	    let name:String
	    let account:BankAccount!
	    init(name:String){
	        self.name = name
	        self.account = BankAccount(owner: self)
	    }
	}
	class BankAccount{
	    let owner:Person
	    init(owner:Person){
	        self.owner = owner
	    }
	}
```
这就生成了一个引用循环。一种解决方案是对BankAccount.owner属性添加weak reference。你也可以使用unowned reference，但这个属性就必须要非空了。总结就是**unowned**就只是比**weak**多了一个非空限制而已，其他一样的。

### 最后
在写Swift的过程中，越来越发现一些有趣的特性，这令我更想多写Swift，期待正式版Xcode 6。