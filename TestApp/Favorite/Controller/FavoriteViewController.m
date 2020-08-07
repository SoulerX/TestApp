//
//  FavoriteViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "FavoriteViewController.h"
#import "GirlViewController.h"
#import "IosViewController.h"
#import "AndroidViewController.h"

#import "FavoriteGirlViewController.h"
#import "FavoriteIosViewController.h"
#import "FavoriteAndroidViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的收藏";

    self.view.backgroundColor = [UIColor grayColor];
    [self.view setFrame:[UIScreen mainScreen].bounds];
    
    [self initButton];
}

-(void)initButton{
    extern NSString *currentPlatform;
    
    CGFloat navItemHeight;
    
    if([currentPlatform isEqualToString:@"x86_64"]||[currentPlatform isEqualToString:@"iPhone9,1"])
    {
        navItemHeight=54;
    }else
    {
        navItemHeight=88;
    }
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(10, navItemHeight+40, (self.view.bounds.size.width)-20, ((self.view.bounds.size.height)-navItemHeight-120)/3)];
    [button1 setBackgroundImage: [UIImage imageNamed:@"girl.jpg"] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 15;
    button1.layer.masksToBounds = YES;
    [button1 addTarget:self action:@selector(popGirlView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(10, ((self.view.bounds.size.height)-54-80)/3+navItemHeight+60, (self.view.bounds.size.width)-20, ((self.view.bounds.size.height)-navItemHeight-120)/3)];
    [button2 setBackgroundImage: [UIImage imageNamed:@"ios.jpg"] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 15;
    button2.layer.masksToBounds = YES;
    [button2 addTarget:self action:@selector(popIosView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(10, (self.view.bounds.size.height-54-80)*2/3+navItemHeight+80, (self.view.bounds.size.width)-20, ((self.view.bounds.size.height)-navItemHeight-120)/3)];
    [button3 setBackgroundImage: [UIImage imageNamed:@"android.jpg"] forState:UIControlStateNormal];
    button3.layer.cornerRadius = 15;
    button3.layer.masksToBounds = YES;
    [button3 addTarget:self action:@selector(popAndroidView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    
}

-(void)popGirlView{
    
    FavoriteGirlViewController *vc = [FavoriteGirlViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)popIosView{
    
    FavoriteIosViewController *vc = [FavoriteIosViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尚未开发，敬请期待" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"取消");
//    }];
//    [alertVC addAction:cancelAc];
//    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)popAndroidView{
    FavoriteAndroidViewController *vc = [FavoriteAndroidViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
//   UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尚未开发，敬请期待" preferredStyle:UIAlertControllerStyleAlert];
//     UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//         NSLog(@"取消");
//     }];
//    [alertVC addAction:cancelAc];
//    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
