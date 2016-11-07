//
//  ViewController.m
//  FMDBDemo
//
//  Created by YHIOS002 on 16/11/2.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "ViewController.h"
#import "YHWorkGroup.h"
#import "YHUserInfo.h"
#import "SqliteManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //建表
    [[SqliteManager sharedInstance] creatDynTable];
    
    //插入数据
    //生成模拟数据
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<1000; i++) {
        YHWorkGroup *model=  [[YHWorkGroup alloc] init];
        model.dynamicId = [NSString stringWithFormat:@"2016-%d",i];
        YHUserInfo *userInfo = [YHUserInfo new];
        model.userInfo = userInfo;
        model.type = 0;
        model.publishTime = @"2014-10-1";
        model.msgContent = @"我耳机佛教讲辅导书就分了就爱上的了房间爱上当减肥了坚实的垃圾分类撒娇东方拉斯加浪费大家安老师；的房间爱老师；九分裤；了撒娇地方了撒娇的浪费就爱上了；对方就爱上了；解放路；盛大交付拉丝机路口附近萨洛克的解放路口；是大家";
        model.commentCount = arc4random()%100;
        model.likeCount =arc4random()%100;
        model.isLike = (1+arc4random()%100%2)?YES:NO;
        model.visible = 1;
        model.originalPicUrls = @[[NSURL URLWithString:@"1"],[NSURL URLWithString:@"1"],[NSURL URLWithString:@"1"],[NSURL URLWithString:@"1"]];
        model.thumbnailPicUrls = @[[NSURL URLWithString:@"11"],[NSURL URLWithString:@"11"],[NSURL URLWithString:@"11"],[NSURL URLWithString:@"11"]];
        [array addObject:model];
    }
    //插入数据
    [[SqliteManager sharedInstance] updateDynList:array];
    
    
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"query Start");
    [[SqliteManager sharedInstance] getDynListComplete:^(BOOL success, id obj) {
        if (success) {
            NSArray *array = obj;
            NSLog(@"query Stop");
        }
    }];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
