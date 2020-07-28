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

@interface FavoriteViewController ()

@property(nonatomic, strong)NSMutableDictionary *countDict;
@property(nonatomic, strong)UITableView *tableView;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的收藏";
    
    [self readData];
    
    [self initButton];
}

-(void)readData{
    
     [self.countDict setValue:@"1" forKey:@"girl"];

     [self.countDict setValue:@"2" forKey:@"ios"];

     [self.countDict setValue:@"3" forKey:@"android"];
}

-(void)initButton{
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 90+20, (self.view.bounds.size.width), (self.view.bounds.size.height-90-80)/3)];
    [button1 setBackgroundImage: [UIImage imageNamed:@"girl.jpg"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(popGirlView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(button1.frame), CGRectGetMaxY(button1.frame)+30, 100, 30)];
    label1.text = self.countDict[@"girl"];
    [self.view addSubview:label1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(20, (self.view.bounds.size.height-90-80)/3+90+100, (self.view.bounds.size.width), (self.view.bounds.size.height-90-80)/3)];
    [button2 setBackgroundImage: [UIImage imageNamed:@"ios.jpg"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(popIosView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(20, (self.view.bounds.size.height-90-80)*2/3+90+180, (self.view.bounds.size.width), (self.view.bounds.size.height-90-80)/3)];
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
    
}

-(void)popAndroidView{
    
}


@end
