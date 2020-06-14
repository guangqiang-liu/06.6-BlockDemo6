//
//  Person.m
//  06.6-block循环引用
//
//  Created by 刘光强 on 2020/2/6.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
