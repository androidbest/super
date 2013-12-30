//
//  HelpView.m
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "HelpView.h"
#import "HelpController.h"
#import "ConfigFile.h"
@interface HelpView ()

@end

@implementation HelpView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        HelpController *help=[HelpController new];
        help.helpView=self;
        self.controller=help;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.helpWebPage.scalesPageToFit =YES;
    self.helpWebPage.delegate =self.controller;
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0, 0, 32.0f, 32.0f)];
    self.helpWebPage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.activityIndicatorView setCenter: self.view.center] ;
    [self.activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    [self loadWebPageWithString:[ConfigFile newInstance].configData[@"helpurl"]];
}

- (void)loadWebPageWithString:(NSString*)urlString{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.helpWebPage loadRequest:request];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
