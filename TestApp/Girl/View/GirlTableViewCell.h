//
//  GirlTableViewCell.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GirlData.h"

@interface GirlTableViewCell : UITableViewCell

/**
 *  数据模型
 */
@property (nonatomic, strong) GirlData *dataModel;
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
/**
 *  收藏
 */
@property (weak, nonatomic) UIButton *btnLike;

@property (assign, nonatomic) BOOL isLike;

@end

