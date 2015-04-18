//
//  WFStatusModel.h
//  DelicatelyLife
//
//  Created by 开发者 on 15/3/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFUserModel.h"

@interface WFStatusModel : NSObject
/** 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;
/** 字符串型的微博ID */
@property (nonatomic, copy) NSString *idstr;
/** 微博信息内容 */
@property (nonatomic, copy) NSString *text;
/** 微博来源  */
@property (nonatomic, copy) NSString *source;

/** 缩略图片地址，没有时不返回此字段 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** 中等尺寸图片地址，没有时不返回此字段 */
@property (nonatomic, copy) NSString *bmiddle_pic;
/** 原始图片地址，没有时不返回此字段  */
@property (nonatomic, copy) NSString *original_pic;

/** 转发数 */
@property (nonatomic, assign) NSNumber *reposts_count;
/** 评论数 */
@property (nonatomic, assign) NSNumber *comments_count;
/** 表态数 */
@property (nonatomic, assign) NSNumber *attitudes_count;
/** 用户信息 */
@property (nonatomic, strong) WFUserModel *user;
/** 转发的状态 */
@property (nonatomic, strong) WFStatusModel *retweeted_status;
/** 获取图片数量 */
@property (nonatomic, assign, readonly) NSInteger getPicCount;
/**
 *  配图数组
 */
@property (nonatomic, strong) NSArray *pic_urls;
/**
 *  获取第一张图片URL
 */
- (NSString *)getFirstImage;
@end
