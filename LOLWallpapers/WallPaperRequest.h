//
//  WallPaperRequest.h
//  LOLWallpapers
//
//  Created by myApple on 16/3/30.
//  Copyright © 2016年 crane. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>
#import <hpple/TFHpple.h>
@class WallPaper;

typedef NS_ENUM(NSUInteger,WallPaperType){
    WallPaperTypeNEW             = 0,
    WallPaperTypeHOT              =2,
    WallPaperTypeCATEGORY  = 6,
    WallPaperTypeFAVORITE     = 7,
};

@interface WallPaperRequest : YTKRequest

+ (WallPaperRequest *)requestWithPage:(NSInteger)page
                        wallPaperType:(WallPaperType)type
                          success:(void (^)(NSArray<WallPaper *> *wallPaperArray))success
                          failure:(void (^)(NSString *message))failure;
@end
