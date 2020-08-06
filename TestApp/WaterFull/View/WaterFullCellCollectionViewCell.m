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
#import "GirlDetailViewController.h"
#import "DataForFMDB.h"
#import <SDAnimatedImageView.h>

@interface WaterFullCellCollectionViewCell()

@property (weak, nonatomic) IBOutlet SDAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (assign, nonatomic) BOOL like;

@end

@implementation WaterFullCellCollectionViewCell


- (void)setWaterfull:(WaterFullData *)waterfull{
    _waterfull = waterfull;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:waterfull.images[0]] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.enterButton setFrame:CGRectMake(0, 0, 30, 30)];
    [self.enterButton addTarget:self action:@selector(enterCell) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [self.closeButton addTarget:self action:@selector(changeLike) forControlEvents:UIControlEventTouchUpInside];
    
    if([[DataForFMDB sharedDataBase]checkFavorite:@"Girl" urlPath:self.waterfull.images[0]])
    {
        NSLog(@"like");
        self.like = YES;
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
    }else{
        NSLog(@"dislike");
        self.like = NO;
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    }
    
    self.titleLabel.text = waterfull.title;

}

-(void)changeLike
{
    if(self.like)
    {
        NSLog(@"unlike");
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [[DataForFMDB sharedDataBase] deleteFavorite:@"Girl" urlPath:self.waterfull.images[0]];
        // TODO 刷新collectionView
    }
    else
    {
        NSLog(@"like");
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [[DataForFMDB sharedDataBase] addFavorite:@"Girl" urlPath:self.waterfull.images[0] title:self.waterfull.title];
    }
    self.like = !self.like;
}

-(void)enterCell{
    NSLog(@"enter");
    
    GirlDetailViewController *vc = [GirlDetailViewController new];
    
    vc.url=self.waterfull.images[0];
    vc.title=self.waterfull.title;
    vc.type = @"Girl";
    //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    vc.passingValue = ^(void){
        
    };
    
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

//找到父类界面
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
