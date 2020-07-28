//
//  CycleBannerView.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CycleBannerView : UIView

@property (nonatomic, copy) void(^indexBack)(NSInteger pageIndex);      //页数回调

@property (nonatomic, copy) NSMutableArray *imageArray;    //存储图片数据

@property (nonatomic, assign) NSInteger index;      //当前第几页

@property (nonatomic, assign) NSTimeInterval duration;       //时长

@end

