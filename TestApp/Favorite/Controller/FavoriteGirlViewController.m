//
//  FavoriteGirlViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/24.
//  Copyright © 2020 netease. All rights reserved.
//

#import "FavoriteGirlViewController.h"
#import "WaterFullData.h"
#import "WaterFullLayout.h"
#import "WaterFullCellCollectionViewCell.h"
#import "BaseEngine.h"
#import "GirlDetailViewController.h"
#import "DataForFMDB.h"
#import "AddData.h"

#import <MJRefresh.h>
#import <MJExtension.h>


@interface FavoriteGirlViewController ()<UICollectionViewDataSource, WaterFallLayoutDelegate>

/** collectionView */
@property (nonatomic, weak) UICollectionView * collectionView;

/** 所有数据 */
@property (nonatomic, strong) NSMutableArray  * waterFulls;

/** 列数 */
@property (nonatomic, assign) NSUInteger columnCount;

/** 页数 */
@property (nonatomic, assign) int page;

/** 高 */
@property (nonatomic, assign) int h;

/** 宽 */
@property (nonatomic, assign) int w;

@end

static NSString * const WaterfullId = @"waterfull";

@implementation FavoriteGirlViewController

- (void)dealloc{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - 懒加载
- (NSMutableArray *)waterFulls{
    if (!_waterFulls) {
        _waterFulls = [NSMutableArray array];
    }
    return _waterFulls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"【收藏 --- 妹纸】";
    
    [self initLayoutAndCollectionView];
    
    [self initRefresh];
}

- (void)initLayoutAndCollectionView{
    
    // 创建布局
    WaterFallLayout * waterFallLayout = [[WaterFallLayout alloc]init];
    waterFallLayout.delegate = self;
    
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
    
  
    
    // 创建collectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame: CGRectMake(x, y, w, h) collectionViewLayout:waterFallLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource = self;
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterFullCellCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WaterfullId];
    
    self.collectionView = collectionView;
    
    self.collectionView.delaysContentTouches = false;
    
    [self.view addSubview:self.collectionView];

    self.h = (self.view.bounds.size.width/2) /3 * 5;
    self.w = self.view.bounds.size.width/2;
}

- (void)initRefresh{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewGirls)];
    self.collectionView.mj_header.backgroundColor = [UIColor yellowColor];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadNewGirls{
    self.page=1;
    
//    if (self.waterFulls.count > 0) {
        [self.waterFulls removeAllObjects];
//    }
    
    NSMutableArray *dataarray = [[DataForFMDB sharedDataBase]getFavorite:@"Girl"];
    NSLog(@"dataarray.count:%ld",dataarray.count);
    for(int i=0;i<dataarray.count;i++){
        WaterFullData *data=[WaterFullData new];

        AddData *add = [AddData new];
        
        add = dataarray[i];
        
        NSMutableArray *array=[NSMutableArray new];
        
        
        [array addObject:add.url];
        
        data.images=array;
        data.url=add.url;
        data.title=add.title;
        data.h = self.h;
        data.w = self.w;
        
        [self.waterFulls addObject:data];
    }
    
    NSLog(@"self.waterFulls.count: %ld", self.waterFulls.count);
    
    [self.collectionView.mj_header endRefreshing];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });

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

@end
