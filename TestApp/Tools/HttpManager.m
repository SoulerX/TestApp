//
//  HttpManager.m
//  TestApp
//
//  Created by xuzhiwei on 2020/8/4.
//  Copyright © 2020 netease. All rights reserved.
//

#import "HttpManager.h"
#import <AFNetworking.h>


@interface HttpManager()
@property(nonatomic,strong) AFHTTPSessionManager * SessionManager;
+ (void)getUrl:(NSString*)strUrl completionHandler:(nonnull void (^)(NSArray * _Nullable))completionHandler;
@end

@implementation HttpManager

static HttpManager * manager = nil;

+ (instancetype)shareHttpManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager)
        {
            manager = [[HttpManager alloc]init];
        }
    });
    return manager;
}

- (instancetype)init
{
    if ((manager = [super  init]))
    {
        manager.SessionManager = [AFHTTPSessionManager manager];
        manager.SessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.SessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.SessionManager.requestSerializer setTimeoutInterval:10];
    }
    return manager;
}

+ (void)getUrl:(NSString*)strUrl completionHandler:(nonnull void (^)(NSArray * _Nullable))completionHandler{
    
}


@end

