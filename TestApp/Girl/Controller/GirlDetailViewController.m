//
//  GirlDetailViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#import "GirlDetailViewController.h"
#import "DataForFMDB.h"
#import <WebKit/WebKit.h>

@implementation GirlDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWebView]; // 3~4s
//    [self initWebKit]; // 4~5s
    
    if(self.type == nil)
        return;
    
    if([[DataForFMDB sharedDataBase]checkFavorite:self.type urlPath:self.url])
    {
        NSLog(@"like");
        self.like = YES;
        [self setLikeButton:@"like"];
    }else{
        NSLog(@"dislike");
        self.like = NO;
        [self setLikeButton:@"dislike"];
    }
}

-(void)initWebKit{
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    
    _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
    
    NSURL *url = [NSURL URLWithString:_url];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.view addSubview:_webView];
    
    [_webView loadRequest:request];
}

-(void)initWebView
{
    NSURL *url = [NSURL URLWithString:_url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *webview = [[UIWebView alloc]init];
    
    [webview setFrame:CGRectMake(0, 88, self.view.bounds.size.width+40, self.view.bounds.size.height+100)];
    
    [self.view addSubview:webview];
    
    [webview loadRequest:request];
    
 
}

- (void)setLikeButton:(NSString*)isLike{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [Button setBackgroundImage:[UIImage imageNamed:isLike] forState:UIControlStateNormal];
    
    [Button addTarget:self action:@selector(changeLike) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:Button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)changeLike
{
    if(self.like)
    {
        NSLog(@"unlike");
        [self setLikeButton:@"dislike"];
        [[DataForFMDB sharedDataBase] deleteFavorite:self.type urlPath:self.url];
        if([self.type isEqual:@"Girl"])
            self.passingValue();
    }
    else
    {
        NSLog(@"like");
        [self setLikeButton:@"like"];
        [[DataForFMDB sharedDataBase] addFavorite:self.type urlPath:self.url title:self.title];
        if([self.type isEqual:@"Girl"])
            self.passingValue();
    }
    self.like = !self.like;
}



@end
