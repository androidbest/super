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

//    NSArray *filesToUpload =@[@"http://img6.3lian.com/c23/desk2/8/30/015.jpg"];
//    NSMutableArray *mutableOperations = [NSMutableArray array];
//    for (NSURL *fileURL in filesToUpload) {
//        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
//                                                                                           URLString:@"/Users/cqsxit/Desktop/zwy"
//                                                                                          parameters:nil
//                                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileURL:fileURL name:@"images[]" error:nil];
//        }];
//
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//
//        [mutableOperations addObject:operation];
//    }

//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSURL *URL = [NSURL URLWithString:@"http://img6.3lian.com/c23/desk2/8/30/015.jpg"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
//        return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSDictionary  *dic =@{@"path":filePath,};
//        [[NSNotificationCenter defaultCenter] postNotificationName:xmlNotifInfo object:delegate userInfo:dic];
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    [downloadTask resume];



//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSURL *URL = [NSURL URLWithString:@"http://arch.pconline.com.cn//pcedu/photo/0407/pic/040709fengjing01.jpg"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    NSURL *filePath = [NSURL fileURLWithPath:@"/Users/cqsxit/Desktop/zwy/image.jpg"];
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"Success: %@ %@", response, responseObject);
//        }
//    }];
//    [uploadTask resume];
//
//    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:@[@""] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//        NSLog(@"%lu of %lu complete", (unsigned long)numberOfFinishedOperations, (unsigned long)totalNumberOfOperations);
//    } completionBlock:^(NSArray *operations) {
//        NSLog(@"All operations in batch complete");
//    }];
//    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
@end
