//
//  ViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "ViewController.h"

#import "SideTabBarView.h"

#import "JZLoadingViewPacket.h"

#import "DataForFMDB.h"
#import "FData.h"
#import "AddData.h"

#import "GirlDetailViewController.h"

#import "BaseEngine.h"
#import "CycleBannerView.h"
#import "CycleBannerData.h"

#import "FavoriteViewController.h"
#import "GirlViewController.h"
#import "IosViewController.h"
#import "AndroidViewController.h"

#import "WaterFullCellCollectionViewCell.h"
#import "WaterFullLayout.h"
#import "WaterFullData.h"

#import <MJRefresh.h>
#import <MJExtension.h>

// 侧边栏的宽度
#define LEFT_WIDTH 100

static NSString * const WaterfullId = @"waterfull";

@interface ViewController ()<UICollectionViewDataSource, WaterFallLayoutDelegate, SideTabBarViewDelegate>

@property (nonatomic, retain) CycleBannerView *scrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/** 所有数据 */
@property (nonatomic, strong) NSMutableArray  * waterFulls;

/** collectionView */
@property (nonatomic, weak) UICollectionView * collectionView;

/** 列数 */
@property (nonatomic, assign) NSUInteger columnCount;

/** 页数 */
@property (nonatomic, assign) int page;

/** 高 */
@property (nonatomic, assign) int h;

/** 宽 */
@property (nonatomic, assign) int w;

@property(nonatomic, strong) SideTabBarView *lefeView;

@property(nonatomic, strong) UIView *bgView;

@property (assign, nonatomic,getter=isHidden)  BOOL hidden;

@property(nonatomic, strong) NSMutableArray *tabItems;

@property(nonatomic, strong)UITabBarController *tabBarController;

@end


@implementation ViewController

#pragma mark - 懒加载
- (NSMutableArray *)waterFulls{
    if (!_waterFulls) {
        _waterFulls = [NSMutableArray array];
    }
    return _waterFulls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initDataBase];
    
    [self initSideTabBar];

    [self initNavigationBar];

    [self initScroll];

    [self initButton];
    
    [self initLayoutAndCollectionView];
       
    [self initRefresh];
}


#pragma mark -初始化
- (void)initSideTabBar{
    [self setUpChildViewController:@"Login" imageName:@"登录 (1)" selectImageName:@"登录"];
    [self setUpChildViewController:@"Girl" imageName:@"美女 (1)" selectImageName:@"美女"];
    [self setUpChildViewController:@"iOS" imageName:@"苹果 (1)" selectImageName:@"苹果"];
    [self setUpChildViewController:@"Android" imageName:@"安卓 (1)" selectImageName:@"安卓"];
    
    self.tabBarController.selectedIndex = 0;
    self.hidden = YES;
    
    [self.tabBarController setValue:nil forKeyPath:@"tabBar"];
}

- (void)initDataBase{
        DataForFMDB *db = [DataForFMDB sharedDataBase];

    //    [[DataForFMDB sharedDataBase] addFavorite:@"girl" urlPath:@"http://gank.io/images/f4f6d68bf30147e1bdd4ddbc6ad7c2a2"];
    //    [[DataForFMDB sharedDataBase] addFavorite:@"ios" urlPath:@"https://github.com/pujiaxin33/JXPatternLock"];
    //    [[DataForFMDB sharedDataBase] addFavorite:@"android" urlPath:@"https://github.com/loperSeven/DateTimePicker"];
        
    //
    //    if([[DataForFMDB sharedDataBase] checkFavorite:@"girl" urlPath:@"http://gank.io/images/f4f6d68bf30147e1bdd4ddbc6ad7c2a2"])
    //        NSLog(@"存在");
    //    else
    //        NSLog(@"不存在");
        
    //    self.dataArray = [db ]
}

- (void)initNavigationBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // title
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 80, 40)];
    
    label.text = @"干货集中营®";
    
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = label;
    
    //right button
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

    [Button setBackgroundImage:[UIImage imageNamed:@"收藏 (1)"] forState:UIControlStateNormal];

    [Button addTarget:self action:@selector(popFavoriteView) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:Button];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:view];

    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initScroll{
    self.scrollView = [[CycleBannerView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, 400)];
    
    [self.view addSubview:self.scrollView];
    
    self.scrollView.indexBack = ^(NSInteger pageIndex) {
    };
    
    [BaseEngine requestUrl:[NSString stringWithFormat:@"https://gank.io/api/v2/banners"] completionHandler:^(NSArray * _Nullable dataarray) {
       
        NSMutableArray *tempArray = [NSMutableArray new];
        
        for(int i=0;i<dataarray.count;i++){
            CycleBannerData *data=[CycleBannerData new];
            
            for(id key in dataarray[i]){
                if([key isEqual:@"image"])
                {
                    data.image=dataarray[i][key];
                }
                else if([key isEqual:@"title"])
                {
                    data.title=dataarray[i][key];
                }
                else if([key isEqual:@"url"])
                {
                    data.url=dataarray[i][key];
                }
            }
            [tempArray addObject:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollView.imageArray = tempArray;
        });
    }];
    
    self.scrollView.duration = 3.0;
}

- (void)initButton{
    
    UILabel *ztLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 505, self.view.bounds.size.width - 10, 8)];
    
    ztLabel.text = @"干货分类：";
    ztLabel.textColor = [UIColor grayColor];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-3, 70, self.view.bounds.size.width - 18, 2)];
    line.backgroundColor = [UIColor grayColor];
    [ztLabel addSubview:line];

    [self.view addSubview:ztLabel];
    
    
    UIButton *girlBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 525, (self.view.bounds.size.width-40)/3, 40)];
    [girlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [girlBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [girlBtn setBackgroundImage:[UIImage imageNamed:@"girl.jpg"] forState:UIControlStateNormal];
    girlBtn.layer.borderWidth = 3;  // 边框的宽
    girlBtn.layer.borderColor = [UIColor grayColor].CGColor;//边框的颜色
    [girlBtn addTarget:self action:@selector(popGirlView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *ganhuoBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-40)/3+20, 525, (self.view.bounds.size.width-40)/3, 40)];
    [ganhuoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ganhuoBtn setBackgroundImage:[UIImage imageNamed:@"ios.jpg"] forState:UIControlStateNormal];
    ganhuoBtn.layer.borderWidth = 3;  // 边框的宽
    ganhuoBtn.layer.borderColor = [UIColor grayColor].CGColor;//边框的颜色
    [ganhuoBtn addTarget:self action:@selector(popGanhuoView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *articleBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-40)*2/3+30, 525, (self.view.bounds.size.width-40)/3, 40)];
    [articleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [articleBtn setBackgroundImage:[UIImage imageNamed:@"android.jpg"] forState:UIControlStateNormal];
    articleBtn.layer.borderWidth = 3;  // 边框的宽
    articleBtn.layer.borderColor = [UIColor grayColor].CGColor;//边框的颜色
    [articleBtn addTarget:self action:@selector(popArticleView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:girlBtn];
    [self.view addSubview:ganhuoBtn];
    [self.view addSubview:articleBtn];
}

- (void)initLayoutAndCollectionView{
    
    // 创建布局
    WaterFallLayout * waterFallLayout = [[WaterFallLayout alloc]init];
    waterFallLayout.delegate = self;
    
    // 创建collectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 580, self.view.bounds.size.width, 300) collectionViewLayout:waterFallLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource = self;
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterFullCellCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WaterfullId];
    
    self.collectionView = collectionView;
    
    self.collectionView.delaysContentTouches = false;
    
//    UIButton *changebtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-5, 5, 10, 10)];
//    [changebtn setBackgroundImage:[UIImage imageNamed:@"star.jpeg"] forState:UIControlStateNormal];
//    [changebtn addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [collectionView addSubview:changebtn];
    
    [self.view addSubview:self.collectionView];

    self.h = (self.view.bounds.size.width/2) /3 * 5;
    self.w = self.view.bounds.size.width/2;
}

- (void)initRefresh{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewGirls)];
    self.collectionView.mj_header.backgroundColor = [UIColor yellowColor];
    [self.collectionView.mj_header beginRefreshing];
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGirls)];
    self.collectionView.mj_footer.backgroundColor = [UIColor yellowColor];
    self.collectionView.mj_footer.hidden = YES;
    
}

- (void)loadNewGirls{
    
    self.page=1;
    if (self.waterFulls.count > 0) {
        [self.waterFulls removeAllObjects];
    }
    [JZLoadingViewPacket showWithTitle:@"加载中" result:RequestLoading addToView:self.view];

    [BaseEngine requestUrl:[NSString stringWithFormat:@"https://gank.io/api/v2/data/category/Girl/type/Girl/page/%d/count/20",self.page] completionHandler:^(NSArray * _Nullable dataarray) {

        for(int i=0;i<dataarray.count;i++){
            WaterFullData *data=[WaterFullData new];

            for(id key in dataarray[i]){
                if([key isEqual:@"images"])
                {
                    data.image=dataarray[i][key];
                }
                else if([key isEqual:@"title"])
                {
                    data.title=dataarray[i][key];
                }
            }
            data.h = self.h;
            data.w = self.w;

            [self.waterFulls addObject:data];
        }
     
        NSLog(@"self.waterFulls.count: %ld", self.waterFulls.count);

        [self.collectionView.mj_header endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
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

- (void)loadMoreGirls{

    if(self.waterFulls.count>95){
        return;
    }
    else{
        self.page++;
    }
    
    [BaseEngine requestUrl:[NSString stringWithFormat:@"https://gank.io/api/v2/data/category/Girl/type/Girl/page/%d/count/20",self.page] completionHandler:^(NSArray * _Nullable dataarray) {
        
        for(int i=0;i<dataarray.count;i++){
            WaterFullData *data=[WaterFullData new];
            
            for(id key in dataarray[i]){
                if([key isEqual:@"images"])
                {
                    data.image=dataarray[i][key];
                }
                else if([key isEqual:@"title"])
                {
                    data.title=dataarray[i][key];
                }
                else if([key isEqual:@"url"])
                {
                    data.url=dataarray[i][key];
                }
            }
            data.h = self.h;
            data.w = self.w;
            
            [self.waterFulls addObject:data];
        }
        
        NSLog(@"self.waterFulls.count: %ld", self.waterFulls.count);
        
        [self.collectionView.mj_header endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    }];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    self.collectionView.mj_footer.hidden = self.waterFulls.count == 0;
    
    return self.waterFulls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WaterFullCellCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfullId forIndexPath:indexPath];
    
    cell.waterfull = self.waterFulls[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WaterFullData *data = self.waterFulls[indexPath.row];
    
    GirlDetailViewController *detail = [[GirlDetailViewController alloc]init];
    
    detail.url = data.url;
    detail.title = data.title;
        
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark  - <WaterFallLayoutDelegate>
- (CGFloat)waterFallLayout:(WaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth{
    
    WaterFullData * waterfull = self.waterFulls[indexPath];

    return itemWidth * waterfull.h / waterfull.w;
}

- (CGFloat)rowMarginInWaterFallLayout:(WaterFallLayout *)waterFallLayout{
    return self.waterFulls.count;
}

- (NSUInteger)columnCountInWaterFallLayout:(WaterFallLayout *)waterFallLayout{
    return 2;
}


#pragma mark -页面跳转
- (void)popFavoriteView{

    NSLog(@"我的收藏");
    
    FavoriteViewController *vc = [FavoriteViewController new];
        
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popGirlView{

    NSLog(@"妹纸专题");
    
    GirlViewController *vc = [GirlViewController new];
        
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popGanhuoView{

    NSLog(@"IOS专题");
    
    IosViewController *vc = [IosViewController new];
        
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popArticleView{

    NSLog(@"Android专题");
    
    AndroidViewController *vc = [AndroidViewController new];
        
 
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -tabbar
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setUpChildViewController:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName{
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
    
    UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];

    [Button setBackgroundImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];

    [Button addTarget:self action:@selector(tabHiddenOrShow) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:Button];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:view];

    self.navigationItem.leftBarButtonItem = rightItem;

    NSDictionary *dict = @{@"title":title,
                           @"image":imageName,
                           @"selectImage":selectImageName
                           };
    [self.tabItems addObject:dict];
}

- (void)tabHiddenOrShow{
    [self.tabBarController.tabBar setHidden:YES];
    self.hidden = !self.isHidden;
    
    if (self.lefeView == nil) {
        self.lefeView = [[SideTabBarView alloc] initWithFrame:CGRectMake(-LEFT_WIDTH, 0, LEFT_WIDTH, [UIScreen mainScreen].bounds.size.height)];
        self.lefeView.delegate = self;
        self.lefeView.itemArray = self.tabItems;
        [[UIApplication sharedApplication].keyWindow addSubview:self.lefeView];
    }
    if (self.bgView == nil) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self.bgView addGestureRecognizer:tap];
    }
    
    CGRect leftFrame = self.lefeView.frame;
    if (self.isHidden == YES) {
        leftFrame.origin.x = -LEFT_WIDTH;
        [self.bgView removeFromSuperview];
    } else {
        [[UIApplication sharedApplication].keyWindow insertSubview:self.bgView belowSubview:self.lefeView];
        leftFrame.origin.x = 0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.lefeView.frame = leftFrame;
        [self.view setNeedsLayout];
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    [self tabHiddenOrShow];
}


#pragma mark - SideTabBarViewDelegate
-(void)didClickChildButton:(int)selectedIndex{
    self.tabBarController.selectedIndex = selectedIndex;
    [self tabHiddenOrShow];
    
    switch (selectedIndex) {
        case 0:
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尚未开发，敬请期待" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];

            [alertVC addAction:cancelAc];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [self popGirlView];
        }
            break;
        case 2:
        {
            [self popGanhuoView];
        }
            break;
        case 3:
        {
            [self popArticleView];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - set & get
-(NSMutableArray *)tabItems{
    if (_tabItems == nil) {
        _tabItems = [NSMutableArray array];
    }
    return _tabItems;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
