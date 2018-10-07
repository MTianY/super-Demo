# README

有这么个面试题: 

看如下代码,打印结果是什么?

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    id cls = [TYPerson class];
    
    void *obj = &cls;
    
    [(__bridge id)obj log];
}
```

这段代码的前提是有这么一个类: `TYPerson`

```objc
// TYPerson.h
@interface TYPerson : NSObject

@property (nonatomic, copy) NSString *name;

- (void)log;

@end

// TYPerson.m
@implementation TYPerson

- (void)log {
    NSLog(@"My name is -%@",self.name);
}

@end
```

运行程序,看打印结果:

```c
superDemo[14423:913664] My name is -<ViewController: 0x7f8066e0ea50>
```

重新看`viewDidLoad`里的代码,应该会有几个疑问?

- `log 方法`, 明明是 TYPerson 里的方法,为什么上面没有通过 TYPerson 的实例对象去调用,就可以执行`log`方法呢?
- 为什么打印结果的`self.name`变成了`<ViewController: 0x7f8066e0ea50>`

带着这两个疑问,看下其如何实现的.

首先看一个比较熟悉的. 下面这么写应该都懂.

```objc
TYPerson *person = [[TYPerson alloc] init];
[person log];
``` 

- 这里左边的 `*person` 是指向的存储着 `TYPerson`对象的地址的`指针`.所以其指向的是`TYPerson 的实例对象`.
- 然后一个实例对象,其在内存中存放的有
    - isa 指针
    - 及其自己的成员变量.
    - 在这里就是 `isa` 和 `_name`.
- `isa` 指向的是 `[TYPerson class]`这个类对象.

这时分析 `viewDidLoad`里的代码:

- `id cls = [TYPerson class];`
    - `cls`  就是一个指向 `[TYPerson class]`内存地址的指针.
- `void *obj = &cls;`
    - 而 `*obj` 是指向 `cls` 地址的指针.

上面两个用图表示如下:

![](media/15389290782574/15389307640548.jpg)
 
从上图可以侧面说明, `obj` 为什么可以调用 `log` 方法.

- 因为`person` 指向的内存的前8个字节就是`isa`指针,然后通过`isa`去类对象中找方法,然后调用.
- 一样的结构, `obj`也是在指向的内存中取出前8个字节,就是`cls`.应该是和 isa 一样的,然后去找类对象中的方法,从而调用.


