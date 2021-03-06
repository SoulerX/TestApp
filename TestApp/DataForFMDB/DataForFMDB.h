//
//  DataForFMDB.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/25.
//  Copyright © 2020 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FData.h"

@interface DataForFMDB : NSObject

+(instancetype)sharedDataBase;

-(void)addFavorite:(NSString*)ftype urlPath:(NSString*)url title:(NSString *)title;
-(void)deleteFavorite:(NSString*)type urlPath:(NSString*)url;
-(BOOL)checkFavorite:(NSString*)type urlPath:(NSString*)url;
-(NSMutableArray*)getFavorite:(NSString*)type;

-(int)addAccount:(NSString*)account passwordString:(NSString*)password protectionString:(NSString *)protection;
-(BOOL)checkAccountPassword:(NSString*)account passwordString:(NSString*)password;
-(BOOL)checkAccountExist:(NSString*)account;
-(NSString*)backAccountPassword:(NSString*)account protectionString:(NSString*)protection;

@end


