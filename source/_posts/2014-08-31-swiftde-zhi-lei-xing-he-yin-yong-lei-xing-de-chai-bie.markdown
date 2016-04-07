---
layout: post
title: "Swift的值类型和引用类型的差别"
date: 2014-08-31 19:49:25 +0800
comments: true
categories: Swift
---
Swift的值分两种类型：值类型和引用类型。前者的实例保存着数据相同且各自独立的副本，像struct、enum和tuple这些；而后者的实例保存同一份数据，如class。这文章我们来挖掘这两种类型各自的优点以及思考开发中要如何选用

### 有何不同
值类型的最大特点是复制，无论是初始化还是传值，它都会复制出另一个相同数据的对象出来：

```swift
// Value type example
struct S { var data: Int = -1 }
	var a = S()
	var b = a						// a is copied to b
	a.data = 42						// Changes a, not b
	println("\(a.data), \(b.data)")	// prints "42, -1"
```
	
而引用类型的赋值，则会新建另一个对象，并指向相同的共享数据地址:
```swift
// Reference type example
class C { var data: Int = -1 }
var x = C()
var y = x						// x is copied to y
x.data = 42						// changes the instance referred to by x (and y)
println("\(x.data), \(y.data)")	// prints "42, 42"
```	

### 保证数据突变的安全性
这是选择值类型的其中一个原因。当你获取到唯一的实例对象时，妈妈再也不用再担心你的数据在背后被偷偷修改了。尤其是在多线程环境，有可能某线程背着你改了数据而出现些难以debug的问题。

按道理这个不同点会发生在你改变数据那一刻，所以有一种情况下值类型和引用类型是一样的————对象无法写入时。

你可能会想当class为完全不可变时也会有这优点，这样我们可以简单地使用熟悉的Cocoa NSObject对象同时享有值类型的优点。现在，你可以用Swift通过immutable properties来写出immutable class，事实上，很多常用Cocoa class如NSURL都已被设计成immutable class。但是要注意，这种immutable class不是值类型。

### 如何选用
当你想新建一种类型，你如果选择用值类型还是引用类型呢？如果想你的类型和Cocoa有更有的相容性建议用class，其他情况可以参考如下几条指引：

使用值类型：

*   使用 == 来比较数据是否一致
*   你希望对象有独立状态
*   数据将会被多线程使用

使用引用类型：

*   使用 === 来比较对象一致
*   你希望对象的数据是共享的、可变的


在Swift的世界，Array、String和Dictionary都是值类型，他们就像C语言的int类型，保持着相对独立的数据，你不需要显式声明copy来避免数据被偷偷修改，更重要的是你可以安全地线程间传值而不需要synchronization。得益与这一特性，这可以助你用Swift写出更安全可控的代码。