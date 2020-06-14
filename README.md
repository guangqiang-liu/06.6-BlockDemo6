# 06.6-block的循环引用

我们新建一个工程，然后新建`Person`类，在`main`函数中编写如下测试代码：

`Person`类

```
typedef void(^MyBlock)(void);

@interface Person : NSObject

@property (nonatomic, assign) int age;

@property (nonatomic, copy) MyBlock block;
@end


@implementation Person

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
```

`main`函数

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Person *person = [[Person alloc] init];
        person.age = 10;
        
        person.block = ^{
            NSLog(@"%d",person.age);
        };
        
        person.block();
    }
    
    NSLog(@"222");
    return 0;
}
```

运行程序发现`person`对象没有正常释放，产生循环引用，示例图如下：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200206-143750@2x.png)

那么如何解决block的循环引用问题尼，我们可以使用下面两个关键字：

* __weak
* __unsafe_unretained

我们先来使用`__weak`解决循环引用，代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [[Person alloc] init];
        person.age = 10;
        
        __weak typeof(Person) *weakPerson = person;

        person.block = ^{
            // 在block内部再使用__strong，这样防止在block内部使用`person`对象时，`person`对象提前销毁
            __strong typeof(Person) *strongPreson = weakPerson;
            
            NSLog(@"%d",strongPreson.age);
        };
        
        person.block();
    }
    
    NSLog(@"222");
    return 0;
}
```

引用关系如图所示：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200206-144243@2x.png)

我们先来使用`__unsafe_unretained`解决循环引用，代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [[Person alloc] init];
        person.age = 10;
        
        __unsafe_unretained typeof(Person) *weakPerson = person;

        person.block = ^{
            // 在block内部再使用__strong，这样防止在block内部使用`person`对象时，`person`对象提前销毁
            __strong typeof(Person) *strongPreson = weakPerson;
            
            NSLog(@"%d",strongPreson.age);
        };
        
        person.block();
    }
    
    NSLog(@"222");
    return 0;
}
```

引用关系如图所示：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200206-144733@2x.png)


既然`__weak`和`__unsafe_unretained`都能解决循环引用，那它们有什么不同?

> `__weak`：当指针指向的对象销毁时，使用`__weak`修饰的指针的内存地址值会自动赋值为`nil`

> `__unsafe_unretained`：当指针指向的对象销毁时，使用`__unsafe_unretained`修饰的指针的内存地址值不变

使用`__unsafe_unretained`修饰，当指针指向的对象销毁时，指针的内存地址不变，如果还使用这个指针来发送消息就容易导致野指针错误，所以在`ARC`环境下，我们还是优先选择使用`__weak`来解决block循环引用问题

解决block循环引用总结如图：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200206-193045@2x.png)


讲解示例代码Demo地址：[https://github.com/guangqiang-liu/06.6-BlockDemo6]()


## 更多文章
* ReactNative开源项目OneM(1200+star)：**[https://github.com/guangqiang-liu/OneM](https://github.com/guangqiang-liu/OneM)**：欢迎小伙伴们 **star**
* iOS组件化开发实战项目(500+star)：**[https://github.com/guangqiang-liu/iOS-Component-Pro]()**：欢迎小伙伴们 **star**
* 简书主页：包含多篇iOS和RN开发相关的技术文章[http://www.jianshu.com/u/023338566ca5](http://www.jianshu.com/u/023338566ca5) 欢迎小伙伴们：**多多关注，点赞**
* ReactNative QQ技术交流群(2000人)：**620792950** 欢迎小伙伴进群交流学习
* iOS QQ技术交流群：**678441305** 欢迎小伙伴进群交流学习