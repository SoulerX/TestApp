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
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"Farorite.db"];
        
        //实例化FMDataBase对象
        NSLog(@"---path:%@",filePath);
        
        fmdb = [FMDatabase databaseWithPath:filePath];
        
        if([fmdb open]) {
            
            //监测数据库中我要需要的表是否已经存在
            NSString *existsSql = [NSString stringWithFormat:@"SELECT COUNT(*) count FROM sqlite_master where type='table' and name='account'"];
            FMResultSet *rs = [fmdb executeQuery:existsSql];
            if ([rs next]) {
                NSInteger count = [rs intForColumn:@"count"];
                if (count > 0) {
                    NSLog(@"table:account 已经存在");
                }
                else{
                    [self createAccountTable];
                }
            }
            
            NSString *existsSql2 = [NSString stringWithFormat:@"SELECT COUNT(*) count FROM sqlite_master where type='table' and name='girl'"];
            FMResultSet *rs2 = [fmdb executeQuery:existsSql2];
            if ([rs2 next]) {
                NSInteger count = [rs2 intForColumn:@"count"];
                if (count > 0) {
                    NSLog(@"table:girl 已经存在");
                }
                else{
                    [self createGirlTable];
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
                    [self createIosTable];
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
                    [self createAndroidTable];
                }
            }
            
            [fmdb close];
            NSLog(@"初始化成功");
        }else{
            NSLog(@"数据库打开失败---%@", fmdb.lastErrorMessage);
        }
    });
}


#pragma mark -create
-(void)createAccountTable{
    NSString *accountSQL =@"create table if not exists Account (account text, password text, protection text)";
    BOOL accountSuccess = [fmdb executeUpdate:accountSQL];
    if(!accountSuccess) {
        NSLog(@"accountTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"accountTable创建成功");
    }
}

-(void)createGirlTable{
    NSString *girlSQL =@"create table if not exists Girl (url text, title text)";
    BOOL girlSuccess = [fmdb executeUpdate:girlSQL];
    if(!girlSuccess) {
        NSLog(@"girlTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"girlTable创建成功");
    }
}

-(void)createIosTable{
    NSString *iosSQL =@"create table if not exists iOS (url text, title text)";
    BOOL iosSuccess = [fmdb executeUpdate:iosSQL];
    if(!iosSuccess) {
        NSLog(@"iosTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"iosTable创建成功");
    }
}

-(void)createAndroidTable{
    NSString *androidSQL =@"create table if not exists Android (url text, title text)";
    BOOL androidSuccess = [fmdb executeUpdate:androidSQL];
    if(!androidSuccess) {
        NSLog(@"androidTable创建失败---%@",fmdb.lastErrorMessage);
    }
    else{
        NSLog(@"androidTable创建成功");
    }
}


#pragma mark -add/delete/check/get
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
    
    FMResultSet *result = [fmdb executeQuery:[NSString stringWithFormat:@"select * from '%@'",type]];
    
    while([result next]) {
        AddData *data = [[AddData alloc] init];
        
        data.url = [result stringForColumn:@"url"];
        data.title = [result stringForColumn:@"title"];
        
        [array addObject:data];
    }
    
    [fmdb close];
    
    return array;
}


#pragma mark -login&register
-(int)addAccount:(NSString*)account passwordString:(NSString*)password protectionString:(NSString *)protection{
    if([self checkAccountExist:account] == YES){
        return 0;
    }
    
    [fmdb open];
    
    NSString *SQL = [NSString stringWithFormat:@"INSERT INTO 'Account'(account, password, protection) VALUES('%@', '%@', '%@');", account, password, protection];
    
    BOOL isAddSuccess = [fmdb executeUpdate:SQL];
    
    if(!isAddSuccess) {
        NSLog(@"accoount--Table插入信息失败--%@",  fmdb.lastErrorMessage);
        NSLog(@"%@   %@   %@",account, password, protection);
        [fmdb close];
        return -1;
    }
    else{
        NSLog(@"account--Table插入信息成功--%@ %@ %@", account, password, protection);
        [fmdb close];
        return 1;
    }

}

-(BOOL)checkAccountExist:(NSString*)account{
    [fmdb open];

    FMResultSet *rs =[fmdb executeQuery:[NSString stringWithFormat: @"SELECT account FROM Account"]];
    
    while([rs next])
    {
        if([[rs stringForColumn:@"account"] isEqualToString:account])
        {
            NSLog(@"存在账户:%@",account);
            [fmdb close];
            return YES;
        }
    }
    NSLog(@"不存在账户:%@",account);
    [fmdb close];
    return NO;
}

-(BOOL)checkAccountPassword:(NSString*)account passwordString:(NSString*)password{
    [fmdb open];

    FMResultSet *rs =[fmdb executeQuery:[NSString stringWithFormat: @"SELECT password FROM Account WHERE account='%@'", account]];
    
    while([rs next]){
        NSLog(@"账号存在");
        if([password isEqualToString:[rs stringForColumn:@"password"]])
        {
            NSLog(@"登录成功");
            [fmdb close];
            return YES;
        }
        NSLog(@"密码错误");
        [fmdb close];
        return NO;
    }
    NSLog(@"账号不存在");
    [fmdb close];
    return NO;
}

-(NSString*)backAccountPassword:(NSString*)account protectionString:(NSString*)protection{
    [fmdb open];

    FMResultSet *rs =[fmdb executeQuery:[NSString stringWithFormat: @"SELECT protection,password FROM Account WHERE account='%@'", account]];
    
    while([rs next]){
        NSLog(@"账号存在");
        if([protection isEqualToString:[rs stringForColumn:@"protection"]])
        {
            NSString *str =[rs stringForColumn:@"password"];
            NSLog(@"找回密码:%@",str);
            [fmdb close];
            return str;
        }
        NSLog(@"密保错误");
        [fmdb close];
        return nil;
    }
    NSLog(@"账号不存在");
    [fmdb close];
    return nil;
}

@end



