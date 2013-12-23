//
//  scheduleView.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "scheduleView.h"
#import "ScheduleController.h"
#import "NewsScheduleView.h"

@interface scheduleView ()

@end

@implementation scheduleView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        ScheduleController *schedControl =[ScheduleController new];
        schedControl.schedView=self;
        self.controller=schedControl;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
        [_segControl addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    int height =topLayout+80+25;
    _tableViewAll =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0,height, ScreenWidth, ScreenHeight-height) withDelegate:self.controller];//所有日程
    _tableViewAll.tag=0;
    _tableViewAll.separatorStyle = NO;
    [self.view addSubview:_tableViewAll];
    [_tableViewAll LoadDataBegin];/*刷新数据*/
    
    
    _tableViewWork =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0,height, ScreenWidth, ScreenHeight-height) withDelegate:self.controller];//工作日程
    _tableViewWork.tag=1;
    _tableViewWork.separatorStyle = NO;
    _tableViewWork.hidden=YES;
    [self.view addSubview:_tableViewWork];
    
    
    _tableViewLife=[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0,height, ScreenWidth, ScreenHeight-height) withDelegate:self.controller];//生活日程
    _tableViewLife.tag=2;
    _tableViewLife.separatorStyle = NO;
    _tableViewLife.hidden=YES;
    [self.view addSubview:_tableViewLife];
    
    
    _tableViewBirthday=[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0,height, ScreenWidth, ScreenHeight-height) withDelegate:self.controller];//生日日程
    _tableViewBirthday.tag=3;
    _tableViewBirthday.separatorStyle = NO;
     _tableViewBirthday.hidden=YES;
    [self.view addSubview:_tableViewBirthday];
    
    
    _tableViewHoliday =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0,height, ScreenWidth, ScreenHeight-height) withDelegate:self.controller];//节日日程
    _tableViewHoliday.tag=4;
    _tableViewHoliday.separatorStyle = NO;
    _tableViewHoliday.hidden=YES;
    [self.view addSubview:_tableViewHoliday];
    
    /*CGRectMake(ScreenWidth-120, 90, 100, 25)*/
    _labelDays=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-180, 80, 170, 40)];
    _labelDays.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:_labelDays];
    

    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.controller action:@selector(btnAddSchedule)];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    [self.controller initWithData];
    
    _imageFirst.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(PushMassTextView)];
    [_imageFirst addGestureRecognizer:tapGesture];
}

-(void)segmentAction:(UISegmentedControl *)Seg{}

- (void)btnAddSchedule{}

- (void)PushMassTextView{}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden)self.navigationController.navigationBarHidden=NO;
    
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];
     BOOL isFirst=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    if (isFirst) {
        NSDictionary *dic =[[NSDictionary alloc] initWithContentsOfFile:strPath];
        NSString *strDate=dic[@"date"];
        NSString *strReqeat=dic[@"reqeatType"];
        if ([strReqeat isEqualToString:@"3"]) {
            strDate =[UpdataDate reqeatWithYearTodate:strDate];
        }else if([strReqeat isEqualToString:@"2"]) {
            strDate =[UpdataDate reqeatWithMonthTodate:strDate];
        }else if([strReqeat isEqualToString:@"1"]) {
            strDate =[UpdataDate reqeatWithWeekTodate:strDate];
        }
        _labelBirthday.text=strDate;
        
        NSString *strContent=dic[@"name"];
        if ([dic[@"ScheduleType"] isEqualToString:@"2"]&&![dic[@"dataType"] isEqualToString:@"0"]) {
        strContent=[NSString stringWithFormat:@"%@ 的生日",dic[@"name"] ];
        }
        _labelName.text=strContent;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *TimeNow = [formatter stringFromDate:[NSDate date]];
        int remainDays = [ToolUtils compareOneDay:TimeNow withAnotherDay:strDate];
        NSString *strDays=[NSString stringWithFormat:@"%d",remainDays];
         _labelDays.attributedText =[DetailTextView setDateAttributedString:strDays];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
