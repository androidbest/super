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
    float layerHeight=90.0;
   
    /*标题背景*/
    _layerTitleBackView =[CALayer layer];
    _layerTitleBackView.bounds=CGRectMake(0, 0,ScreenWidth , layerHeight);
    CGColorRef layerBorderColor =[[UIColor colorWithRed:0.34 green:0.76 blue:0.91 alpha:1.0] CGColor];
    _layerTitleBackView.backgroundColor=layerBorderColor;
    _layerTitleBackView.anchorPoint=CGPointMake(0, 0);
    [self.view.layer addSublayer:_layerTitleBackView];
    
    CALayer *layerSeg=[CALayer layer];
    layerSeg.frame=CGRectMake(-ScreenWidth/2, layerHeight-0.5,ScreenWidth , 0.5);
    layerBorderColor =[[UIColor grayColor] CGColor];
    layerSeg.backgroundColor=layerBorderColor;
    layerSeg.anchorPoint=CGPointMake(0, 0);
    [self.view.layer addSublayer:layerSeg];
    
    CALayer *tabbarLayer =[CALayer layer];
    tabbarLayer.frame=CGRectMake(-ScreenWidth/2, ScreenHeight-UITabBarHeight-0.5,ScreenWidth , 0.5);
    tabbarLayer.backgroundColor=[[UIColor grayColor] CGColor];
    tabbarLayer.anchorPoint=CGPointMake(0, 0);
    [self.view.layer addSublayer:tabbarLayer];
    
    /*赞动画层*/
    _labelCommend=[[UILabel alloc] init];
    _labelCommend.frame=CGRectMake(0, 0, 20, 20);
    _labelCommend.text=@"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    _labelCommend.center=_btnCommend.center;
    [self.view addSubview:_labelCommend];
    
    
    /*添加滑动视图*/
    CGRect rect =CGRectMake(0, layerHeight, ScreenWidth,ScreenHeight-layerHeight-UITabBarHeight);
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.delegate = self.controller;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = NO;
    _scrollView.bounces=YES;
    [self.view addSubview:_scrollView];
    
    /*标题*/
    _labelTitle =[[UILabel alloc] init];
    _labelTitle.frame=CGRectMake(10, 25, ScreenWidth-20, 40);
    _labelTitle.font =[UIFont boldSystemFontOfSize:16];
    _labelTitle.textColor=[UIColor whiteColor];
    _labelTitle.numberOfLines=0;
    [self.view addSubview:_labelTitle];
    
    /*来源*/
    _labelSource =[[UILabel alloc] init];
    _labelSource.frame=CGRectMake(10, layerHeight-20, ScreenWidth-20, 12);
    _labelSource.textColor=[UIColor whiteColor];
    _labelSource.font =[UIFont systemFontOfSize:12];
    [self.view addSubview:_labelSource];
    
    /*新闻图片*/
    _imageContentView=[[UIImageView alloc] init];
    _imageContentView.frame=CGRectMake(10, 10, ScreenWidth-20, 100);
    [_scrollView addSubview:_imageContentView];
    
    /*内容*/
    _labelContent =[[UILabel alloc] init];
    _labelContent.numberOfLines=0;
    [_scrollView addSubview:_labelContent];
   
    //按钮
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack setExclusiveTouch:YES];
    
    [_btnCommend addTarget:self.controller action:@selector(btnCommend:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCommend setExclusiveTouch:YES];
    
    [_btnShare addTarget:self.controller action:@selector(btnShare) forControlEvents:UIControlEventTouchUpInside];
    [_btnShare setExclusiveTouch:YES];
    
    [_btnComment addTarget:self.controller action:@selector(btnComment) forControlEvents:UIControlEventTouchUpInside];
    [_btnComment setExclusiveTouch:YES];
    
    [_btnNextNews addTarget:self.controller action:@selector(btnNextNews) forControlEvents:UIControlEventTouchUpInside];
    [_btnNextNews setExclusiveTouch:YES];
    
    [self.controller initWithData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.controller  BasePrepareForSegue:segue sender:sender];
}


- (void)btnCommend:(id)sender{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
