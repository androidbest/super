//
//  HTTPRequest.m
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import "HTTPRequest.h"
#import "AFHTTPRequestOperation.h"
#import "ParseXML.h"
#import "AnalysisData.h"
#import "Constants.h"
#import "AFURLConnectionOperation.h"
#import "ConfigFile.h"
#import "CompressImage.h"
@implementation HTTPRequest

+ (void)JSONRequestOperation:(id)delegate Request:(NSMutableURLRequest *)request{

    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:OutTime];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSDictionary * dic  = [ParseXML dicTIonaryForXML:(NSXMLParser *)responseObject error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:xmlNotifInfo object:delegate userInfo:dic];
        NSLog(@"xml: %@", dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:xmlNotifInfo object:delegate userInfo:nil];
    }];
    
    [[NSOperationQueue new] addOperation:op];
//    [[NSOperationQueue mainQueue] addOperation:op];
}



+ (void)JSONRequestOperation:(id)delegate Request:(NSMutableURLRequest *)request SELType:(NSString *)sel{
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:OutTime];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic  = [ParseXML dicTIonaryForXML:(NSXMLParser *)responseObject error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:sel object:delegate userInfo:dic];
        NSLog(@"xml: %@", dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:sel object:delegate userInfo:nil];
    }];
    
    [[NSOperationQueue new] addOperation:op];
    //    [[NSOperationQueue mainQueue] addOperation:op];
}

//同步通讯录
+(void)LoadDownFile:(id)delegate URL:(NSString *)strUrl filePath:(NSString *)path  HUD:(MBProgressHUD *)hud{
    NSURL * url =[NSURL URLWithString:strUrl];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:OutTime];
    AFURLConnectionOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [(AFHTTPRequestOperation *)operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=@{@"respCode":@"0"};
          [[NSNotificationCenter defaultCenter] postNotificationName:wnLoadAddress object:delegate userInfo:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dic=@{@"respCode":@"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:wnLoadAddress object:delegate userInfo:dic];
        NSLog(@"ERROR: %@",error);
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float percentDone = totalBytesRead/(float)totalBytesExpectedToRead;
        hud.progress =percentDone;
        NSLog(@"%f",percentDone);
    }];
    [operation start];
}

//批量下载
+ (void)data{
    NSURL * url =[NSURL URLWithString:@"http://img.article.pchome.net/00/28/65/41/pic_lib/wm/061115adreamyworld01.jpg"];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    AFURLConnectionOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:@"/Users/cqsxit/Desktop/image.jpg" append:NO];
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:@[operation] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
       NSLog(@"%lu of %lu complete",(unsigned long)numberOfFinishedOperations,(unsigned long)totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations in batch complete");
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

/*图片缓存*/
+ (void)imageWithURL:(NSString *)URL imageView:(UIImageView *)imageView placeholderImage:(NSString *)imagePath{
    imageView.image = [UIImage imageNamed:imagePath];
    NSString * PicPath =[[URL componentsSeparatedByString:@"/"] lastObject];
    NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    NSData * data = [NSData dataWithContentsOfFile:strpaths];
    if (data) {
        imageView.image = [UIImage imageWithData:data];
        return;
    }
    NSURL * url =[NSURL URLWithString:URL];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
       //压缩图片
        imageView.alpha=0.0;
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha=1.0;
            [CompressImage setCellContentImage:imageView Image:(UIImage *)responseObject filePath:PicPath];
        }];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image request failed with error: %@", error);
    }];
    [[NSOperationQueue new] addOperation:posterOperation];
}


@end
