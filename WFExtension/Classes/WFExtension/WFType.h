//
//  WFType.h
//  WFExtension
//
//  Created by 开发者 on 15/4/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFType : NSObject

/**
 *  判断是否为基本数据类型
 *
 *  @param type 需判断的类型编码名称
 *
 *  @return 结果
 */
+ (BOOL)isBasicType:(NSString *)type;

/**
 *  判断是否为Foundation数据类型
 *
 *  @param type 需判断的类型编码名称
 *
 *  @return 结果
 */
+ (BOOL)isFoundationType:(NSString *)type;

/**
 *  调整Value的值到合适的类型
 *
 *  @param dstType  目标类型
 *  @param srcValue 待调整的数据
 *
 *  @return 调整完成后目标数据
 */
+ (id)reviseType:(NSString *)dstType withValue:(id)srcValue;
@end
