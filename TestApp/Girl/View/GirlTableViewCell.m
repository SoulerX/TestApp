//
//  GirlTableViewCell.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "GirlTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataForFMDB.h"

@implementation GirlTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // 图片
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(8, 8, 60, 90);
        [imageV setContentMode:UIViewContentModeScaleAspectFit];
        [imageV setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:imageV];
        self.imgIcon = imageV;

        // 标题
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, 4, SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 25)];
        label.numberOfLines = 0;
        if (SCREEN_WIDTH == 320) {
           label.font = [UIFont systemFontOfSize:15];
        }else{
           label.font = [UIFont systemFontOfSize:16];
        }
        [self.contentView addSubview:label];
        self.lblTitle = label;

        // 描述
        UILabel *scrL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(label.frame), SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 40)];
        scrL.numberOfLines = 0;
        scrL.font = [UIFont systemFontOfSize:10];
        scrL.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:scrL];
        self.lblDescription = scrL;

        // 浏览
        CGFloat x = SCREEN_WIDTH-5-160;
        CGFloat y = CGRectGetMaxY(imageV.frame)-20;
        CGFloat w = 160;
        CGFloat h = 22;
        UILabel *replyL = [[UILabel alloc]init];
        replyL.frame = CGRectMake(x, y, w, h);
        replyL.textAlignment = NSTextAlignmentCenter;
        replyL.font = [UIFont systemFontOfSize:20];
        replyL.textColor = [UIColor redColor];
        [self.contentView addSubview:replyL];
        self.lblViews = replyL;
        
        // TIME
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(imageV.frame)-11, 130, 12)];
        timeL.font = [UIFont systemFontOfSize:10];
        timeL.textColor = [UIColor systemYellowColor];
        [self.contentView addSubview:timeL];
        self.lblCreate = timeL;
        
//        // 作者
//        UILabel *aL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-50, 10, 50, 20)];
//        aL.font = [UIFont systemFontOfSize:15];
//        aL.textColor = [UIColor greenColor];
//        [self.contentView addSubview:aL];
//        self.lblAuthor = aL;
        
        // 收藏
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-30, 5, 30, 30)];
        [btn addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        self.btnLike = btn;
    }
    return self;
}


// set datamodel
- (void)setDataModel:(GirlData *)dataModel{
    _dataModel = dataModel;
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.dataModel.images[0]] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    
    self.lblTitle.text=self.dataModel.title;
    self.lblDescription.text=self.dataModel.desc;
    self.lblViews.text= [NSString stringWithFormat:@"人气：%@",self.dataModel.views];
    self.lblAuthor.text=self.dataModel.author;
    self.lblCreate.text=self.dataModel.createdAt;
    
    [self initBtn];
}

-(void)initBtn{
    if([[DataForFMDB sharedDataBase]checkFavorite:self.dataModel.type urlPath:self.dataModel.url]){
        [self.btnLike setImage:[UIImage imageNamed: @"like"] forState:UIControlStateNormal];
        self.isLike = YES;
    }
    else{
        [self.btnLike setImage:[UIImage imageNamed: @"dislike"] forState:UIControlStateNormal];
        self.isLike = NO;
    }
}

-(void)changeBtn{
    if(self.isLike){
        [[DataForFMDB sharedDataBase]deleteFavorite:self.dataModel.type urlPath:self.dataModel.url];
        [self.btnLike setImage:[UIImage imageNamed: @"dislike"] forState:UIControlStateNormal];
        self.isLike = NO;
    }
    else{
        [[DataForFMDB sharedDataBase]addFavorite:self.dataModel.type urlPath:self.dataModel.url title:self.dataModel.title];
        [self.btnLike setImage:[UIImage imageNamed: @"like"] forState:UIControlStateNormal];
        self.isLike = YES;
    }
}

@end
