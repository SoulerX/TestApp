//
//  StartViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/28.
//  Copyright © 2020 netease. All rights reserved.
//

#import "StartViewController.h"
#import "ViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [view setImage:[UIImage imageNamed:@"cover.jpeg"]];
    
    [self.view addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[self.view.subviews lastObject]removeFromSuperview];
        
        ViewController *vc = [ViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    });
}

@end
