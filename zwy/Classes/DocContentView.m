//
//  DocContentView.m
//  zwy
//
//  Created by wangshuang on 10/23/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "DocContentView.h"
#import "ToolUtils.h"
@interface DocContentView ()

@end

@implementation DocContentView{
    NSString *isWord;
    NSString *filePath_;
    UIWebView * webView;
    UIActivityIndicatorView * activityIndicatorView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView =[[UIWebView alloc]initWithFrame:CGRectMake(0,topLayout,ScreenWidth,ScreenHeight-topLayout)];
    webView.delegate=self;
    [self.view addSubview:webView];
    activityIndicatorView_ = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0,30,30)];
    [activityIndicatorView_ setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    [activityIndicatorView_ setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    
    //    NSURL * url = [NSURL URLWithString:urlStr];
    //    theRequest = [NSURLRequest requestWithURL:url];
    //    strUrl_ = urlStr;
//    idStr_ = str;
    [self.view addSubview:activityIndicatorView_];
    [activityIndicatorView_ startAnimating];
    [NSThread detachNewThreadSelector:@selector(appDownLoad) toTarget:self withObject:nil];
}


-(void)appDownLoad{
    if (![_detailInfo.textUrl isEqualToString:@"null"]) {
        
        NSString *name=_detailInfo.textUrl;
        NSArray * pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * pathStr = [[pathArr objectAtIndex:0] stringByAppendingPathComponent:name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:pathStr]) {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.200:7778/phoneservice/IosDocAttachmentServlet?id=%@&isAttachment=0",_detailInfo.ID]];
            NSURLRequest  *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            NSData * getData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
            [getData writeToFile:pathStr atomically:NO];
        }
        isWord = @"1";
        filePath_ = pathStr;
        
    }else if(![_detailInfo.affixUrl isEqualToString:@"null"])
    {
        NSString * strUrl = _detailInfo.affixUrl;
        NSURL * url = [NSURL URLWithString:strUrl];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        filePath_ = strUrl;
        [NSURLConnection connectionWithRequest:theRequest delegate:self];
        isWord = @"0";
    }
    [self performSelectorOnMainThread:@selector(appDownLoadBegin) withObject:nil waitUntilDone:YES];
}


-(void)appDownLoadBegin
{
    if (([isWord isEqualToString:@"0"])) {
        
        NSURL *url = [NSURL URLWithString:filePath_];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
        
    }else if(([isWord isEqualToString:@"1"])){
        
        NSURL * url = [NSURL fileURLWithPath:filePath_];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        [webView loadRequest:request];
        
    }
    else
    {
        [ToolUtils alertInfo:@"暂无内容"];
    }
    [activityIndicatorView_ stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
