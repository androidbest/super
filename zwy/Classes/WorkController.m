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
    
    if (dicLocalNotificationInfo) {
        _workViews.info=[warningDataInfo new];
        _workViews.info.content=dicLocalNotificationInfo[@"content"];
        _workViews.info.warningID=dicLocalNotificationInfo[@"ID"];
        _workViews.info.RequestType=dicLocalNotificationInfo[@"RequestType"];
        _workViews.info.warningDate=dicLocalNotificationInfo[@"warningDate"];
        _workViews.info.warningType=dicLocalNotificationInfo[@"warningType"];
        _workViews.info.UserTel=dicLocalNotificationInfo[@"UserTel"];
        _workViews.info.remainTime=dicLocalNotificationInfo[@"remainTime"];
        dicLocalNotificationInfo=nil;
    }
    
    
    
    if ([_workViews.info.warningType isEqualToString:@"0"]) {
        _workViews.navigationItem.title=@"工作安排";
    }else{
        _workViews.navigationItem.title=@"生活提醒";
    }
    
    
    _workViews.labelDate.text=_workViews.info.warningDate;
    _workViews.labelLastTime.text=[_workViews.info.remainTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self setLabelLastTimeBackgroudViewFrame:_workViews.labelLastTime.text.length];
    
    NSString *strTitle;
    if ([_workViews.info.warningType isEqualToString:@"2"]) {
        if (_workViews.info.remainTimeInt<0)

        strTitle =[NSString stringWithFormat:@"距离%@生日%@",_workViews.info.content,_workViews.info.remainTimeInt<0? @"已过":@"还有"];
    
    }else{
        strTitle =[NSString stringWithFormat:@"距离%@%@",_workViews.info.content,_workViews.info.remainTimeInt<0? @"已过":@"还有"];
    }
    _workViews.labelTitle.text=strTitle;
}

/*设置labelLastTime背景图大小*/
- (void)setLabelLastTimeBackgroudViewFrame:(float)textLength{
    CGRect rect =_workViews.dayBackgroudView1.frame;
    rect.size.width=40+24*textLength;
    _workViews.dayBackgroudView1.frame=rect;
    _workViews.dayBackgroudView1.center=CGPointMake(_workViews.view.center.x-14, _workViews.dayBackgroudView1.center.y);

    rect =_workViews.dayBackgroudView2.frame;
    rect.size.width=40+24*textLength;
    _workViews.dayBackgroudView2.frame=rect;
    _workViews.dayBackgroudView2.center=CGPointMake(_workViews.view.center.x-14, _workViews.dayBackgroudView2.center.y);
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
    _workViews.labelLastTime.text=[info.remainTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self setLabelLastTimeBackgroudViewFrame:_workViews.labelLastTime.text.length];
    
    NSString *strTitle;
    if ([_workViews.info.warningType isEqualToString:@"2"]) {
        strTitle =[NSString stringWithFormat:@"距离%@生日%@",info.content,info.remainTimeInt<0?@"已过":@"还有"];
    }else{
        strTitle =[NSString stringWithFormat:@"距离%@%@",info.content,info.remainTimeInt<0?@"已过":@"还有"];
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
