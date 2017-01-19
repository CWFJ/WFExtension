//
//  NSObject+WFExtension.m
//  WFExtension
//
//  Created by 开发者 on 15/3/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "NSObject+WFExtension.h"
#import <objc/runtime.h>
#import "WFType.h"

@implementation NSObject (WFExtension)

/**
 *  利用block循环遍历Class的每个属性
 *
 *  @param block 遍历回调的block
 */
+ (void)enumerateMembersUsingBlock:(void (^)(WFMember *, BOOL *))block{
    
    static const char WFCachedMembersKey;
    // 获得成员变量
    NSMutableArray *cachedMembers = objc_getAssociatedObject(self, &WFCachedMembersKey);
    if (cachedMembers == nil) {
        cachedMembers = [NSMutableArray array];
        
        // 通过运行时，获取属性列表
        uint outCount = 0;  // 成员属性个数
        Ivar *varList = class_copyIvarList(self, &outCount);
        
        // 循环获取成员属性，并回调block
        for (int i = 0; i < outCount; ++i) {
            WFMember *member = [WFMember memberWithIvar:varList[i]];
            [cachedMembers addObject:member];
        }
        free(varList);
        objc_setAssociatedObject(self, &WFCachedMembersKey, cachedMembers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    BOOL stop = FALSE;
    
    for (WFMember *member in cachedMembers) {
        block(member, &stop);
        if(stop) break;
    }
    // 3.释放内存
}
/**
 *  通过字典配置对象属性
 *
 *  @param dict 配置字典
 */
- (void)cfgWithDict:(NSDictionary *)dict{
    [[self class] enumerateMembersUsingBlock:^(WFMember *member, BOOL *stop) {
        // 属性名称
        NSString *memName = member.name;
        NSString *memType = member.type;
        // 默认值
        id memValue       = dict[memName];
        
        if(!memValue) return;
        
        /**************************************************************
         *
         *  若member是NSArray dict[member.name]应该是字典数组
         *  需要将字典数组转化为模型数组
         *
         *************************************************************/
        if([memType rangeOfString:@"NSArray"].length > 0)
        {
            // 需要用户实现了获取数组中成员类方法并且返回字典中可以查询到当前属性所属的 "类"
            if ([self respondsToSelector:@selector(getArrayInsideClassesTable)] && [self getArrayInsideClassesTable][memName])
            {
                Class memClass = NSClassFromString([self getArrayInsideClassesTable][memName]);
                // 递归调用创建模型数组
                memValue       = [memClass objcsWithDictArray:memValue];
            }
        }
        
        /**************************************************************
         *
         *  若member是自定义对象 dict[member.name] 应该是个字典,
         *  递归调用进行配置，将字典转化为对象
         *
         *************************************************************/
        else if(![WFType isBasicType:memType] && ![WFType isFoundationType:memType])
        {
            memValue = [[NSClassFromString(memType) alloc] initWithDict:memValue];
        }
        
        /**************************************************
         *
         *  类型转换处理
         *
         *************************************************/
        else {
            memValue = [WFType reviseType:memType withValue:memValue];
        }
        // 若member是系统对象
        [self setValue:memValue forKey:memName];
    }];
}

/**
 *  使用字典初始化一个对象
 *
 *  @param dict 配置字典
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [self init])
    {
        [self cfgWithDict:dict];
    }
    return self;
}

/**
 *  通过字典数组初始化对象数组
 *
 *  @param dictArray 配置字典数组
 *
 *  @return 初始化好的对象数组
 */
+ (NSArray *)objcsWithDictArray:(NSArray *)dictArray{
    NSMutableArray *objcs = [NSMutableArray arrayWithCapacity:dictArray.count];
    if( [NSStringFromClass([self class]) hasPrefix:@"NS"]) {
        /** Foundation 自带数据类型 */
        for (id key in dictArray) {
            if( [key isMemberOfClass:[self class]]) {
                /** 数组内容非目标数组内容 */
                return nil;
            }
        }
        return dictArray.copy;
    }
    for (int i = 0; i < dictArray.count; ++i) {
        NSDictionary *dict = dictArray[i];
        id obj = [[self alloc] initWithDict:dict];
        [objcs addObject:obj];
    }
    
    return [objcs copy];
}

/**
 *  模型转字典
 *
 *  @return 字典对象
 */
- (NSMutableDictionary *)keyValues {
    return [self keyValuesWithMap:nil];
}

/**
 *  模型转字典
 *
 *  @return 字典对象
 */
- (NSMutableDictionary *)keyValuesWithMap:(NSDictionary *)map {
    
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    
    [[self class] enumerateMembersUsingBlock:^(WFMember *member, BOOL *stop) {
        
        // 属性名称
        NSString *memName  = member.name;
        NSString *memType  = member.type;
        id        memValue = [self valueForKey:memName];
        
        if(!memValue)
        {
            [keyValues setValue:[NSNull null] forKey:memName];
            return;
        }
        
        /**************************************************************
         *
         *  若member是NSArray dict[member.name]应该是字典数组
         *  需要将模型数组转化为字典数组
         *
         *************************************************************/
        if([memType rangeOfString:@"NSArray"].length > 0)
        {
            NSArray *subObjc = (NSArray *)memValue;
            NSMutableArray *subValues = [NSMutableArray arrayWithCapacity:subObjc.count];
            [subObjc enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [subValues addObject:[obj keyValuesWithMap:map]];
            }];
            memValue = subValues;
        }
        
        /**************************************************************
         *
         *  若member是自定义对象 dict[member.name] 应该是个字典,
         *  递归调用进行配置，将对象转化为字典
         *
         *************************************************************/
        else if(![WFType isBasicType:memType] && ![WFType isFoundationType:memType])
        {
            memValue = [memValue keyValuesWithMap:map];
        }
        /**************************************************
         *
         *  类型转换处理
         *
         *************************************************/
        else {
            memValue = [WFType reviseType:memType withValue:memValue];
        }
        // 若member是系统对象
        [keyValues setValue:memValue forKey:memName];
    }];
    
    return keyValues;
}

@end
