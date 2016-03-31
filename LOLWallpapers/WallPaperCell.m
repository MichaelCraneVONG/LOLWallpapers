//
//  WallPaperCell.m
//  LOLWallpapers
//
//  Created by myApple on 16/3/30.
//  Copyright © 2016年 crane. All rights reserved.
//

#import "WallPaperCell.h"
#import "WallPaper.h"
@interface WallPaperCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WallPaperCell

#pragma mark - public method

-(void)setWallPaper:(WallPaper *)wallPaper{
    NSURL *imageURL = [NSURL URLWithString:@"http://ossweb-img.qq.com/upload/qqtalk/lol_hero/wp_1037.png?3460"];
    NSLog(@"%@=================",wallPaper.src);
//    self.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self.imageView setImageWithURL:imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
