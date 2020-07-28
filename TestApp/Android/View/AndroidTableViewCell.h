//
//  AndroidTableViewCell.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndroidData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AndroidTableViewCell : UITableViewCell

/**
 *  数据模型
 */
@property (nonatomic, strong) AndroidData *dataModel;
/**
 *  图片
 */
@property (weak, nonatomic) UIImageView *imgIcon;
/**
 *  标题
 */
@property (weak, nonatomic) UILabel *lblTitle;
/**
 *  浏览数
 */
@property (weak, nonatomic) UILabel *lblViews;
/**
 *  描述
 */
@property (weak, nonatomic) UILabel *lblDescription;
/**
 *  创建时间
 */
@property (weak, nonatomic) UILabel *lblCreate;
/**
 *  作者
 */
@property (weak, nonatomic) UILabel *lblAuthor;

@end

NS_ASSUME_NONNULL_END
