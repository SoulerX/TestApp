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

    [self initButton];
}

-(void)initButton{
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 90+20+50, (self.view.bounds.size.width), (self.view.bounds.size.height-90-80)/3)];
    [button1 setBackgroundImage: [UIImage imageNamed:@"girl.jpg"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(popGirlView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(20, (self.view.bounds.size.height-90-80)/3+90+100+50, (self.view.bounds.size.width), (self.view.bounds.size.height-90-80)/3)];
    [button2 setBackgroundImage: [UIImage imageNamed:@"ios.jpg"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(popIosView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(20, (self.view.bounds.size.height-90-80)*2/3+90+180+50, (self.view.bounds.size.width), (self.view.bounds.size.height-90-80)/3)];
    [button3 setBackgroundImage: [UIImage imageNamed:@"android.jpg"] forState:UIControlStateNormal];
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
