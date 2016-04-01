//
//  WallPaperRequest.m
//  LOLWallpapers
//
//  Created by myApple on 16/3/30.
//  Copyright © 2016年 crane. All rights reserved.
//

#import "WallPaperRequest.h"
#import "WallPaper.h"
@interface WallPaperRequest()//<NSURLSessionDataDelegate>

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)WallPaperType type;

@end

@implementation WallPaperRequest
{
    NSMutableArray *marr;
}
-(instancetype)initWithPage:(NSInteger)page wallPaperType:(WallPaperType)type{
    self=[super init];
    if (self) {
        self.page=page;
        self.type=type;
    }
    return self;
}

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
    return @{@"page":@(_page),
             @"type":@(_type)};
}



-(NSArray<WallPaper*>*)wallPaperArray{
    NSMutableArray *wallPaperArr=[[NSMutableArray alloc]init];
    NSString *strType=@"new";
    if (self.type==WallPaperTypeNEW) {
        strType=@"new";
    }
    else if (self.type==WallPaperTypeHOT) {
        strType=@"hot";
    }

    NSLog(@"%ld--%ld",self.type,self.page);
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://qt.qq.com/php_cgi/lol_goods/varcache_wallpaper_list.php?type=%@&page=%ld&num=20&plat=android&version=9692",strType,self.page]];
    NSData *dataS=[NSData dataWithContentsOfURL:url];
    NSDictionary *jsonDataDict=[NSJSONSerialization JSONObjectWithData:dataS options:NSJSONReadingMutableLeaves error:nil];
                NSArray *jsonDataArr=[jsonDataDict objectForKey:@"wallpapers"];
                for (NSDictionary * dict in jsonDataArr) {
                    WallPaper *wallPaper=[[WallPaper alloc]init];
                    wallPaper.title=@"123";
                    wallPaper.src=[dict objectForKey:@"url"];
                    [wallPaperArr addObject:wallPaper];
    
    
                }

    NSLog(@"====%@",dataS);

//
//    __weak typeof(NSMutableArray *) weakArr=wallPaperArr;


//    NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData *  data, NSURLResponse * _Nullable response, NSError *  error) {
//        
//        if (error==nil) {
//          NSDictionary *jsonDataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSArray *jsonDataArr=[jsonDataDict objectForKey:@"wallpapers"];
//            for (NSDictionary * dict in jsonDataArr) {
//                WallPaper *wallPaper=[[WallPaper alloc]init];
//                wallPaper.title=@"123";
//                wallPaper.src=[dict objectForKey:@"url"];
//                [weakArr addObject:wallPaper];
//                
////                NSLog(@"%ld",wallPaperArr.count);
//                
//            }
//       
//         }
//    }];
//
//    [task resume];
    

   
//         NSLog(@"%@",[task response]);
//   NSLog(@"==fff===========%ld",marr.count);
    return wallPaperArr;

}
    

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
//    didReceiveData:(NSData *)data
//{
//        marr=[NSMutableArray array];
//         NSDictionary *jsonDataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//         NSArray *jsonDataArr=[jsonDataDict objectForKey:@"wallpapers"];
//                for (NSDictionary * dict in jsonDataArr) {
//                    WallPaper *wallPaper=[[WallPaper alloc]init];
//                    wallPaper.title=@"123";
//                    wallPaper.src=[dict objectForKey:@"url"];
//                    [marr addObject:wallPaper];
//                    
//                }
//
//   
//                
//    NSLog(@"=============%ld",marr.count);
//}

//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
//{
//    if(error)
//    {
//        NSLog(@"错误:%@",error.localizedDescription);
//    }
//    else
//    {
//        NSLog(@"加载完成...");
//    }
//    NSLog(@"=============%ld",marr.count);
//}



@end
