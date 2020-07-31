//
//  AndroidTableViewCell.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//



#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)


#import "AndroidTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AndroidData.h"

@implementation AndroidTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // 图片
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(8, 8, 120, 100);
        [imageV setContentMode:UIViewContentModeScaleAspectFit];
        [imageV setBackgroundColor:[UIColor blackColor]];
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

        
        // 作者
        UILabel *aL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(label.frame), 150, 20)];
        aL.font = [UIFont systemFontOfSize:12];
        aL.textColor = [UIColor purpleColor];
        [self.contentView addSubview:aL];
        self.lblAuthor = aL;
        
        // 描述
        UILabel *scrL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(aL.frame), SCREEN_WIDTH-CGRectGetMaxX(imageV.frame)-20, 40)];
        scrL.numberOfLines = 0;
        scrL.font = [UIFont systemFontOfSize:10];
        scrL.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:scrL];
        self.lblDescription = scrL;

        // 浏览
        CGFloat x = SCREEN_WIDTH-5-100;
        CGFloat y = CGRectGetMaxY(imageV.frame)-20;
        CGFloat w = 100;
        CGFloat h = 22;
        UILabel *replyL = [[UILabel alloc]init];
        replyL.frame = CGRectMake(x, y, w, h);
        replyL.textAlignment = NSTextAlignmentCenter;
        replyL.font = [UIFont systemFontOfSize:15];
        replyL.textColor = [UIColor redColor];
        [self.contentView addSubview:replyL];
        self.lblViews = replyL;
        
        // TIME
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, CGRectGetMaxY(imageV.frame)-11, 130, 12)];
        timeL.font = [UIFont systemFontOfSize:10];
        timeL.textColor = [UIColor systemYellowColor];
        [self.contentView addSubview:timeL];
        self.lblCreate = timeL;
        

    }
    return self;
}

// set datamodel
- (void)setDataModel:(AndroidData *)dataModel{
    _dataModel = dataModel;
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.dataModel.images[0]] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    
    self.lblTitle.text=self.dataModel.title;
    self.lblDescription.text=self.dataModel.desc;
    self.lblViews.text= [NSString stringWithFormat:@"点击：%@",self.dataModel.views];
    self.lblAuthor.text=[NSString stringWithFormat:@"作者：%@",self.dataModel.author];
    self.lblCreate.text=self.dataModel.createdAt;
}

@end
