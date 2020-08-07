//
//  IosViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/23.
//  Copyright © 2020 netease. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "IosViewController.h"
#import "IosData.h"
#import "MJRefresh.h"
#import "IosTableViewCell.h"
#import "GirlDetailViewController.h"
#import "BaseEngine.h"
#import "JZLoadingViewPacket.h"


#import <SDImageCache.h>

#import <NSObject+YYModel.h>



@interface IosViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , weak) UITableView * tableView;

@property (nonatomic , assign) int page;
@property (nonatomic , assign) int count;

@property (nonatomic , strong) NSMutableArray * dataArray;

- (void)loadData;
- (void)initTableView;

@end

@implementation IosViewController

- (void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

// 懒加载
- (NSMutableArray *) dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    
    self.count = 10;
    
    self.title = @"【专题 —— iOS】";

    [self initTableView];
    
    [self addTopButton];
}

#pragma mark- 加载数据
// 初始化 tableview
- (void) initTableView{
    extern NSString *currentPlatform;
    
    CGFloat x;
    CGFloat y;
    CGFloat w;
    CGFloat h;
    
    if([currentPlatform isEqualToString:@"x86_64"]||[currentPlatform isEqualToString:@"iPhone9,1"])
    {
        x=0;
        y=54;
        w=[UIScreen mainScreen].bounds.size.width;
        h=[UIScreen mainScreen].bounds.size.height-54;
    }else{
        x=0;
        y=88;
        w=[UIScreen mainScreen].bounds.size.width;
        h=[UIScreen mainScreen].bounds.size.height-88;
    }
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, w+10, (w+10)*0.55)];
    
    [imageview  setImage:[UIImage imageNamed:@"ios.jpg"]];
    
    [self.view addSubview:imageview];
    
    UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(x, y+(w+10)*0.55, w, h-(w+10)*0.55)];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
    self.tableView = tableview;
    
    [self.tableView registerClass:[IosTableViewCell class] forCellReuseIdentifier:@"IosCell"];
    
    // 添加头部的下拉刷新
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tableView.mj_header = header;
    self.tableView.mj_header.backgroundColor = [UIColor yellowColor];
    [self.tableView.mj_header beginRefreshing];
    
    // 添加底部的上拉加载
    MJRefreshBackNormalFooter *footer = [[MJRefreshBackNormalFooter alloc] init];
    [footer setRefreshingTarget:self refreshingAction:@selector(footerClick)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.backgroundColor = [UIColor yellowColor];
}

// 头部的下拉刷新触发事件
- (void)headerClick {
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    [JZLoadingViewPacket showWithTitle:@"加载中" result:RequestLoading addToView:self.view];
    
    self.page = 1;
    
    if(self.dataArray.count != 0)
    {
        [self.dataArray removeAllObjects];
    }
    [self loadData];
    
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.tableView.mj_header endRefreshing];
}

// 底部的上拉加载触发事件
- (void)footerClick {
    // 可在此处实现上拉加载时要执行的代码
    // ......
    [JZLoadingViewPacket showWithTitle:@"加载中" result:RequestLoading addToView:self.view];
    
    if(self.page < 5)
        self.page++;
    else
        return;
    
    [self loadData];
    
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
}

- (void) loadData{
    NSTimer *timer = [NSTimer timerWithTimeInterval:6 target:self selector:@selector(popFaild) userInfo:nil repeats:YES];
     
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    __weak IosViewController *weakSelf = self;
    [BaseEngine requestUrl:[NSString stringWithFormat:@"https://gank.io/api/v2/data/category/GanHuo/type/iOS/page/%d/count/%d",self.page,self.count] completionHandler:^(NSArray * _Nullable dataarray) {
        
        [timer setFireDate:[NSDate distantFuture]];
        
        for(int i=0;i<dataarray.count;i++){
            @autoreleasepool {
                IosData *tempData = [IosData yy_modelWithDictionary:dataarray[i]];
                [weakSelf.dataArray addObject:tempData];
            }
        }
        
        // 等待主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tableView.rowHeight = UITableViewAutomaticDimension;
 
            NSLog(@"%ld",weakSelf.dataArray.count);
            
            [[SDImageCache sharedImageCache] clearMemory];
            
            [weakSelf.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JZLoadingViewPacket showWithTitle:@"成功" result:RequestSuccess addToView:weakSelf.view];
            });
        });
    }];
}

- (void)popFaild{
    [JZLoadingViewPacket showWithTitle:@"失败" result:RequestFaild addToView:self.view];
}

- (void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark- 代理 UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"self.dataArray.count:%ld",self.dataArray.count);

    return self.dataArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static int count = 1;
    @autoreleasepool {
        IosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IosCell"];
        
        if (cell == nil) {
            NSLog(@"------------------------> %d",count);
            count++;
            cell = [[IosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IosCell"];
        }
        
        NSLog(@"indexPath.row:%ld",indexPath.row);
        
        cell.dataModel = self.dataArray[indexPath.row];
        
        NSLog(@"%ld",self.dataArray.count);
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    extern NSString *currentPlatform;
    
    CGFloat ratio = 1.0;
    
    if([currentPlatform isEqualToString:@"x86_64"]||[currentPlatform isEqualToString:@"iPhone9,1"])
        ratio = 0.9;
    
    return 200;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @autoreleasepool {
        IosData *data = self.dataArray[indexPath.row];
        
        GirlDetailViewController *detail = [[GirlDetailViewController alloc]init];
        
        detail.url = data.url;
        detail.title = data.title;
        detail.type = data.type;
            
        [self.navigationController pushViewController:detail animated:YES];
    }
}


#pragma mark- 添加按钮 & 触发事件
// 添加置顶按钮
- (void) addTopButton{
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [addButton setFrame:CGRectMake(SCREEN_WIDTH-40,SCREEN_HEIGHT-60, 30, 45)];
   
    [addButton addTarget:self action:@selector(toTop) forControlEvents:(UIControlEventTouchUpInside)];
 
    // 按钮的subview  起点为addButton的origin
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    // 调用这个方法返回一个image  可以封装为一个方法使用
    UIImage *image = [self imageByApplyingAlpha:0.1 image:[UIImage imageNamed:@"zhiding.jpeg"]];
    
    view.image = image;
    
    // view的subview 起点为view的origin
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1,30,30,12)];

    label.text = @"TOP";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];

    [view addSubview:label];
    
    [addButton addSubview:view];
    
    [self.view addSubview:addButton];
}

// 置顶
- (void) toTop{
    NSLog(@"置顶");

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 设置图片透明度 CGFloat/透明度  UIImage/图片   return/UIImage
- (UIImage *) imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
