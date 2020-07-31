//
//  BaseEngine.m
//  新闻
//
//  Created by 范英强 on 16/9/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseEngine.h"
#import "AFNetworking.h"

@implementation BaseEngine

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)runRequestWithPara:(NSMutableDictionary *)para
                      path:(NSString *)path
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(id error))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:path parameters:para headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" --%@ %@",path,responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" --%@ %@",path,error);
        failure(error);
    }];
}

// URL
+ (void) requestUrl:(NSString*) strurl completionHandler:(nonnull void (^)(NSArray * _Nullable))completionHandler{
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request setURL:[NSURL URLWithString:strurl]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(!data)
        {
            return;
        }

        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *dataarray = result[@"data"];
        
        if(completionHandler)
            completionHandler(dataarray);
        
    }] resume];
}

+ (void)getUrl:(NSString*)strUrl{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager GET:strUrl parameters:nil headers:nil progress:nil success:^(AFHTTPSessionManager *operation, id responseObject){
//        NSLog(@"");
//    } failure:^(AFHTTPSessionManager  *operation, NSError *error){
//        NSLog(@"请求失败------------->%@",error);
//    }];
//    
}

@end


