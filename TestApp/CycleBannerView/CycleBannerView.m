//
//  CycleBannerView.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "CycleBannerView.h"
#import "UIImageView+WebCache.h"
#import "CycleBannerData.h"
#import "GirlDetailViewController.h"

@interface CycleBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation CycleBannerView


- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        [_mainScrollView setPagingEnabled:YES];
        [_mainScrollView setDelegate:self];
    }
    
    
    
    return _mainScrollView;
}


- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    
    
    
    return _leftImageView;
}

- (UIImageView *)midImageView
{
    if (!_midImageView) {
        _midImageView = [[UIImageView alloc] init];
        [_midImageView setBackgroundColor:[UIColor redColor]];
    }
    
    
    return _midImageView;
}


- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self.mainScrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.mainScrollView];
        
        [self.leftImageView setFrame:CGRectMake(0, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.width)];
        [self.mainScrollView addSubview:self.leftImageView];
        
        [self.midImageView setFrame:CGRectMake(self.mainScrollView.bounds.size.width, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.width)];
        [self.mainScrollView addSubview:self.midImageView];
        
        [self.rightImageView setFrame:CGRectMake(self.mainScrollView.bounds.size.width*2, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.width)];
        [self.mainScrollView addSubview:self.rightImageView];
        
        [self.mainScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.mainScrollView.bounds)*3, CGRectGetHeight(self.mainScrollView.bounds))];
        [self scrollCenter];
        
    }
    return self;
}


- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    if (duration > 0.0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(changeNext) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:duration]];
    }
}


- (void)changeNext
{
    [self.mainScrollView setContentOffset:CGPointMake(2*CGRectGetWidth(self.mainScrollView.bounds), 0) animated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.duration]];
    
}


- (void)setImageArray:(NSMutableArray *)imageArray
{
    if (imageArray.count > 0) {
        _imageArray = imageArray;
        
        self.index = 0;
        
        [self scrollCenter];
        [self reloadIndex];
            
        if (imageArray.count > 1)
        {
            
        }
        else
        {
            [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.bounds.size.width, 0)];
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self reloadIndex];
}



//滑到中心，切记不能调用该动画，否则会触发代理
- (void)scrollCenter
{
    [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.mainScrollView.bounds), 0)];
    if (self.indexBack) {
        self.indexBack(self.index);
    }
}



//计算页数
- (void)reloadIndex
{
    if (self.imageArray && self.imageArray.count > 0)
    {
        CGFloat pointX = self.mainScrollView.contentOffset.x;

        //此处的value用于边缘判断，当imageview距离两边间距小于1时，触发偏移
        CGFloat Value = 0.2f;

        if (pointX > 2 * CGRectGetWidth(self.mainScrollView.bounds) - Value) {
            self.index = (self.index + 1) % self.imageArray.count;
            
        } else if (pointX < Value) {
            self.index = (self.index + self.imageArray.count - 1) % self.imageArray.count;
        }

    }
    
}


- (void)setIndex:(NSInteger)index{
    _index = index;
    
    NSInteger totalCount = self.imageArray.count;
    NSInteger leftIndex = (self.index+totalCount-1)%totalCount;
    NSInteger rightIndex = (self.index+1)%totalCount;

    CycleBannerData *data1 = [CycleBannerData new];
    data1 = self.imageArray[leftIndex];
    
    CycleBannerData *data2 = [CycleBannerData new];
    data2 = self.imageArray[self.index];
    
    CycleBannerData *data3 = [CycleBannerData new];
    data3 = self.imageArray[rightIndex];
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:data1.image] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    
    
    [self.midImageView sd_setImageWithURL:[NSURL URLWithString:data2.image] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];
    
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:data3.image] placeholderImage:[UIImage imageNamed:@"none.jpeg"]];

    [self scrollCenter];
}

-(void)enter{
    
    
    NSLog(@"点击了");
//    GirlDetailViewController *vc = [GirlDetailViewController new];
//
//    [self.navigationController pushViewController:vc animated:YES];
}

@end

