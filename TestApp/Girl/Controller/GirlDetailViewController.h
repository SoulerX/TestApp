//
//  GirlDetailViewController.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void (^PassingValueBlock)(void);

@interface GirlDetailViewController : UIViewController

@property (nonatomic, copy) PassingValueBlock passingValue;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL like;

@property (nonatomic , strong)WKWebView *webView;
@end
