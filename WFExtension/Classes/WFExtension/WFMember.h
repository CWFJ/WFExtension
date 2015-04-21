//
//  WFMember.h
//  WFExtension
//
//  Created by 开发者 on 15/3/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//  将Ivar转换为更容易使用和理解的类型

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface WFMember : NSObject
{
    // 可以被子类继承，但对外部是只读访问
    Ivar _srcIvar;
}
/** 成员属性类型(只读) */
@property (nonatomic, copy, readonly) NSString *type;
/** 成员属性名称(只读) */
@property (nonatomic, copy, readonly) NSString *name;
/** 成员属性全称(只读) */
@property (nonatomic, copy, readonly) NSString *fullName;
/** 原始的Ivar(只读)  */
@property (nonatomic, assign, readonly) Ivar srcIvar;

/**
 *  通过Ivar初始化类方法
 *
 *  @param var 通过运行时获取的Ivar变量
 *
 *  @return 转换过的成员变量类型
 */
+ (instancetype)memberWithIvar:(Ivar)var;
@end
