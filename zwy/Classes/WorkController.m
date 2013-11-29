//
//  WorkController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "WorkController.h"
#import "NewsScheduleView.h"
@implementation WorkController
{

}

- (id)init{
    self =[super init];
    if (self) {
        
    }
    return self;
}

- (void)initWithData{
    
    if (dicLocalNotificationInfo&&isLocalNotification) {
        _workViews.info=[warningDataInfo new];
        _workViews.info.content=dicLocalNotificationInfo[@"content"];
        _workViews.info.warningID=dicLocalNotificationInfo[@"ID"];
        _workViews.info.RequestType=dicLocalNotificationInfo[@"RequestType"];
        _workViews.info.warningDate=dicLocalNotificationInfo[@"warningDate"];
        _workViews.info.warningType=dicLocalNotificationInfo[@"warningType"];
        _workViews.info.UserTel=dicLocalNotificationInfo[@"UserTel"];
        _workViews.info.remainTime=dicLocalNotificationInfo[@"remainTime"];
        dicLocalNotificationInfo=nil;
        isLocalNotification=NO;
    }
    
    
    
    if ([_workViews.info.warningType isEqualToString:@"0"]) {
        _workViews.navigationItem.title=@"工作安排";
    }else{
        _workViews.navigationItem.title=@"生活提醒";
    }
    
    
    _workViews.labelDate.text=_workViews.info.warningDate;
    _workViews.labelLastTime.text=_workViews.info.remainTime;
    
    NSString *strTitle;
    if ([_workViews.info.warningType isEqualToString:@"2"]) {
        strTitle =[NSString stringWithFormat:@"距离%@生日还有",_workViews.info.content];
    }else{
        strTitle =[NSString stringWithFormat:@"距离%@还有",_workViews.info.content];
    }
    _workViews.labelTitle.text=strTitle;
}

/*删除日程后消除view*/
- (void)deleteWarning:(NewsScheduleView *)newsView{
    [self performSelector:@selector(deleteWarningView) withObject:self afterDelay:0.1];
    
}
- (void)deleteWarningView{
    int scheduleType =[_workViews.info.warningType intValue];
    [_workViews.WorkViewDelegate upDataScheduleList:scheduleType];
    [self.workViews.navigationController popViewControllerAnimated:YES];
}


#pragma mark - newsScheduleDelegate
- (void)updataWarning:(warningDataInfo *)info{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//初始化转换格式
    [formatter setDateFormat:@"yyyy-MM-dd"];//设置转换格式
    NSString *TimeNow = [formatter stringFromDate:[NSDate date]];
    
    if ([info.RequestType isEqualToString:@"3"]) {
        info.warningDate =[UpdataDate reqeatWithYearTodate:info.warningDate];
    }else if([info.RequestType isEqualToString:@"2"]){
        info.warningDate =[UpdataDate reqeatWithMonthTodate:info.warningDate];
    }else if([info.RequestType isEqualToString:@"1"]){
        info.warningDate =[UpdataDate reqeatWithWeekTodate:info.warningDate];
    }
    int remainDays = [ToolUtils compareOneDay:TimeNow withAnotherDay:info.warningDate];
    info.remainTime  =[NSString stringWithFormat:@"%d",remainDays];
    
    _workViews.info.warningDate=info.warningDate;
    _workViews.info.remainTime=info.remainTime;
    _workViews.info.content=info.content;
    _workViews.info.RequestType=info.RequestType;
    
    _workViews.navigationItem.title=@"日程提醒";
    _workViews.labelDate.text=info.warningDate;
    _workViews.labelLastTime.text=info.remainTime;
    
    NSString *strTitle;
    if ([_workViews.info.warningType isEqualToString:@"2"]) {
        strTitle =[NSString stringWithFormat:@"距离%@生日还有",info.content];
    }else{
        strTitle =[NSString stringWithFormat:@"距离%@还有",info.content];
    }
    _workViews.labelTitle.text=strTitle;
    
    int scheduleType =[_workViews.info.warningType intValue];
    [_workViews.WorkViewDelegate upDataScheduleList:scheduleType];
}

#pragma mark - 按钮实现方法
-  (void)btnEditing{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    detaView.info=_workViews.info;
    [self.workViews presentViewController:detaView animated:YES completion:nil];
    detaView.newsScheduleDelegate=self;
    
}

@end
