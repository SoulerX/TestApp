//
//  FavoriteAndroidViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/29.
//  Copyright © 2020 netease. All rights reserved.
//

#import "FavoriteAndroidViewController.h"

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "FavoriteAndroidViewController.h"
#import "AndroidTableViewCell.h"
#import "AndroidData.h"
#import "GirlDetailViewController.h"
#import "MJRefresh.h"
#import "BaseEngine.h"
#import "JZLoadingViewPacket.h"
#import "AddData.h"
#import "DataForFMDB.h"

@interface FavoriteAndroidViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , weak) UITableView * _Nullable tableView;
@property (nonatomic , strong) NSMutableArray * _Nullable dataArray;

- (void)loadData;
- (void)initTableView;

@end

@implementation FavoriteAndroidViewController

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

// 入口
- (void) viewDidLoad {
    [super viewDidLoad];

    self.title = @"【收藏 --- Android】";

    [self initTableView];

}

#pragma mark- 加载数据
- (void) loadData{
    [JZLoadingViewPacket showWithTitle:@"加载中" result:RequestLoading addToView:self.view];

    NSMutableArray *dataarray = [[DataForFMDB sharedDataBase]getFavorite:@"Android"];
        
    for(int i=0;i<dataarray.count;i++){
        AndroidData *tempData = [AndroidData new];
        AddData *data = dataarray[i];
        tempData.url = data.url;
        tempData.title = data.title;
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



// 初始化 tableview
- (void) initTableView{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88)];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    

    [self.view addSubview:tableview];
    
    self.tableView = tableview;
    
    [self.tableView registerClass:[AndroidTableViewCell class] forCellReuseIdentifier:@"AndroidCell"];
    
    // 添加头部的下拉刷新
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tableView.mj_header = header;
    self.tableView.mj_header.backgroundColor = [UIColor yellowColor];
    [self.tableView.mj_header beginRefreshing];

}

// 头部的下拉刷新触发事件
- (void)headerClick {
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
    
    AndroidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AndroidCell"];
    
    if (cell == nil) {
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AndroidCell"];
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
    AndroidData *data = self.dataArray[indexPath.row];
    
    GirlDetailViewController *detail = [[GirlDetailViewController alloc]init];
    
    detail.url = data.url;
    detail.title = data.title;
    detail.type = data.type;
        
    [self.navigationController pushViewController:detail animated:YES];
}

- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        
        AndroidData *data = self.dataArray[indexPath.row];
        [[DataForFMDB sharedDataBase]deleteFavorite:@"Android" urlPath:data.url];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

@end
