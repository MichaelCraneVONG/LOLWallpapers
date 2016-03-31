//
//  WallPaperRequest.m
//  LOLWallpapers
//
//  Created by myApple on 16/3/30.
//  Copyright © 2016年 crane. All rights reserved.
//

#import "WallPaperRequest.h"
#import "WallPaper.h"
@interface WallPaperRequest()

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)WallPaperType type;

@end

@implementation WallPaperRequest

-(instancetype)initWithPage:(NSInteger)page wallPaperType:(WallPaperType)type{
    self=[super init];
    if (self) {
        self.page=page;
        self.type=type;
    }
    return self;
}

//+ (WallPaperRequest *)requestWithPage:(NSInteger)page
//                            meiziType:(WallPaperType)type
//                              success:(void (^)(NSArray<WallPaper *> *))success
//                              failure:(void (^)(NSString *message))failure
//{
//    WallPaperRequest *request=[[WallPaperRequest alloc]initWithPage:page wallPaperType:type];
//    
//    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        WallPaperRequest *wallPaperRequest=(WallPaperRequest*)request;
//        success?success([wallPaperRequest wallPaperArray]):nil;
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//       
//        WallPaperRequest *wallPaperRequest=(WallPaperRequest *)request;
//        failure?failure(@(wallPaperRequest.responseStatusCode).stringValue):nil;
//        
//    }];
//    return request;
//}

+ (WallPaperRequest *)requestWithPage:(NSInteger)page wallPaperType:(WallPaperType)type success:(void (^)(NSArray<WallPaper *> *))success failure:(void (^)(NSString *))failure {
    WallPaperRequest *request = [[WallPaperRequest alloc] initWithPage:page wallPaperType:type];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        WallPaperRequest *wallPaperRequest = (WallPaperRequest *)request;
        success?success([wallPaperRequest wallPaperArray]):nil;
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        WallPaperRequest *wallPaperRequest = (WallPaperRequest *)request;
        failure?failure(@(wallPaperRequest.responseStatusCode).stringValue):nil;
        
    }];
    return request;
}

-(NSString *)requestUrl{
    return @"/dbgroup/show.htm";
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodGet;
}

-(id)requestArgument{
    return @{@"pager_offset":@(_page),
             @"cid":@(_type)};
}

-(NSArray<WallPaper*>*)wallPaperArray{
    NSString *htmlString=self.responseString;
//    TFHpple *rootDocument=[TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]];
//    NSArray *liElements=[rootDocument searchWithXPathQuery:@"//*[@id=\"main\"]/div[3]/div[2]/ul/li"];
    NSMutableArray *wallPaperArray=[NSMutableArray array];
//    for (TFHppleElement *liElement in liElements) {
//        TFHppleElement *imageElement=[[[[liElement firstChildWithClassName:@"thumbnail"]
//                                        firstChildWithClassName:@"img_single"]
//                                       firstChildWithClassName:@"link"]
//                                      firstChildWithTagName:@"img"];
//    WallPaper *wallPaper=[WallPaper mj_objectWithKeyValues:imageElement.attributes];
//        if (wallPaper!=nil) {
//            [wallPaperArray addObject:wallPaper];
//        }
//        
//    }
    
//    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc]init];

    return wallPaperArray;
}
@end
