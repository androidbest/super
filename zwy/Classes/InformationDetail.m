//
//  InformationDetail.m
//  zwy
//
//  Created by wangshuang on 10/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "InformationDetail.h"
#import "InformationInfo.h"
#import "InfomaDetaController.h"
@interface InformationDetail ()

@end

@implementation InformationDetail



- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        InfomaDetaController *informaContro=[InfomaDetaController new];
        informaContro.informaView=self;
        self.controller=informaContro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     if (!self.navigationController.navigationBarHidden)self.navigationController.navigationBarHidden=YES;
    
    /*添加滑动视图*/
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self.controller;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _scrollView.autoresizesSubviews = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.canCancelContentTouches = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    /*标题背景*/
    float layerHeight=90;
    _layerTitleBackView =[CALayer layer];
    _layerTitleBackView.bounds=CGRectMake(0, 0,ScreenWidth , layerHeight);
    CGColorRef layerBorderColor =[[UIColor colorWithRed:0.34 green:0.76 blue:0.91 alpha:1.0] CGColor];
    _layerTitleBackView.backgroundColor=layerBorderColor;
    _layerTitleBackView.anchorPoint=CGPointMake(0, 0);
    [_scrollView.layer addSublayer:_layerTitleBackView];
    
    /*标题*/
    _labelTitle =[[UILabel alloc] init];
    _labelTitle.frame=CGRectMake(10, 25, ScreenWidth-20, 40);
    _labelTitle.font =[UIFont boldSystemFontOfSize:16];
    _labelTitle.textColor=[UIColor whiteColor];
    _labelTitle.numberOfLines=0;
    [_scrollView addSubview:_labelTitle];
    
    /*来源*/
    _labelSource =[[UILabel alloc] init];
    _labelSource.frame=CGRectMake(10, layerHeight-20, ScreenWidth-20, 10);
    _labelSource.textColor=[UIColor grayColor];
    _labelSource.font =[UIFont systemFontOfSize:12];
    [_scrollView addSubview:_labelSource];
    
    /*新闻图片*/
    _imageContentView=[[UIImageView alloc] init];
    _imageContentView.frame=CGRectMake(10, layerHeight+10, ScreenWidth-20, 100);
    [_scrollView addSubview:_imageContentView];
    
    /*内容*/
    _labelContent =[[UILabel alloc] init];
    _labelContent.numberOfLines=0;
    [_scrollView addSubview:_labelContent];
   
    [self.controller initWithData];
//	InformationInfo *info=self.data.informationInfo;
//    _navigationBar.topItem.title=info.title;
//    _textView.text=info.content;
//    _textView.font =[UIFont systemFontOfSize:15];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
