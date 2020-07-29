//
//  DataForFMDB.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/25.
//  Copyright © 2020 netease. All rights reserved.
//

#import "DataForFMDB.h"
#import <FMDB.h>
#import "FData.h"
#import "AddData.h"

@interface DataForFMDB (){
    FMDatabase *fmdb;
}
@end

@implementation DataForFMDB

static DataForFMDB *theData = nil;

+(instancetype)sharedDataBase{
    @synchronized(self) {
        if(!theData) {
            theData = [[DataForFMDB alloc] init];
            [theData initDataBase];
        }
     }
    return theData;
}

-(void)initDataBase{
    static dispatch_once_t once;
    
    dispatch_once(&once,^{
        //获得Documents目录路径
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        //文件路径
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"TestApp/Farorite.db"];
        
        //实例化FMDataBase对象
        NSLog(@"---path:%@",filePath);
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
        
//        if(![fileManager fileExistsAtPath:filePath])
        
        fmdb = [FMDatabase databaseWithPath:filePath];
        
        if([fmdb open]) {
            
            //监测数据库中我要需要的表是否已经存在
            NSString *existsSql2 = [NSString stringWithFormat:@"SELECT COUNT(*) count FROM sqlite_master where type='table' and name='girl'"];
            FMResultSet *rs2 = [fmdb executeQuery:existsSql2];
            if ([rs2 next]) {
                NSInteger count = [rs2 intForColumn:@"count"];
                if (count > 0) {
                    NSLog(@"table:girl 已经存在");
                }
                else{
                    [self addGirlTable];
                }
            }
          
            NSString *existsSql3 = [NSString stringWithFormat:@"SELECT COUNT(*) count FROM sqlite_master where type='table' and name='ios'"];
            FMResultSet *rs3 = [fmdb executeQuery:existsSql3];
            if ([rs3 next]) {
                NSInteger count = [rs3 intForColumn:@"count"];
                if (count > 0) {
                    NSLog(@"table:ios 已经存在");
                }
                else{
                    [self addIosTable];
                }
            }
            
            NSString *existsSql4 = [NSString stringWithFormat:@"SELECT COUNT(*) count FROM sqlite_master where type='table' and name='android'"];
            FMResultSet *rs4 = [fmdb executeQuery:existsSql4];
            if ([rs4 next]) {
                NSInteger count = [rs4 intForColumn:@"count"];
                if (count > 0) {
                    NSLog(@"table:android 已经存在");
                }
                else{
                    [self addAndroidTable];
                }
            }
            
            
            [fmdb close];
            NSLog(@"初始化成功");
        }else{
            NSLog(@"数据库打开失败---%@", fmdb.lastErrorMessage);
        }
    });
}

-(void)addGirlTable{
    NSString *girlSQL =@"create table if not exists Girl (url text, title text)";
    BOOL girlSuccess = [fmdb executeUpdate:girlSQL];
    if(!girlSuccess) {
        NSLog(@"girlTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"girlTable创建成功");
    }
}

-(void)addIosTable{
    NSString *iosSQL =@"create table if not exists iOS (url text, title text)";
    BOOL iosSuccess = [fmdb executeUpdate:iosSQL];
    if(!iosSuccess) {
        NSLog(@"iosTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"iosTable创建成功");
    }
}

-(void)addAndroidTable{
    NSString *androidSQL =@"create table if not exists Android (url text, title text)";
    BOOL androidSuccess = [fmdb executeUpdate:androidSQL];
    if(!androidSuccess) {
        NSLog(@"androidTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"androidTable创建成功");
    }
}

-(void)addFavorite:(NSString*)ftype urlPath:(NSString*)url title:(NSString *)title{
    [fmdb open];
    NSLog(@"%@   %@",ftype, url);
    NSString *SQL = [NSString stringWithFormat:@"INSERT INTO '%@'(url, title) VALUES('%@', '%@');",ftype, url, title];
    
    BOOL isAddSuccess = [fmdb executeUpdate:SQL];
    
    if(!isAddSuccess) {
        NSLog(@"%@--Table插入信息失败--%@", ftype, fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"%@--Table插入信息成功--%@", ftype, url);
    }
    
    [fmdb close];
}

-(void)deleteFavorite:(NSString*)ftype urlPath:(NSString*)url{
    
    [fmdb open];
    NSString *SQL = [NSString stringWithFormat: @"delete from '%@' where url = '%@'",ftype, url];
    BOOL isDeleteSuccess = [fmdb executeUpdate:SQL];
    if(!isDeleteSuccess) {
        NSLog(@"%@--Table删除信息失败--%@",ftype, fmdb.lastErrorMessage);
    }
    else{
         NSLog(@"%@--Table删除信息成功--%@", ftype, url);
     }
    [fmdb close];
}

-(BOOL)checkFavorite:(NSString*)type urlPath:(NSString*)url{
    [fmdb open];
    //检测某个数据是否存在<br> @"SELECT COUNT(*) count FROM sqlite_master where type='table' and name='ios'"
    FMResultSet *rs =[fmdb executeQuery:[NSString stringWithFormat: @"SELECT COUNT(*) url FROM '%@' WHERE url = '%@'", type, url]];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"url"];
        if (count > 0) {
            //存在
            [fmdb close];
            return YES;
        }
        else
        {
            [fmdb close];
            return NO;
        }
    }
    [fmdb close];
    return NO;
}

-(NSMutableArray*)getFavorite:(NSString*)type{
    [fmdb open];
    
    NSMutableArray *array = [NSMutableArray new];
    
    FMResultSet *result = [fmdb executeQuery:@"select * from Girl"];
    
    while([result next]) {
        AddData *data = [[AddData alloc] init];
        
        data.url = [result stringForColumn:@"url"];
        data.title = [result stringForColumn:@"title"];
        
        [array addObject:data];
    }
    
    [fmdb close];
    
    return array;
}

@end



