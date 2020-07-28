//
//  GirlViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "GirlViewController.h"
#import "GirlTableViewCell.h"
#import "GirlData.h"
#import "GirlDetailViewController.h"
#import "MJRefresh.h"
#import "BaseEngine.h"
#import "JZLoadingViewPacket.h"


@interface GirlViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic , weak) UITableView * _Nullable tableView;

@property (nonatomic , assign) int page;
@property (nonatomic , assign) int count;

@property (nonatomic , strong) NSMutableArray * _Nullable dataArray;

- (void)loadData;
+ (void)requestUrl:(NSString*_Nullable) strurl completionHandler:(nonnull void (^)(NSArray * _Nullable))completionHandler;

- (void)initTableView;

@end

@implementation GirlViewController

// 懒加载
- (NSMutableArray *) dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

// 入口
- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.page = 1;
    
    self.count = 10;
    
    self.title = @"【专题 —— 妹纸】";
    
    [self addTopButton];
    
    [self initTableView];
    

}

#pragma mark- 加载数据
- (void) loadData{
    [JZLoadingViewPacket showWithTitle:@"加载中" result:RequestLoading addToView:self.view];
    
    [BaseEngine requestUrl:[NSString stringWithFormat:@"https://gank.io/api/v2/data/category/Girl/type/Girl/page/%d/count/%d",self.page,self.count] completionHandler:^(NSArray * _Nullable dataarray) {
        
        for(int i=0;i<dataarray.count;i++){
            
            GirlData *tempData = [GirlData new];
            
            for(id key in dataarray[i]){
                if([key isEqual:@"url"])
                    tempData.url = dataarray[i][key];
                else if([key isEqual:@"desc"])
                    tempData.desc = dataarray[i][key];
                else if([key isEqual:@"views"])
                    tempData.views = [NSString stringWithFormat:@"%@",dataarray[i][key]];
                else if([key isEqual:@"title"])
                    tempData.title = dataarray[i][key];
                else if([key isEqual:@"images"])
                    tempData.images = dataarray[i][key];
                else if([key isEqual:@"createdAt"])
                    tempData.createdAt = dataarray[i][key];
                else if([key isEqual:@"author"])
                    tempData.author = dataarray[i][key];
                else if([key isEqual:@"type"])
                    tempData.type = dataarray[i][key];
            }

            [self.dataArray addObject:tempData];
        }

      
        
        // 等待主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            //self.tableView.estimatedRowHeight=125;
            
            NSLog(@"%ld",self.dataArray.count);

            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /*
                 手动隐藏时一定要调用此接口
                 */
                //        [[JZLoadingViewPacket shareInstance] jz_hide];
                /*
                 调用加载完毕的接口时（如 RequestSuccess，RequestFaild），则会立即显示，并且在1.5秒后自动消失
                 */
                [JZLoadingViewPacket showWithTitle:@"成功" result:RequestSuccess addToView:self.view];
            });
        });
    }];
}

// 初始化 tableview
- (void) initTableView{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(5, 250, self.view.bounds.size.width+30, self.view.bounds.size.height+20)];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    
    [self.view addSubview:tableview];
    
    self.tableView = tableview;
    
    [self.tableView registerClass:[GirlTableViewCell class] forCellReuseIdentifier:@"GirlCell"];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 89, self.view.bounds.size.width+40, self.view.bounds.size.width*0.4)];
    
    [imageview  setImage:[UIImage imageNamed:@"girl.jpg"]];


    [self.view addSubview:imageview];
    
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
    
    self.page++;

    [self loadData];

    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark- 代理 UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"self.dataArray.count:%ld",self.dataArray.count);

    return self.dataArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GirlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GirlCell"];
    
    if (cell == nil) {
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GirlCell"];
    }
    
    NSLog(@"indexPath.row:%ld",indexPath.row);
    
    cell.dataModel = self.dataArray[indexPath.row];
    
    NSLog(@"%ld",self.dataArray.count);
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GirlData *data = self.dataArray[indexPath.row];
    
    GirlDetailViewController *detail = [[GirlDetailViewController alloc]init];
    
    detail.url = data.url;
    detail.title = data.title;
    detail.type = data.type;
        
    [self.navigationController pushViewController:detail animated:YES];
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

    //置顶方法一
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];


    //置顶方法二
//    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    
//    [[self.view.subviews lastObject]removeFromSuperview];
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

