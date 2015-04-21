//
//  WFType.m
//  WFExtension
//
//  Created by 开发者 on 15/4/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WFType.h"

static NSSet *_foundationClasses;
static NSNumberFormatter *_numFormatter;

@implementation WFType

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
    _numFormatter = [NSNumberFormatter new];
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
        return TRUE;
    }
    else {
        return FALSE;
    }
}

#pragma mark ------<调整Value的值到合适的类型>
/**
 *  调整Value的值到合适的类型
 *
 *  @param dstType  目标类型
 *  @param srcValue 待调整的数据
 *
 *  @return 调整完成后目标数据
 */
+ (id)reviseType:(NSString *)dstType withValue:(id)srcValue {
    
    NSDictionary *srcClass = @{@"NSString":@(0), @"NSURL":@(1), @"NSNumber":@(2), @"__NSCFConstantString":@(3)};
    NSDictionary *dstClass = @{@"NSString":@(0), @"NSURL":@(1), @"NSNumber":@(2), @"Q":@(3), @"c":@(4)};
    NSNumber *numSrcIndex = srcClass[NSStringFromClass([srcValue class])];
    if(!numSrcIndex) return srcValue;  // 不支持的类型
    NSNumber *numDstIndex = dstClass[dstType];
    if(!numDstIndex) return srcValue;  // 不支持的类型
    
    NSInteger disposeIndex = (numSrcIndex.intValue) * 16 + numDstIndex.intValue;
    
    id dstValue = srcValue;
    switch (disposeIndex) {
        case 0x31:
        case 0x01:  /** NSString ---> NSURL */
            dstValue = [NSURL URLWithString:srcValue];
            break;
        case 0x10:  /** NSURL ---> NSString */
            dstValue = [(NSURL *)srcValue absoluteString];
            break;
        case 0x32:
        case 0x02:  /** NSString ---> NSNumber */
            dstValue = [_numFormatter numberFromString:srcValue];
            break;
        case 0x20:  /** NSNumber ---> NSString */
            dstValue = [(NSNumber *)srcValue description];
            break;
        case 0x33:
        case 0x34:
        case 0x03:
        case 0x04:
            dstValue = @([srcValue integerValue]);
            break;
        default:    /** 不支持或者不需要转换 */
            break;
    }
    return dstValue;
}

@end
