//
//  WallPapersViewController.m
//  LOLWallpapers
//
//  Created by myApple on 16/3/29.
//  Copyright © 2016年 crane. All rights reserved.
//

#import "WallPapersViewController.h"
#import "WallPaperRequest.h"
#import "WallPaperCell.h"
#import "WallPaper.h"
@interface WallPapersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,assign)NSInteger WallPaperpage;
@property (nonatomic,assign)WallPaperType type;
@property (nonatomic,strong)NSMutableArray *WallPagerArray;
@end

@implementation WallPapersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabMenuView];
    [self setupRefreshHeaderAndFooter];
 
}

#pragma mark - LifeCycle
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _WallPaperpage=1;
        _type=WallPaperTypeNEW;
        _WallPagerArray=[[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark -Setup
-(void)setupTabMenuView{
    __weak typeof(self) weakSelf =self;
    
    self.tabMenu.sectionTitles=@[@"最新",@"最热",@"分类",@"收藏"];
    self.tabMenu.selectionStyle=HMSegmentedControlSelectionStyleFullWidthStripe;
    self.tabMenu.selectionIndicatorLocation=HMSegmentedControlSelectionIndicatorLocationDown;
    self.tabMenu.selectionIndicatorHeight=3.0;
//    self.tabMenu.backgroundColor=[UIColor darkGrayColor];
    self.tabMenu.borderType=HMSegmentedControlBorderTypeBottom;
    self.tabMenu.borderColor=[UIColor lightGrayColor];
    self.tabMenu.alpha=0.9;
    self.tabMenu.titleTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    self.tabMenu.selectedTitleTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor blueColor]};
    [self.tabMenu setIndexChangeBlock:^(NSInteger index) {
        switch (index) {
            case 0:
                weakSelf.type=WallPaperTypeNEW;
                break;
            case 1:
                weakSelf.type=WallPaperTypeHOT;
                break;
            case 2:
                weakSelf.type=WallPaperTypeCATEGORY;
                break;
            case 3:
                weakSelf.type=WallPaperTypeFAVORITE;
                break;
            default:
                break;
        }
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRefreshHeaderAndFooter{
    self.collectionView.contentInset=UIEdgeInsetsMake(40, 0, 0, 0);
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshWallPaper)];
    
    MJRefreshAutoFooter *footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveWallPaper)];
    
    header.automaticallyChangeAlpha=YES;
    footer.automaticallyRefresh = YES;
    self.collectionView.mj_header=header;
    self.collectionView.mj_footer=footer;
    [self.collectionView.mj_header beginRefreshing];
}

-(void)refreshWallPaper{
    self.WallPaperpage=1;
        [WallPaperRequest requestWithPage:self.WallPaperpage wallPaperType:self.type success:^(NSArray<WallPaper *> *wallPaperArray) {
            [self.collectionView.mj_header endRefreshing];
            [self reloadDataWithWallPaperArray:wallPaperArray emptyBeforeReLoad:YES];
        } failure:^(NSString *message) {
            [SVProgressHUD showWithStatus:message];
            [self.collectionView.mj_header endRefreshing];
        }];
}

-(void)loadMoveWallPaper{
    [WallPaperRequest requestWithPage:self.WallPaperpage wallPaperType:self.WallPaperpage+1 success:^(NSArray<WallPaper *> *wallPaperArray) {
        [self.collectionView.mj_footer endRefreshing];
        [self reloadDataWithWallPaperArray:wallPaperArray emptyBeforeReLoad:NO];
    } failure:^(NSString *message) {
        [SVProgressHUD showWithStatus:message];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}

-(void)reloadDataWithWallPaperArray:(NSArray<WallPaper*>*)wallPaperArray emptyBeforeReLoad:(BOOL) emptyBeforeReload
{
    if (emptyBeforeReload) {
        self.WallPaperpage=1;
        [self.WallPagerArray removeAllObjects];
        [self.WallPagerArray addObjectsFromArray:wallPaperArray];
        [self.collectionView.mj_footer resetNoMoreData];
    }
    else
    {
        if (wallPaperArray.count) {
            [self.WallPagerArray addObjectsFromArray:wallPaperArray];
            self.WallPaperpage++;
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [self.collectionView reloadData];
}




#pragma mark - CollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    collectionView.mj_footer.hidden=self.WallPagerArray.count==0;
    return self.WallPagerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallPaperCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"wallPaperCell" forIndexPath:indexPath];
    if (cell==nil) {
        NSLog(@"@@");
    }
    [cell setWallPaper:self.WallPagerArray[indexPath.row]];
    //NSLog(@"%@",self.WallPagerArray[indexPath.row]);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger perLine=UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)?2:5;
    if (perLine>2) {
        return CGSizeMake(kScreenWidth/perLine-1, kScreenWidth/perLine-1);
    }
    return CGSizeMake(kScreenWidth/perLine-1, kScreenHeight/perLine-1);
}


#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *photoArray=[NSMutableArray array];
    for (WallPaper *wallpaper in self.WallPagerArray) {
        MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:wallpaper.src]];
        photo.caption=wallpaper.title;
        [photoArray addObject:photo];
    }
    MWPhotoBrowser *browser=[[MWPhotoBrowser alloc]initWithPhotos:photoArray];
    browser.alwaysShowControls=YES;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - Orientation method

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView setCollectionViewLayout:self.collectionView.collectionViewLayout animated:YES];
        } completion:nil];
    }];
}
@end
