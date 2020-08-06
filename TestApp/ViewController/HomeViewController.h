//
//  HomeViewController.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PassingValueBlock)(void);

@interface HomeViewController : UIViewController

@property (nonatomic, copy) PassingValueBlock passingValue;

@end

