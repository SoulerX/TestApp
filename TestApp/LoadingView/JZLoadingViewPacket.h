//
//  AppDelegate.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/27.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RequestLoading,
    RequestSuccess,
    RequestFaild,
} RequestResult;

@interface JZLoadingViewPacket : UIView

+ (JZLoadingViewPacket *)shareInstance;

+ (void)showWithTitle:(NSString *)title result:(RequestResult)result addToView:(UIView *)selfView;

- (void)showWithTitle:(NSString *)title result:(RequestResult)result;

- (void)jz_hide;

@end
