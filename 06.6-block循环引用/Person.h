//
//  Person.h
//  06.6-block循环引用
//
//  Created by 刘光强 on 2020/2/6.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyBlock)(void);

@interface Person : NSObject

@property (nonatomic, assign) int age;

@property (nonatomic, copy) MyBlock block;
@end

NS_ASSUME_NONNULL_END
