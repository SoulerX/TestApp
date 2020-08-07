//
//  FavoriteIosViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/29.
//  Copyright © 2020 netease. All rights reserved.
//

#import "FavoriteIosViewController.h"
#import "DataForFMDB.h"
#import "IosData.h"
#import "AddData.h"
#import "MJRefresh.h"
#import "IosTableViewCell.h"
#import "GirlDetailViewController.h"
#import "BaseEngine.h"
#import "JZLoadingViewPacket.h"

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)


@interface FavoriteIosViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , weak) UITableView * _Nullable tableView;

@property (nonatomic , assign) int page;
@property (nonatomic , assign) int count;

@property (nonatomic , strong) NSMutableArray * _Nullable dataArray;

- (void)loadData;
- (void)initTableView;

@end

@implementation FavoriteIosViewController

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
    
    self.title = @"【收藏 --- iOS】";

    [self initTableView];
}

#pragma mark- 加载数据
- (void) loadData{
    [JZLoadingViewPacket showWithTitle:@"加载中" result:RequestLoading addToView:self.view];
    // DB Path: /Users/xuzhiwei/Library/Developer/CoreSimulator/Devices/68D4E580-9567-4E66-8D78-1D7062C731FF/data/Containers/Data/Application/B38E1F14-04A2-4213-A4C0-94EFF89A778F/Documents/TestApp/Farorite.db
    NSMutableArray *dataarray = [[DataForFMDB sharedDataBase]getFavorite:@"iOS"];

    for(int i=0;i<dataarray.count;i++){
        
        IosData *tempData = [IosData new];
        
        AddData *add = [AddData new];
        
        add = dataarray[i];
        
        tempData.url = add.url;

        tempData.title = add.title;

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
    
}

- (void) initTableView{
    extern NSString *currentPlatform;
    
    CGFloat x;
    CGFloat y;
    CGFloat w;
    CGFloat h;
    
    if([currentPlatform isEqualToString:@"x86_64"]||[currentPlatform isEqualToString:@"iPhone9,1"])
    {
        x=5;
        y=54;
        w=[UIScreen mainScreen].bounds.size.width-10;
        h=[UIScreen mainScreen].bounds.size.height-54;
    }else{
        x=5;
        y=88;
        w=[UIScreen mainScreen].bounds.size.width-10;
        h=[UIScreen mainScreen].bounds.size.height-88;
    }
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    
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
}

- (void) headerClick {
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


#pragma mark- 代理 UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"self.dataArray.count:%ld",self.dataArray.count);

    return self.dataArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IosCell"];
    
    if (cell == nil) {
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IosCell"];
    }
    
    NSLog(@"indexPath.row:%ld",indexPath.row);
    
    cell.dataModel = self.dataArray[indexPath.row];
    
    NSLog(@"%ld",self.dataArray.count);
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IosData *data = self.dataArray[indexPath.row];
    
    GirlDetailViewController *detail = [[GirlDetailViewController alloc]init];
    
    detail.url = data.url;
    detail.title = data.title;
    detail.type = data.type;
        
    [self.navigationController pushViewController:detail animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //第二组可以左滑删除
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}
 
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
 
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            IosData *data = self.dataArray[indexPath.row];
            
            [[DataForFMDB sharedDataBase]deleteFavorite:@"iOS" urlPath:data.url];
            
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
 
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end

