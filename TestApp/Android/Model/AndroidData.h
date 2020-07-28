//
//  AndroidData.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AndroidData : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) int likeCounts;
@property (nonatomic, strong) NSString *publishedAt;
@property (nonatomic, assign) int stars;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSString *views;

@end

NS_ASSUME_NONNULL_END
