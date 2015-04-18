//
//  WFMember.m
//  WFExtension
//
//  Created by 开发者 on 15/3/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WFMember.h"

static NSSet *_foundationClasses;

@implementation WFMember

#pragma mark ------<初始化>

- (instancetype)initWithIvar:(Ivar)var{
    if(self = [super init])
    {
        // 获取属性全名称
        _fullName = [NSString stringWithUTF8String:ivar_getName(var)];
        // 获取属性名称
        _name = [_fullName hasPrefix:@"_"] ? [_fullName substringFromIndex:1] : _fullName;
        // 当前格式为：@"类型名称"
        _type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        // 更改格式，去除 @ 及 " 符号;
        if ([_type hasPrefix:@"@\""]) {
            _type = [_type substringWithRange:NSMakeRange(2, _type.length - 3)];
        }
        // 记录原始的var
        _srcIvar = var;
    }
    return self;
}
/**
 *  通过Ivar初始化类方法
 *
 *  @param var 通过运行时获取的Ivar变量
 *
 *  @return 转换过的成员变量类型
 */
+ (instancetype)memberWithIvar:(Ivar)var{
    return [[self alloc] initWithIvar:var];
}

#pragma mark ------<判断基本数据类型>
/**
 *  判断是否为基本数据类型
 *
 *  @param type 需判断的类型编码名称
 *
 *  @return 结果
 *  @note   类型编码     实际类型
 *          c    ---    char
 *          i    ---    int
 *          f    ---    float
 *          d    ---    double
 *          q    ---    long
 *          q    ---    long long
 *          q    ---    NSInteger
 *          Q    ---    NSUInteger
 *          d    ---    CGFloat
 */
+ (BOOL)isBasicType:(NSString *)type {
    NSString *foundationType = @"cifqdQ";
    if([type hasPrefix:@"NS"] || ([foundationType rangeOfString:type].length == 1)) {
        NSLog(@"%@", type);
        return TRUE;
    }
    else {
        return FALSE;
    }
}

#pragma mark ------<判断基本Foundation类型>
/**
 *  判断是否为Foundation数据类型
 *
 *  @param type 需判断的类型编码名称
 *
 *  @return 结果
 */
+ (BOOL)isFoundationType:(NSString *)type
{
    Class typeClass = NSClassFromString(type);
    return [_foundationClasses containsObject:typeClass];
}

+ (void)load
{
    _foundationClasses = [NSSet setWithObjects:
                          [NSObject class],
                          [NSURL class],
                          [NSDate class],
                          [NSNumber class],
                          [NSDecimalNumber class],
                          [NSData class],
                          [NSMutableData class],
                          [NSArray class],
                          [NSMutableArray class],
                          [NSDictionary class],
                          [NSMutableDictionary class],
                          [NSString class],
                          [NSMutableString class], nil];
}
@end
