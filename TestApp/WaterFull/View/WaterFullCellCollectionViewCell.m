//
//  WaterFullCellCollectionViewCell.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/24.
//  Copyright © 2020 netease. All rights reserved.
//

#import "WaterFullCellCollectionViewCell.h"
#import "WaterFullData.h"
#import "UIImageView+WebCache.h"

@interface WaterFullCellCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation WaterFullCellCollectionViewCell


- (void)setWaterfull:(WaterFullData *)waterfull{
    
    _waterfull = waterfull;
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:waterfull.image[0]] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    
    [self.closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [self.closeButton addTarget:self action:@selector(closeCell) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = waterfull.title;

}

-(void)closeCell{
    NSLog(@"close");
}

@end
