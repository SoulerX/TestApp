//
//  SideTabBarView.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/28.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideTabBarViewDelegate <NSObject>
@required
- (void)didClickChildButton:(int)selectedIndex;
@end


@interface SideTabBarView : UIView

@property(nonatomic, strong) NSArray *itemArray;
@property(nonatomic, strong) id <SideTabBarViewDelegate>delegate;

@end


@interface TabButton : UIButton

@end

