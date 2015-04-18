//
//  WFStatusModel.m
//  DelicatelyLife
//
//  Created by 开发者 on 15/3/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WFStatusModel.h"

@implementation WFStatusModel

- (NSString *)getFirstImage
{
    NSString *imageName = nil;
    WFStatusModel *status = self;
    while (!imageName) {
        imageName = status.thumbnail_pic;
        status = status.retweeted_status;
        if(!status)
        {
            break;
        }
    }
    return imageName;
}

- (NSInteger)getPicCount{
    NSInteger count = 0;
    WFStatusModel *status = self;
    WFStatusModel *currStatus = self;
    while (count == 0) {
        // 获取图片数量
        count = status.pic_urls.count;
        currStatus = status;
        status = status.retweeted_status;
        if(!status)
        {
            break;
        }
    }
    self.pic_urls = currStatus.pic_urls;
    return count;
}

- (NSDictionary *)getArrayInsideClassesTable{
    return @{@"pic_urls":@"NSDictionary"};
}

- (NSString *)created_at {
    if(_created_at) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        /** 转换格式 */
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSDate *infoDate = [formatter dateFromString:_created_at];
        NSCalendar *cal = [NSCalendar currentCalendar];
        /** 从指定的时间中获取时间的组成成分 */
        
        NSDateComponents *cmps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  fromDate:infoDate];
        
        /** 距离当前时间间隔 */
        NSTimeInterval interval = -[infoDate timeIntervalSinceNow];
        
        NSString *dateStr = [NSString string];
        if( ((interval <= 60) && (dateStr = @"刚刚")) || \
           ((interval <= 3600) && (dateStr = [NSString stringWithFormat:@"%d分钟前", (int)interval / 60])) || \
           ((interval <= 86400) && (dateStr = [NSString stringWithFormat:@"%d小时前", (int)interval / 3600])) || \
           ((interval <= 172800) && (dateStr = [NSString stringWithFormat:@"昨天 %02ld:%02ld", (long)cmps.hour, (long)cmps.minute])) || \
           ((interval <= 31536000) && (dateStr = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld", (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute])) || \
           (dateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日 %02ld:%02ld", (long)cmps.year, (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute]) ) {
            return dateStr;
        }
    }
    else {
        return @"外星消息";
    }
    return _created_at;
}
@end
