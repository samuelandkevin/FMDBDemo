//
//  DataManager.h
//  FMDBDemo
//
//  Created by YHIOS002 on 16/11/2.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHWorkGroup.h"
#import "YHUserInfo.h"

@interface SqliteManager : NSObject

@property (nonatomic,strong) NSMutableArray *dynList;

+ (instancetype)sharedInstance;
- (void)creatDynTable;
//更新动态列表
- (void)updateDynList:(NSArray <YHWorkGroup *>*)dynList;
//获取动态列表
- (void)getDynListComplete:(void(^)(BOOL success,id obj))complete;
@end
