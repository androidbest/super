//
//  NoticeDetailView.m
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "NoticeDetailView.h"
#import "NoticeDetaInfo.h"
@interface NoticeDetailView ()

@end

@implementation NoticeDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NoticeDetaInfo *info=self.data.noticeInfo;
    
    UIView * view =[[UIView alloc] init];
    view.frame =CGRectMake(0, 0, ScreenWidth, 44);
    view.backgroundColor =self.navigationItem.titleView.backgroundColor;
    _navigationBar.topItem.titleView=view;
    
    //标题
    _titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0,5,300,15)];
    _titleLab.text=info.title;
    _titleLab.font=[UIFont boldSystemFontOfSize:15];
    _titleLab.textColor=[UIColor blackColor];
    _titleLab.backgroundColor=[UIColor clearColor];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:_titleLab];
    
    //时间
    _time =[[UILabel alloc] initWithFrame:CGRectMake(0,25,300,15)];
    _time.text=[NSString stringWithFormat:@"时间:%@",info.publicdate];
    _time.textAlignment=NSTextAlignmentCenter;
    _time.font=[UIFont systemFontOfSize:12];
    _time.textColor=[UIColor grayColor];
    _time.backgroundColor=[UIColor clearColor];
    [view addSubview:_time];
    
    _content.text=info.content;
    _content.font =[UIFont systemFontOfSize:15];
    
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
