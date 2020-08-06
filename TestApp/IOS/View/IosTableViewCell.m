//
//  IosTableViewCell.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "IosTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation IosTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // 标题
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-20, 20)];
        //        label.numberOfLines = 0;
        if (SCREEN_WIDTH == 320) {
            label.font = [UIFont systemFontOfSize:15];
        }else{
            label.font = [UIFont systemFontOfSize:16];
        }
        [self.contentView addSubview:label];
        self.lblTitle = label;
        
        
        // 作者
        CGFloat x = SCREEN_WIDTH-5-150;
        CGFloat y = 5;
        CGFloat w = 150;
        CGFloat h = 20;
        UILabel *aL = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        aL.font = [UIFont systemFontOfSize:15];
        aL.textColor = [UIColor purpleColor];
        [self.contentView addSubview:aL];
        self.lblAuthor = aL;
        
        
        // 图片1
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(10, 30, (SCREEN_WIDTH-40)/3, (SCREEN_WIDTH-40)/3*0.8);
        [imageV setContentMode:UIViewContentModeScaleAspectFit];
        [imageV setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:imageV];
        self.imgIcon1 = imageV;
        
        // 图片2
        UIImageView *imageV2 = [[UIImageView alloc]init];
        imageV2.frame = CGRectMake(20+(SCREEN_WIDTH-40)/3, 30, (SCREEN_WIDTH-40)/3, (SCREEN_WIDTH-40)/3*0.8);
        [imageV2 setContentMode:UIViewContentModeScaleAspectFit];
        [imageV2 setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:imageV2];
        self.imgIcon2 = imageV2;

        // 图片3
        UIImageView *imageV3 = [[UIImageView alloc]init];
        imageV3.frame = CGRectMake(30+(SCREEN_WIDTH-40)*2/3, 30, (SCREEN_WIDTH-40)/3, (SCREEN_WIDTH-40)/3*0.8);
        [imageV3 setContentMode:UIViewContentModeScaleAspectFit];
        [imageV3 setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:imageV3];
        self.imgIcon3 = imageV3;

        // 描述
        UILabel *scrL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageV.frame), CGRectGetMaxY(imageV.frame)+5, SCREEN_WIDTH-20, 40)];
        scrL.numberOfLines = 0;
        scrL.font = [UIFont systemFontOfSize:8];
        scrL.textColor = [UIColor blackColor];
        [self.contentView addSubview:scrL];
        self.lblDescription = scrL;
        
        // TIME
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageV.frame), 180, 200, 18)];
        timeL.font = [UIFont systemFontOfSize:15];
        timeL.textColor = [UIColor systemYellowColor];
        [self.contentView addSubview:timeL];
        self.lblCreate = timeL;
        
        // 浏览
        UIImageView *viewsImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeL.frame)+40, CGRectGetMinY(timeL.frame)+3, 12, 12)];
        [viewsImage setImage:[UIImage imageNamed:@"icon_预览"]];
        self.viewsIcon = viewsImage;
        [self.contentView addSubview:self.viewsIcon];
        
        UILabel *replyL = [[UILabel alloc]init];
        replyL.frame = CGRectMake(CGRectGetMaxX(viewsImage.frame), CGRectGetMinY(timeL.frame)-1, 35, 20);
        replyL.textAlignment = NSTextAlignmentCenter;
        replyL.font = [UIFont systemFontOfSize:8];
        replyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:replyL];
        self.lblViews = replyL;
        
        // 评论
        UIImageView *commentImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(replyL.frame)+5, CGRectGetMinY(timeL.frame)+3, 12, 12)];
        [commentImage setImage:[UIImage imageNamed:@"评论"]];
        self.commentIcon = commentImage;
        [self.contentView addSubview:self.commentIcon];
        
        UILabel *replyL2 = [[UILabel alloc]init];
        replyL2.frame = CGRectMake(CGRectGetMaxX(commentImage.frame), CGRectGetMinY(timeL.frame)-1, 35, 20);
        replyL2.textAlignment = NSTextAlignmentCenter;
        replyL2.font = [UIFont systemFontOfSize:8];
        replyL2.textColor = [UIColor grayColor];
        [self.contentView addSubview:replyL2];
        self.lblComment = replyL2;
        
        
        // 点赞
        UIButton *likeButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(replyL2.frame)+5, CGRectGetMinY(timeL.frame)+3, 12, 12)];
        [likeButton setImage:[UIImage imageNamed:@"未点赞"] forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
        
        self.likeButton = likeButton;
        [self.contentView addSubview:self.likeButton];

        UILabel *replyL3 = [[UILabel alloc]init];
        replyL3.frame = CGRectMake(CGRectGetMaxX(likeButton.frame), CGRectGetMinY(timeL.frame)-1, 35, 20);
        replyL3.textAlignment = NSTextAlignmentCenter;
        replyL3.font = [UIFont systemFontOfSize:8];
        replyL3.textColor = [UIColor grayColor];
        [self.contentView addSubview:replyL3];
        self.lblLike = replyL3;
        
        self.status = NO;
    }
    return self;
}

-(void)changeIcon{
    if(self.status)
    {
        [self.likeButton setImage:[UIImage imageNamed:@"未点赞"] forState:UIControlStateNormal];
        self.status = !self.status;
        NSLog(@"未点赞");
    }
    else
    {
        [self.likeButton setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateNormal];
        self.status = !self.status;
        NSLog(@"已点赞");
    }
    
}


// set datamodel
- (void)setDataModel:(IosData *)dataModel{
    _dataModel = dataModel;
    
//    if(self.dataModel.images.count>0)
//        [self.imgIcon1 sd_setImageWithURL:[NSURL URLWithString:@"http://gank.io/images/f0c192e3e335400db8a709a07a891b2e"] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
//    else
//        [self.imgIcon1 setImage:[UIImage imageNamed:@"none.jpeg"]];
//
//    if(self.dataModel.images.count>1)
//       [self.imgIcon2 sd_setImageWithURL:[NSURL URLWithString:@"http://gank.io/images/f0c192e3e335400db8a709a07a891b2e"] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
//    else
//       [self.imgIcon2 setImage:[UIImage imageNamed:@"none.jpeg"]];
//
//    if(self.dataModel.images.count>2)
//       [self.imgIcon3 sd_setImageWithURL:[NSURL URLWithString:@"http://gank.io/images/f0c192e3e335400db8a709a07a891b2e"] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
//    else
//       [self.imgIcon3 setImage:[UIImage imageNamed:@"none.jpeg"]];
    
    if(self.dataModel.images.count>0)
    {
        [self.imgIcon1 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.images[0]]
                         placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
       
    }
    
    else
        [self.imgIcon1 setImage:[UIImage imageNamed:@"none.jpeg"]];
    
    if(self.dataModel.images.count>1)
    {[self.imgIcon2 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.images[1]] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    
    }
    else
       [self.imgIcon2 setImage:[UIImage imageNamed:@"none.jpeg"]];

    if(self.dataModel.images.count>2)
    {[self.imgIcon3 sd_setImageWithURL:[NSURL URLWithString:self.dataModel.images[2]] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
   
    }
    else
       [self.imgIcon3 setImage:[UIImage imageNamed:@"none.jpeg"]];
    
    self.lblTitle.text=[NSString stringWithFormat:@"Theme：%@",self.dataModel.title];
    self.lblDescription.text=self.dataModel.desc;
    self.lblViews.text= [NSString stringWithFormat:@"%@",self.dataModel.views];
    self.lblAuthor.text=[NSString stringWithFormat:@"作者：%@",self.dataModel.author];
    self.lblCreate.text=self.dataModel.createdAt;
    self.lblComment.text = @"666";
    self.lblLike.text=@"520";
}


@end
