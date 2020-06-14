//
//  main.m
//  06.6-block循环引用
//
//  Created by 刘光强 on 2020/2/6.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

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
