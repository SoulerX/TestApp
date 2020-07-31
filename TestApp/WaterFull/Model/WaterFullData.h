//
//  WaterFullData.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/24.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFullData : NSObject

/** 宽度  */
@property (nonatomic, assign) CGFloat w;
/** 高度  */
@property (nonatomic, assign) CGFloat h;
/** 图片  */
@property (nonatomic, copy) NSMutableArray *images;
/** 标题  */
@property (nonatomic, copy) NSString *title;
/** url  */
@property (nonatomic, copy) NSString *url;

@end


