//
//  HolidayController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "HolidayController.h"
#import "NewsScheduleView.h"
#import "MassTextingView.h"
#import "DetailTextView.h"
#import "TemplateCell.h"
#import "HolidayCalendarView.h"
@implementation HolidayController{
    int pages;
    NSString * strGreetingType;
    NSString * getGreetingNotificaion;
    NSString * AddGreetingCountNotification;
}


- (id)init{
    self =[super init];
    if (self) {
        pages=1;
        getGreetingNotificaion=@"getGreetingNotificaion";
        AddGreetingCountNotification=@"AddGreetingCountNotification";
        _arrSMSMode =[NSMutableArray new];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(getGreetingNotificaionData:)
                                                    name:getGreetingNotificaion
                                                  object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(AddGreetingCountNotificationData:)
                                                    name:AddGreetingCountNotification
                                                  object:self];
    }
    return self;
}

- (void)initWithData{
    if (dicLocalNotificationInfo) {
        _holiView.info=[warningDataInfo new];
        _holiView.info.content=dicLocalNotificationInfo[@"content"];
        _holiView.info.warningID=dicLocalNotificationInfo[@"ID"];
        _holiView.info.RequestType=dicLocalNotificationInfo[@"RequestType"];
        _holiView.info.warningDate=dicLocalNotificationInfo[@"warningDate"];
        _holiView.info.warningType=dicLocalNotificationInfo[@"warningType"];
        _holiView.info.UserTel=dicLocalNotificationInfo[@"UserTel"];
        _holiView.info.remainTime=dicLocalNotificationInfo[@"remainTime"];
        dicLocalNotificationInfo=nil;
    }
    
    
    
    if ([_holiView.info.warningType isEqualToString:@"2"]) {
        _holiView.navigationItem.title=@"生日祝福";
    }else{
        _holiView.navigationItem.title=@"节日祝福";
    }
    
    _holiView.LableDays.attributedText =[DetailTextView setDateAttributedString:_holiView.info.remainTime];
    if ([_holiView.info.warningType isEqualToString:@"2"]&&![_holiView.info.isUserHandAdd isEqualToString:@"0"]){
        _holiView.labelName.text=[NSString stringWithFormat:@"%@ 的生日",_holiView.info.content];
        _holiView.lableDate.text=_holiView.info.brithdayDate;
    }
    else {
        _holiView.labelName.text=_holiView.info.content;
        _holiView.lableDate.text=_holiView.info.warningDate;
    }
    
    strGreetingType =_holiView.info.greetingType;
}

/*删除日程后消除view*/
- (void)deleteWarning:(NewsScheduleView *)newsView{
    [self performSelector:@selector(deleteWarningView) withObject:self afterDelay:0.1];
}
- (void)deleteWarningView{
    int scheduleType =[_holiView.info.warningType intValue];
    [_holiView.HolidayViewDelegate upDataScheduleList:scheduleType];
    [self.holiView.navigationController popViewControllerAnimated:YES];
}

#pragma mark - newsScheduleDelegate
- (void)updataWarning:(warningDataInfo *)info{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//初始化转换格式
    [formatter setDateFormat:@"yyyy-MM-dd"];//设置转换格式
    NSString *TimeNow = [formatter stringFromDate:[NSDate date]];
    
    _holiView.info.brithdayDate=info.warningDate;
    
    if ([info.RequestType isEqualToString:@"3"]) {
        info.warningDate =[UpdataDate reqeatWithYearTodate:info.warningDate];
    }else if([info.RequestType isEqualToString:@"2"]){
        info.warningDate =[UpdataDate reqeatWithMonthTodate:info.warningDate];
    }else if([info.RequestType isEqualToString:@"1"]){
        info.warningDate =[UpdataDate reqeatWithWeekTodate:info.warningDate];
    }
    int remainDays = [ToolUtils compareOneDay:TimeNow withAnotherDay:info.warningDate];
    info.remainTime  =[NSString stringWithFormat:@"%d",remainDays];
    
    _holiView.info.remainTime=info.remainTime;
    _holiView.info.content=info.content;
    _holiView.info.warningDate=info.warningDate;
    _holiView.info.RequestType=info.RequestType;
    
    _holiView.LableDays.attributedText =[DetailTextView setDateAttributedString:info.remainTime];
    
    if ([_holiView.info.warningType isEqualToString:@"2"]&&![_holiView.info.isUserHandAdd isEqualToString:@"0"]){
     _holiView.labelName.text=[NSString stringWithFormat:@"%@ 的生日",info.content];
     _holiView.lableDate.text=_holiView.info.brithdayDate;
    }
    else {
     _holiView.lableDate.text=_holiView.info.warningDate;
     _holiView.labelName.text=info.content;
    }
   
    int scheduleType =[_holiView.info.warningType intValue];
    [_holiView.HolidayViewDelegate upDataScheduleList:scheduleType];
}

#pragma mark - 接收数据
- (void)getGreetingNotificaionData:(NSNotification *)notification{
    if (_arrSMSMode.count>0) {
        [_arrSMSMode removeAllObjects];
    }
    NSDictionary *dic =[notification userInfo];
    GreetingInfo *info =[AnalysisData getGreetingList:dic];
    if (info.arrGreetList.count>0) {
        [_arrSMSMode addObjectsFromArray:info.arrGreetList];
    }else{
    
    }
    _holiView.tableViewSMSMode.separatorStyle=YES;
    _holiView.tableViewSMSMode.reachedTheEnd=NO;
    [_holiView.tableViewSMSMode reloadDataPull];
}

- (void)AddGreetingCountNotificationData:(NSNotification *)notification{
//    NSDictionary *dic =[notification userInfo];
//    RespInfo *info =[AnalysisData ReTurnInfo:dic];
//    if ([info.respCode isEqualToString:@"0"]) {
        [packageData getGreetings:self greetingType:strGreetingType SELType:getGreetingNotificaion];
//    }
}

#pragma mark - 按钮实现方法
- (void)btnEditing{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    detaView.strTitle=@"生日祝福";
    detaView.info=_holiView.info;
    [self.holiView presentViewController:detaView animated:YES completion:nil];
    detaView.newsScheduleDelegate=self;
}

- (void)btnCalendar{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HolidayCalendarView *hoView=[storyboard instantiateViewControllerWithIdentifier:@"HolidayCalendarView"];
    hoView.holidayName=_holiView.info.content;
    [self.holiView.navigationController pushViewController:hoView animated:YES];
}


#pragma mark - UITableViewDataSoures
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrSMSMode.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  static NSString *CellIdentifier = @"Cell";
    
    // lable.text=[info.AllSMSContent[indexPath.row] content];
    static NSString * strCell2 =@"cell2";
    TemplateCell *  cell =[tableView dequeueReusableCellWithIdentifier:strCell2];
    if (!cell) {
        cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell2];
        cell.greetingCount.hidden=NO;
    }
    GreetDetaInfo *info =_arrSMSMode[indexPath.row];
    cell.content.text=info.Content;
    cell.content.textColor=[UIColor blackColor];
    CGRect textRect = [cell.content.text boundingRectWithSize:CGSizeMake(280.0f, 1000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:cell.content.font}
                                                      context:nil];
    CGRect rect=cell.content.frame;
    rect.size=textRect.size;
    rect.origin.y=15;
    rect.origin.x=15;
    cell.content.frame=rect;
    rect =cell.frame;
    rect.size.height=cell.content.frame.size.height+40;
    cell.frame=rect;
    
    
    rect=cell.greetingCount.frame;
    rect.origin.y=cell.frame.size.height-30;
    cell.greetingCount.frame=rect;
    cell.greetingCount.attributedText =[DetailTextView setGreetingTitleAttributedString:info.greetingcount];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MassTextingView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"MassTextingView"];
    detaView.isSchedule=YES;
    detaView.detaInfo=_arrSMSMode[indexPath.row];
    if ([_holiView.info.warningType isEqualToString:@"2"])  detaView.strFromGeetingName=_holiView.info.content;
    detaView.massTextDelegate=self;
    [self.holiView.navigationController pushViewController:detaView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)PushMassTextView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MassTextingView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"MassTextingView"];
    detaView.isSchedule=YES;
    if ([_holiView.info.warningType isEqualToString:@"2"])  detaView.strFromGeetingName=_holiView.info.content;
    detaView.massTextDelegate=self;
    [self.holiView.navigationController pushViewController:detaView animated:YES];
}

/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    [packageData getGreetings:self greetingType:strGreetingType SELType:getGreetingNotificaion];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [self.holiView.tableViewSMSMode scrollViewDidPullScroll:scrollView];
}

#pragma mark - massTextDelegate;
- (void)massTextInfoFromWarningViewWithGreetingID:(GreetDetaInfo *)GreetInfo{
    [packageData updateGreetingCount:self
                          greetingID:GreetInfo.ID
                       greetingCount:GreetInfo.greetingcount
                             SELType:AddGreetingCountNotification];
}
@end
