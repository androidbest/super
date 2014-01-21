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
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ToolUtils.h"
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
    //[[NSOperationQueue mainQueue] addOperation:op];
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

/*异步加载图片*/
+ (void)imageWithURL:(NSString *)URL imageView:(UIImageView *)imageView placeholderImage:(UIImage *)image isDrawRect:(drawRectType_Height_Width)drawRectType{
    imageView.image =image;
    if (!URL)return;
    NSString * PicPath =[[URL componentsSeparatedByString:@"/"] lastObject];
    NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    NSData * data = [NSData dataWithContentsOfFile:strpaths];
    if (data) {
        imageView.image = [UIImage imageWithData:data];
        if (drawRectType==drawRect_height)[CompressImage drawRectToImageView:imageView];
        if (drawRectType==drawRect_width)[CompressImage drawRectToImageViewWidth:imageView];
        return;
    }
    
    
    NSURL * url =[NSURL URLWithString:URL];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        //压缩图片
        [CompressImage setCellContentImage:imageView Image:(UIImage *)responseObject filePath:PicPath isDrawRect:drawRectType];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //显示加载失败图片
        [CompressImage setCellContentImage:imageView Image:[UIImage imageNamed:@"error_image.jpg"] filePath:PicPath isDrawRect:drawRectType];
        NSLog(@"Image request failed with error: %@", error);
    }];
    [[NSOperationQueue new] addOperation:posterOperation];
}

//即时聊天头像
+ (void)imageWithURL:(NSString *)URL imageView:(UIImageView *)imageView placeholderImage:(UIImage *)image{
    if (!URL)return;
    imageView.image =image;
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
        // [CompressImage setCellContentImage:imageView Image:[UIImage imageNamed:@"default_avatar"] filePath:PicPath isDrawRect:drawRect_no];
        [CompressImage  writeFile:responseObject Type:PicPath];
        imageView.image =(UIImage *)responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //显示加载失败图片
        imageView.image=image;
        NSLog(@"Image request failed with error: %@", error);
    }];
    [[NSOperationQueue new] addOperation:posterOperation];
}

//语音下载
+ (void)voiceWithURL:(NSString *)URL{
    if (!URL)return;
    NSString * PicPath =[[URL componentsSeparatedByString:@"/"] lastObject];
    NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    NSData * data = [NSData dataWithContentsOfFile:strpaths];
    if (data) {
        return;
    }
    
    NSURL * url =[NSURL URLWithString:URL];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    posterOperation.responseSerializer = [AFCompoundResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [((NSData *)responseObject) writeToFile:strpaths atomically:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //显示加载失败的voice
        NSLog(@"voice request failed with error: %@", error);
    }];
    [[NSOperationQueue new] addOperation:posterOperation];
}

//个人头像
+ (void)imageWithURL:(NSString *)URL imageView:(UIButton *)imageView placeUIButtonImage:(UIImage *)image{
    if (!URL)return;
    [imageView setBackgroundImage:image forState:UIControlStateNormal];
    NSString * PicPath =[[URL componentsSeparatedByString:@"/"] lastObject];
    NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    NSData * data = [NSData dataWithContentsOfFile:strpaths];
    if (data) {
        [imageView setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        return;
    }
    
    NSURL * url =[NSURL URLWithString:URL];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [CompressImage  writeFile:responseObject Type:PicPath];
        [imageView setBackgroundImage:(UIImage *)responseObject forState:UIControlStateNormal];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //显示加载失败图片
        [imageView setBackgroundImage:image forState:UIControlStateNormal];
        NSLog(@"Image request failed with error: %@", error);
    }];
    [[NSOperationQueue new] addOperation:posterOperation];
}

+ (void)setImageWithURL:(NSString *)URL placeholderImage:(UIImage *)image ImageBolck:(imageWithRequst)ImageBolck;{
    if (!URL)return;
    NSString * PicPath =[[URL componentsSeparatedByString:@"/"] lastObject];
    NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    NSData * data = [NSData dataWithContentsOfFile:strpaths];
    if (data) {
        ImageBolck([UIImage imageWithData:data]);
        return;
    }
    
    NSURL * url =[NSURL URLWithString:URL];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [CompressImage  writeFile:responseObject Type:PicPath];
        ImageBolck(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image request failed with error: %@", error);
    }];
    [[NSOperationQueue new] addOperation:posterOperation];
}

+ (void)uploadRequestOperation:(id)delegate type:(NSString *)type imageData:(NSData *)data url:(NSURL *)url selType:(NSString *)selType uuid:(NSString *)uuid{
    
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //
    //    NSURL *URL = [NSURL URLWithString:@"http://192.168.0.200:7778/phoneservice/"];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //    NSString * strPath =[[NSBundle mainBundle] pathForResource:@"tengxunWeibo" ofType:@"png"];
    //    NSURL *filePath = [NSURL fileURLWithPath:strPath];
    //    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            NSLog(@"Error: %@", error);
    //        } else {
    //            NSLog(@"Success: %@ %@", response, responseObject);
    //        }
    //    }];/Users/sxit/Desktop/20131226162901.wav
    //    [uploadTask resume];http://192.168.0.200:7778/phoneservice/UploadServlet
    //    NSData * data1=UIImageJPEGRepresentation([UIImage imageNamed:@"error_image.jpg"], 0.1);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    //    NSDictionary *parameters = @{@"foo": @"bar"};
    ///phoenix/IosUpServlet?type=1&
    [manager POST:[NSString stringWithFormat:@"/phoneservice/IosUpServlet?type=%@&uuid=%@",type,uuid] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *mimeType=@"";
        if([type isEqualToString:@"0"]){
            mimeType=@"image/jpeg";
        }else{
            mimeType=@"audio/amr";
        }
        [formData appendPartWithFileData:data
                                    name:@"uploadfile"
                                fileName:@"uploadfile"
                                mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", operation.responseString);
//        NSDictionary *dic1=[ToolUtils analyzeJsonFormat:operation.responseData];
        [[NSNotificationCenter defaultCenter] postNotificationName:selType object:delegate userInfo:[ToolUtils analyzeJsonFormat:operation.responseData]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:selType object:delegate userInfo:nil];
    }];
}
@end
