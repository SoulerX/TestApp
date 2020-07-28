//
//  AppDelegate.h
//  TestApp
//
//  Created by xuzhiwei on 2020/7/27.
//  Copyright © 2020 netease. All rights reserved.
//

#import "JZLoadingViewPacket.h"

@interface JZLoadingViewPacket ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;


//控制显示后再隐藏的时间间隔>=1秒，提高用户体验
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isUseHiden;

@end

@implementation JZLoadingViewPacket


- (void)showWithTitle:(NSString *)title result:(RequestResult)result  {
    _isShow = NO;
    _isUseHiden = NO;
    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.text = title;

    if (result == RequestLoading) {
        self.imageView.image = [UIImage imageNamed:@"rotationImage"];
    }else if (result == RequestSuccess) {
        self.imageView.image = [UIImage imageNamed:@"requestSuccess"];
    }else if (result == RequestFaild) {
        self.imageView.image = [UIImage imageNamed:@"networkFaild"];
    }

    [self.imageView.layer removeAllAnimations];
    if (result == RequestLoading) {

        self.bgView.hidden = YES;
        self.imageView.hidden = YES;
        self.titleLabel.hidden = YES;
        [self performSelector:@selector(jz_show) withObject:nil afterDelay:0.5];
        
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //设置动画完成后保持原状
        animation1.fillMode = kCAFillModeForwards;
        animation1.removedOnCompletion = NO;
        //值
        animation1.fromValue = [NSNumber numberWithFloat:1.0];
        animation1.toValue = [NSNumber numberWithFloat:0];
        animation1.duration = 1.2;


        NSString *keyPath = @"transform.rotation.z";
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:keyPath];
        animation2.fillMode = kCAFillModeForwards;
        animation2.removedOnCompletion = NO;
        //值
        animation2.fromValue = [NSNumber numberWithFloat:0];
        animation2.toValue = [NSNumber numberWithFloat:1.5*M_PI];
        animation2.duration = 1.2;

        CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
        groupAnnimation.duration = 1.5;
        groupAnnimation.repeatCount = MAXFLOAT;
        groupAnnimation.animations = @[animation1, animation2];

        groupAnnimation.fillMode = kCAFillModeForwards;
        groupAnnimation.removedOnCompletion = NO;
        [self.imageView.layer addAnimation:groupAnnimation forKey:@"group"];
    }else {
        self.bgView.hidden = NO;
        self.imageView.hidden = NO;
        self.titleLabel.hidden = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(jz_hide) withObject:nil afterDelay:1.5];
    }

    [self sendSubviewToBack:self.bgView];
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)jz_show {
    self.hidden = NO;
    self.bgView.hidden = NO;
    self.imageView.hidden = NO;
    self.titleLabel.hidden = NO;
    _isShow = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //隐藏距离显示的时间间隔<1秒,则jz_hide不隐藏，这里才隐藏
        if (self.isUseHiden) {
            self.hidden = YES;
            self.bgView.hidden = YES;
            self.imageView.hidden = YES;
            self.titleLabel.hidden = YES;
        }
        self.isUseHiden = NO;
        self.isShow = NO;
    });
}

- (void)jz_hide {
    _isUseHiden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //距离显示的时间间隔>=1秒，执行隐藏
    if (!_isShow) {
        self.hidden = YES;
        self.bgView.hidden = YES;
        self.imageView.hidden = YES;
        self.titleLabel.hidden = YES;
    } else {
        
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _bgView.layer.cornerRadius = 5;
        [self addSubview:_bgView];
        
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-20];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:20];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100];
        [self addConstraint:constraint];
        
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:25];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15];
        [self addConstraint:constraint];
        
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:40];
        [self addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
        [self addConstraint:constraint];

    }
    return _imageView;
}

+ (JZLoadingViewPacket *)shareInstance {
    static JZLoadingViewPacket *loading = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loading = [[JZLoadingViewPacket alloc] init];
    });
    return loading;
}

+ (void)showWithTitle:(NSString *)title result:(RequestResult)result addToView:(UIView *)selfView {
    JZLoadingViewPacket *loading = [self shareInstance];
    [selfView addSubview:loading];
    
    loading.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:loading attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [selfView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:loading attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [selfView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:loading attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [selfView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:loading attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [selfView addConstraint:constraint];
    
    [loading showWithTitle:title result:result];
}


@end
