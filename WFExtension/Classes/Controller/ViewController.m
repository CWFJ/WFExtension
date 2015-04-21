//
//  ViewController.m
//  WFExtension
//
//  Created by 开发者 on 15/3/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "WFExtension.h"
#import "WFUserModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self statusModelTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)statusModelTest {
    NSURL *url = [NSURL URLWithString:@"www.baidu.com"];
    NSDictionary *dict = @{@"name":@"123", @"mbtype":@"12", @"floatTest":@"1.2", @"nsUIntegetTest":@"57", @"numberTest":@"14.2", @"urlTest": url, @"intTest":@"90", @"charTest":@"97", @"floaTest":@"21.7", @"doubleTest":@"432.34", @"longTest":@"865656789", @"longlongTest":@"3135432312"};
    WFUserModel *user = [[WFUserModel alloc] initWithDict:dict];
    NSLog(@"%f", user.numberTest.floatValue);
}
- (void)test{
    NSDictionary *dict = @{@"name":@"Jap", @"dogs":@[@{@"name":@"WangAwa"},@{@"name":@"wangCai"}], @"dogAges":@[@(1.1), @(2.1)]};
    Person *per = [[Person alloc] init];
    [per cfgWithDict:dict];
    
    [[per class] enumerateMembersUsingBlock:^(WFMember *member, BOOL *stop) {
        NSLog(@"%@  ", member.name);
        NSLog(@"%@", [per valueForKey:member.name]);
    }];
}
@end
