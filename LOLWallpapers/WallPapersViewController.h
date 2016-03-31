//
//  WallPapersViewController.h
//  LOLWallpapers
//
//  Created by myApple on 16/3/29.
//  Copyright © 2016年 crane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
@interface WallPapersViewController : UIViewController
@property (weak, nonatomic) IBOutlet HMSegmentedControl *tabMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end
