//
//  GirlDetailViewController.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface GirlDetailViewController : UIViewController

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL like;

@end
