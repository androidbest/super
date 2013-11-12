//
//  CheckAccessoryView.m
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "CheckAccessoryView.h"
#import "CheckAccessoryController.h"
@interface CheckAccessoryView ()

@end

@implementation CheckAccessoryView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        CheckAccessoryController * control =[CheckAccessoryController new];
        control.checkView=self;
        self.controller=control;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webAccessory.scalesPageToFit =YES;
    _webAccessory.backgroundColor=[UIColor whiteColor];
    _webAccessory.delegate =self.controller;
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  initWithFrame : CGRectMake(0, 0, 32.0f, 32.0f)] ;
    [self.activityIndicatorView setCenter: self.view.center] ;
    [self.activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : self.activityIndicatorView];
    
    NSString * strPath  =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,_url];
    NSString * FileType =[[_url componentsSeparatedByString:@"."] lastObject];
    if ([FileType isEqualToString:@"txt"]||[FileType isEqualToString:@"html"]) {
        NSString *File=[NSString stringWithContentsOfFile:strPath usedEncoding:nil error:NULL];
        if (!File)File=[NSString stringWithContentsOfFile:strPath encoding:0x80000632 error:NULL];
        if (!File)File=[NSString stringWithContentsOfFile:strPath encoding:0x80000631 error:NULL];
        [_webAccessory loadHTMLString:File baseURL:nil];
    }else {
        NSURL *URL = [NSURL fileURLWithPath:strPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [_webAccessory loadRequest:request];
    }
	// Do any additional setup after loading the view.
}

- (void)showAccessoryWithUrl:(NSString *)url{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
