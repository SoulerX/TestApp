//
//  WaterFullLayout.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/24.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFallLayout;

@protocol  WaterFallLayoutDelegate<NSObject>

@required
/**
 * 每个item的高度
 */
- (CGFloat)waterFallLayout:(WaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterFallLayout:(WaterFallLayout *)waterFallLayout;

/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInWaterFallLayout:(WaterFallLayout *)waterFallLayout;

/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInWaterFallLayout:(WaterFallLayout *)waterFallLayout;

/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(WaterFallLayout *)waterFallLayout;


@end


@interface WaterFallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterFallLayoutDelegate> delegate;

@end

