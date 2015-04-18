//
//  WFUserModel.h
//  DelicatelyLife
//
//  Created by 开发者 on 15/3/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WFUserModel : NSObject
/** 友好显示名称 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger mbtype;

@property (nonatomic, assign) CGFloat floatTest;
@property (nonatomic, assign) NSUInteger nsUIntegetTest;
@property (nonatomic, strong) NSNumber *numberTest;
@property (nonatomic, strong) NSString *urlTest;
@property (nonatomic, assign) int intTest;
@property (nonatomic, assign) char charTest;
@property (nonatomic, assign) float floaTest;
@property (nonatomic, assign) double doubleTest;
@property (nonatomic, assign) long longTest;
@property (nonatomic, assign) long long longlongTest;

@end
