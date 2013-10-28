//
//  CheckAccessoryController.m
//  zwy
//
//  Created by cqsxit on 13-10-20.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "CheckAccessoryController.h"

@implementation CheckAccessoryController

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.checkView.activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.checkView.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ToolUtils alertInfo:@"文件出错"];
}

@end
