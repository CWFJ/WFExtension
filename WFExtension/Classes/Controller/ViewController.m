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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test{
    NSDictionary *dict = @{@"name":@"Jap", @"dogs":@[@{@"name":@"WangAwa"},@{@"name":@"wangCai"}]};
    Person *per = [[Person alloc] init];
    [per cfgWithDict:dict];
    
    [per enumerateMembersUsingBlock:^(WFMember *member, BOOL *stop) {
        NSLog(@"%@  ", member.name);
        NSLog(@"%@", [per valueForKey:member.name]);
    }];
}
@end
