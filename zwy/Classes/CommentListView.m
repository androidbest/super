//
//  CommentListView.m
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "CommentListView.h"
#import "CommentListController.h"
@interface CommentListView ()

@end

@implementation CommentListView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        CommentListController * listController =[CommentListController new];
        self.controller=listController;
        listController.comListView=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float layerHeight=64;
    
    /*标题背景*/
    CALayer *_layerTitleBackView =[CALayer layer];
    _layerTitleBackView.bounds=CGRectMake(0, 0,ScreenWidth , layerHeight);
    CGColorRef layerBorderColor =[[UIColor colorWithRed:0.34 green:0.76 blue:0.91 alpha:1.0] CGColor];
    _layerTitleBackView.backgroundColor=layerBorderColor;
    _layerTitleBackView.anchorPoint=CGPointMake(0, 0);
    _layerTitleBackView.zPosition=-1;
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
    
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    _btnBack.hidden=YES;
    [_btnComment addTarget:self.controller action:@selector(btnComment) forControlEvents:UIControlEventTouchUpInside];
    [_btnRefresh addTarget:self.controller action:@selector(btnRefresh) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack1 addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableViewComment=[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, layerHeight+1, ScreenWidth, ScreenHeight-layerHeight-UITabBarHeight-2) withDelegate:self.controller];
    _tableViewComment.tag=0;
    self.tableViewComment.separatorStyle = NO;
    [self.view addSubview:_tableViewComment];
    [self.tableViewComment LoadDataBegin];/*刷新数据*/
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self.controller  BasePrepareForSegue:segue sender:sender];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
