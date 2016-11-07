//
//  DataManager.m
//  FMDBDemo
//
//  Created by YHIOS002 on 16/11/2.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "SqliteManager.h"
#import "FMDB.h"


@interface SqliteManager()
@property(nonatomic,strong) FMDatabaseQueue *dbQueue;
@property(nonatomic,copy) NSString *pathDynDB;
@end

@implementation SqliteManager


+ (instancetype)sharedInstance{
    static SqliteManager *g_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instance = [[SqliteManager alloc] init];
        
       
        FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:g_instance.pathDynDB];
        g_instance.dbQueue = dbQueue;
    });
    return g_instance;

}

#pragma mark - Lazy Load
-(NSString *)pathDynDB{
    if (!_pathDynDB) {
        _pathDynDB = [NSTemporaryDirectory() stringByAppendingPathComponent:@"dyn.db"];
    }
    return _pathDynDB;
}

- (NSMutableArray *)dynList{
    if (!_dynList) {
        _dynList = [NSMutableArray new];
    }
    return _dynList;
}

#pragma mark - create
//创建动态表
- (void)creatDynTable{
    //建表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS dynamic (dynamicId text,type integer,publishTime text,msgContent text,commentCount integer,likeCount integer,isLike integer,visible integer,originalPicUrls text,thumbnailPicUrls text,isRepost integer,isOpening boolean,timestamp integer)";
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL success = [db executeStatements:sql];
        if (success) {
            NSLog(@"creat success");
        }else{
            NSLog(@"creat fail");
        }
    }];
}

//创建用户表
- (void)creatUserTable{
    
}

//创建好友列表
- (void)creatFriendsTable{
    
}

#pragma mark - update
//更新用户信息
- (void)updateUserInfo:(YHUserInfo *)userInfo{
    
}

//更新动态
- (void)updateDyn:(YHWorkGroup *)dyn{
    
}


#pragma mark - delete
//删除动态
- (void)deleteDyn:(YHWorkGroup *)dyn{
    
}

#pragma mark - add
//添加动态
- (void)insertDyn:(YHWorkGroup *)dyn{
    
}

//更新动态列表
- (void)updateDynList:(NSArray <YHWorkGroup *>*)dynList{
    

    for (int i=0; i<dynList.count; i++) {
        YHWorkGroup *model = dynList[i];
        FMDatabase *dynDB = [FMDatabase databaseWithPath:self.pathDynDB];
        [dynDB open];
        NSString *insertDyn = @"INSERT INTO dynamic (dynamicId, type, publishTime, msgContent, commentCount, likeCount, isLike, visible, originalPicUrls, thumbnailPicUrls , isRepost , isOpening,timestamp) VALUES (:dynamicId,:type,:publishTime,:msgContent,:commentCount,:likeCount,:isLike,:visible,:originalPicUrls,:thumbnailPicUrls,:isRepost,:isOpening,:timestamp);";
        NSString *updateDyn = @"UPDATE dynamic SET  type = ? , publishTime = ?,msgContent = ?,commentCount = ?, likeCount = ? ,isLike = ? ,visible = ? , originalPicUrls = ? ,thumbnailPicUrls = ?,isRepost = ? , isOpening = ? ,timestamp = ?WHERE dynamicId = ?;";
       
        NSDictionary *insertDict = @{ @"dynamicId": model.dynamicId,
                                @"type": @(model.type),
                                @"publishTime":model.publishTime ,
                                @"msgContent"   :model.msgContent ,
                                @"commentCount" : @(model.commentCount),
                                @"likeCount"     : @(model.likeCount),
                                @"isLike"   : @(model.isLike),
                                @"visible"     :@(model.visible) ,
                                @"originalPicUrls":model.originalPicUrls,
                                @"thumbnailPicUrls":model.thumbnailPicUrls,
                                @"isRepost":@(model.isRepost),
                                @"isOpening":@(model.isOpening),
                                @"timestamp":@(model.timestamp)
                                };
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
          BOOL ret = NO;
          FMResultSet *os = [db executeQuery:@"SELECT * FROM dynamic WHERE dynamicId = ? ;",model.dynamicId];
            if (![os next]) {
               ret =  [db executeUpdate:insertDyn withParameterDictionary:insertDict];
            }else{
               ret =  [db executeUpdate:updateDyn,@(model.type),model.publishTime,model.msgContent,@(model.commentCount),@(model.likeCount),@(model.isLike),@(model.visible),model.originalPicUrls,model.thumbnailPicUrls,@(model.isRepost),@(model.isOpening),model.dynamicId,@(model.timestamp)];
            }
            
            do {
                BOOL __err = ret;
                if (!__err) {
                    NSLog(@"db err %d, %@", [db lastErrorCode], [db lastError]);
                }
            } while (0);
        }];

    }
    
}

- (void)getDynListComplete:(void(^)(BOOL success,id obj))complete{
    
    __weak typeof(self)weakSelf = self;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *maRet = [NSMutableArray new];
        FMResultSet *set = [db executeQuery:@"SELECT * FROM dynamic ORDER BY timestamp DESC"];
        while ([set next]) {
            YHWorkGroup *model = [YHWorkGroup new];
            model.dynamicId = [set stringForColumn:@"dynamicId"]; //动态Id
            model.type = [set intForColumn:@"type"];         //动态类型
            model.publishTime = [set stringForColumn:@"publishTime"];//发布时间
           model.msgContent = [set stringForColumn:@"msgContent"]; //动态文本内容
            model.commentCount = [set intForColumn:@"commentCount"]; //评论数
             model.likeCount = [set intForColumn:@"likeCount"];   //点赞数
             model.isLike = [set boolForColumn:@"isLike"];   //是否喜欢
             model.visible = [set intForColumn:@"visible"];  //可见性
//            model.originalPicUrls =  //原图像Url
//            model.thumbnailPicUrls;//缩略图Url
            
            model.timestamp = [set intForColumn:@"timestamp"];
            
            model.isRepost = [set intForColumn:@"isRepost"];//转发
            model.isOpening = [set boolForColumn:@"isOpening"];
            [weakSelf.dynList addObject:model];
            [maRet addObject:model];
           
        }
        complete(YES,maRet);
    }];
    
}

- (void)deleteDynList{
    
    
}

#pragma mark - select

//搜索动态
- (void)queryDyn:(YHWorkGroup *)dyn{

}


@end
