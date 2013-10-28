//
//  HelpController.m
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "HelpController.h"
#import "ToolUtils.h"
#import "Constants.h"
@implementation HelpController

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.helpView.activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.helpView.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ToolUtils alertInfo:requestError];
}
@end
