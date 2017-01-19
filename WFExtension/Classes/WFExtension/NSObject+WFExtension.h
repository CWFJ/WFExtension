//
//  NSObject+WFExtension.h
//  WFExtension
//
//  Created by 开发者 on 15/3/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFMember.h"

@protocol WFExtension <NSObject>
@optional
/**************************************************************
 *
 *  TODO:这里通过增加协议，根据函数获取数组类型列表
 *  还可以通过运行时，直接增加字典属性，这样会不会增加内存消耗
 *
 *************************************************************/
- (NSDictionary *)getArrayInsideClassesTable;
@end

@interface NSObject (WFExtension) <WFExtension>

/**
 *  利用block循环遍历Class的每个属性
 *
 *  @param block 遍历回调的block
 */
+ (void)enumerateMembersUsingBlock:(void (^)(WFMember *member, BOOL *stop))block;

/**
 *  通过字典配置对象属性
 *
 *  @param dict 配置字典
 */
- (void)cfgWithDict:(NSDictionary *)dict;

/**
 *  使用字典初始化一个对象
 *
 *  @param dict 配置字典
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  通过字典数组初始化对象数组
 *
 *  @param dictArray 配置字典数组
 *
 *  @return 初始化好的对象数组
 */
+ (NSArray *)objcsWithDictArray:(NSArray *)dictArray;


/**
 *  模型转字典
 *
 *  @return 字典对象
 */
- (NSMutableDictionary *)keyValues;
- (NSMutableDictionary *)keyValuesWithMap:(NSDictionary *)map;
@end
