//
//  NSObject+WFExtension.m
//  WFExtension
//
//  Created by 开发者 on 15/3/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "NSObject+WFExtension.h"
#import <objc/runtime.h>

@implementation NSObject (WFExtension)

/**
 *  利用block循环遍历Class的每个属性
 *
 *  @param block 遍历回调的block
 */
- (void)enumerateMembersUsingBlock:(void (^)(WFMember *, BOOL *))block{
    BOOL stop = FALSE;
    // 通过运行时，获取属性列表
    uint outCount = 0;  // 成员属性个数
    Ivar *varList = class_copyIvarList([self class], &outCount);
    
    // 循环获取成员属性，并回调block
    for (int i = 0; !stop && (i < outCount); ++i) {
        WFMember *member = [WFMember memberWithIvar:varList[i]];
        block(member, &stop);
    }
}
/**
 *  通过字典配置对象属性
 *
 *  @param dict 配置字典
 */
- (void)cfgWithDict:(NSDictionary *)dict{
    [self enumerateMembersUsingBlock:^(WFMember *member, BOOL *stop) {
        // 属性名称
        NSString *memName = member.name;
        // 默认值
        id memValue       = dict[memName];
        /**************************************************************
         *
         *  若member是NSArray dict[member.name]应该是字典数组
         *  需要将字典数组转化为模型数组
         *
         *************************************************************/
        if([member.type hasPrefix:@"NS"] && [member.type containsString:@"Array"])
        {
            // 需要用户实现了获取数组中成员类方法并且返回字典中可以查询到当前属性所属的 "类"
            if ([self respondsToSelector:@selector(getArrayInsideClassesTable)] && [self getArrayInsideClassesTable][member.name])
            {
                Class memClass = NSClassFromString([self getArrayInsideClassesTable][member.name]);
                // 递归调用创建模型数组
                memValue       = [memClass objcsWithDictArray:dict[member.name]];
            }
        }
        
        /**************************************************************
         *
         *  若member是自定义对象 dict[member.name] 应该是个字典,
         *  递归调用进行配置，将字典转化为对象
         *
         *************************************************************/
        else if(![member.type hasPrefix:@"NS"] && dict[member.name])
        {
            memValue = [[NSClassFromString(member.type) alloc] initWithDict:dict[member.name]];
        }
        // 若member是系统对象
        [self setValue:memValue forKey:member.name];
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
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        id obj = [[self alloc] initWithDict:dict];
        [objcs addObject:obj];
    }];
    
    return [objcs copy];
}
@end
