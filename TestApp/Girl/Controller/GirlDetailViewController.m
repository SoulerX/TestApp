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
#import "JZLoadingViewPacket.h"
#import <Photos/Photos.h>

@implementation GirlDetailViewController

- (void)dealloc{
    self.view = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initWebView]; // 3~4s
    [self initWebKit]; // 4~5s
    
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
    
    if([self.type isEqualToString:@"Girl"])
    {
        [self setDownloadButton:@"下载"];
        NSLog(@"进入");
    }
}

-(void)initWebKit{
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width+40, self.view.bounds.size.height+100) configuration:webConfiguration];
    
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
        {
            NSLog(@"test block");
            self.passingValue();
        }
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

- (void)setDownloadButton:(NSString*)download{
    UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-5,self.view.bounds.size.height+180,30, 30)];
    
    [Button setBackgroundImage:[UIImage imageNamed:download] forState:UIControlStateNormal];
    
    [Button addTarget:self action:@selector(savePhotosToAppPhotoCollection) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:Button];
}

-(void)savePhotosToAppPhotoCollection{

   // 同步操作保存到【相机胶卷】
   __block PHObjectPlaceholder *placeholderForCreatedAsset;
    
    NSError *error = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.url]];
        
        UIImage *image = [UIImage imageWithData:data];
        
        placeholderForCreatedAsset = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
        
    } error:&error];
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JZLoadingViewPacket showWithTitle:@"保存图片失败" result:RequestFaild addToView:self.view];
        });
        return;
    }
    
    // 创建自定义相册 获得自定义相册
    PHAssetCollection *createCollection = [self createPHAssetCollection];
    
    if (createCollection == nil) {
        [JZLoadingViewPacket showWithTitle:@"创建相册失败" result:RequestFaild addToView:self.view];
        return;
    }
    
    // 添加刚才保存的图片到【自定义相册】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 获取自定义对象的操作对象
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createCollection];
        // 把图片插入到自定义相册的第一个位置
        [request insertAssets:@[placeholderForCreatedAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
    
    if (!error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              [JZLoadingViewPacket showWithTitle:@"保存图片成功" result:RequestSuccess addToView:self.view];
          });
          return;
      }
}

- (PHAssetCollection*)createPHAssetCollection{
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection *appCollection = nil;
    
    for (PHAssetCollection *collection in collections) {
        
        NSLog(@"相册的名字=%@",collection.localizedTitle);
        
        if ([collection.localizedTitle isEqualToString:@"TestApp"]) {
            appCollection = collection;
            break;
        }
    }
    
    if (appCollection == nil) {
        
        NSError *error = nil;
        
        __block NSString *createCollectionID = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            
            // 获取app的名字
            NSString *appName = @"TestApp";
            // 获取相册的唯一标识符
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;
            
        } error:&error];
        
        if (error) {
            return nil;
        }
    }
    
    // 相册一定存在
    NSLog(@"相册已经存在");
    
    return appCollection;
}

- (void)downloadImageSystem{
    
    if(self.url)
    {
        // 异步
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.url]];

            UIImage *image = [UIImage imageWithData:data];
            
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (!error){
                NSLog(@"写入本地成功");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JZLoadingViewPacket showWithTitle:@"成功" result:RequestSuccess addToView:self.view];
                });
                
            }else{
                NSLog(@"写入本地失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JZLoadingViewPacket showWithTitle:@"失败" result:RequestFaild addToView:self.view];
                });
            }
        }];
        
        
        // 同步
//        NSError *error = nil;
//
//        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//
//           NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.url]];
//
//           UIImage *image = [UIImage imageWithData:data];
//
//           [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//
//        } error:&error];
//
//        if (!error){
//            NSLog(@"写入本地成功");
//            [JZLoadingViewPacket showWithTitle:@"成功" result:RequestSuccess addToView:self.view];
//        }else{
//            NSLog(@"写入本地失败");
//            [JZLoadingViewPacket showWithTitle:@"失败" result:RequestFaild addToView:self.view];
//        }
        
    }
}

//通过当前视图获取父视图的控制器
- (UIViewController *)GetSuperViewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[GirlDetailViewController class]]) {
            return (GirlDetailViewController *)nextResponder;
        }
    }
    return nil;
}

@end
