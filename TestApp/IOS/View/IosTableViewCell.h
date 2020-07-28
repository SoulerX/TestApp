//
//  IosTableViewCell.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IosData.h"


@interface IosTableViewCell : UITableViewCell

@property (nonatomic, assign)BOOL status;
/**
 *  数据模型
 */
@property (nonatomic, strong) IosData *dataModel;
/**
 *  图片1
 */
@property (weak, nonatomic) UIImageView *imgIcon1;
/**
 *  图片2
 */
@property (weak, nonatomic) UIImageView *imgIcon2;
/**
 *  图片3
 */
@property (weak, nonatomic) UIImageView *imgIcon3;
/**
 *  图片
 */
@property (weak, nonatomic) UIImageView *viewsIcon;
/**
 *  图片
 */
@property (weak, nonatomic) UIImageView *commentIcon;
/**
 *  按钮
 */
@property (weak, nonatomic) UIButton *likeButton;
/**
 *  标题
 */
@property (weak, nonatomic) UILabel *lblTitle;
/**
 *  浏览数
 */
@property (weak, nonatomic) UILabel *lblViews;
/**
 *  评论数
 */
@property (weak, nonatomic) UILabel *lblComment;
/**
 *  点赞数
 */
@property (weak, nonatomic) UILabel *lblLike;
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

