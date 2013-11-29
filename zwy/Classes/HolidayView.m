//
//  HolidayView.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "HolidayView.h"
#import "HolidayController.h"
#import "DetailTextView.h"
@interface HolidayView ()

@end

@implementation HolidayView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        HolidayController *contro =[HolidayController new];
        self.controller =contro;
        contro.holiView=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self.controller action:@selector(btnEditing)];
    self.navigationItem.rightBarButtonItem=rightButton;
	int height =topLayout+67;
    _tableViewSMSMode  =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, height, ScreenWidth,ScreenHeight-height) withDelegate:self.controller];
    _tableViewSMSMode.tag=0;
    _tableViewSMSMode.separatorStyle = NO;
    [self.view addSubview:_tableViewSMSMode];
    [_tableViewSMSMode LoadDataBegin];/*刷新数据*/
    [self.controller initWithData];
    
    _imageFirst.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(PushMassTextView)];
    [_imageFirst addGestureRecognizer:tapGesture];
}

- (void)btnEditing{
    
}

- (void)PushMassTextView{
    
}

- (void)upDataScheduleList:(int)TableViewType{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
