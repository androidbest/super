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
{
    NSArray *arrHolidayName;
}
@end

@implementation HolidayView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        HolidayController *contro =[HolidayController new];
        self.controller =contro;
        contro.holiView=self;
        
        arrHolidayName =@[@"春节",@"端午节",@"中秋节",@"国庆节",@"劳动节",@"清明节"];
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
    
    /*隐藏节假日详情按钮*/
    [_btnCalendar addTarget:self.controller action:@selector(btnCalendar) forControlEvents:UIControlEventTouchUpInside];
     _btnCalendar.hidden=![arrHolidayName containsObject:_info.content];
    
    NSTimeInterval HolidayDate =[ToolUtils TimeStingWithInterVal:_info.warningDate];
    NSTimeInterval NowDate =[ToolUtils TimeStingWithInterVal:@"2014-12-31"];
     if(!_btnCalendar.hidden) _btnCalendar.hidden =HolidayDate>NowDate ? YES :NO;
}

- (void)btnEditing{
    
}

- (void)PushMassTextView{
    
}

- (void)upDataScheduleList:(int)TableViewType{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
