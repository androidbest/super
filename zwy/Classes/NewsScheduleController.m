//
//  NewsScheduleController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "NewsScheduleController.h"
#import "solarActionView.h"
#import "solarOrLunar.h"
#import "Date+string.h"
#import "ActionSheetView.h"
@implementation NewsScheduleController{

    BOOL isSolarTime;
    NSString *timeSolar;
    int reqeatType;
    int ScheduleType;
    NSCalendarUnit reqeatCalendar;
    BOOL isFirst;
    BOOL isReqeat;
    newsType newType;
    NSString *addWarning;
    NSString *editingWarning;
    NSString *removeWarning;
    
    
    
}
- (id)init{
    self =[super init];
    if (self) {
        isSolarTime=YES;
        isReqeat=NO;
        reqeatType=0;
        ScheduleType=0;
        addWarning=@"addWarning";
        editingWarning=@"editingWarning";
        removeWarning=@"removeWarning";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        timeSolar = [dateFormatter stringFromDate:[NSDate date]];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(editingWarningData:)
                                                    name:editingWarning
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(addWarningData:)
                                                    name:addWarning
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(removeWarningData:)
                                                    name:removeWarning
                                                  object:self];
    }
    return self;
}

- (void)initWithData{
    if (_newsView.info) {
        _newsView.textTitle.text=_newsView.info.content;
        
        if ([_newsView.info.warningType isEqualToString:@"2"]){
            timeSolar =_newsView.info.brithdayDate;
        }else {
            timeSolar =_newsView.info.warningDate;
        }
        
        
        [_newsView.btnOptionTime setTitle:timeSolar forState:UIControlStateNormal];
        
        /*是否置顶*/
          NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];
        NSDictionary *dic =[[NSDictionary alloc] initWithContentsOfFile:strPath];
        if ([dic[@"ID"] isEqualToString:_newsView.info.warningID]) {
            _newsView.btnFirst.on=YES;
            isFirst=YES;
        }else{
            _newsView.btnFirst.on=NO;
            isFirst=NO;
        }
        
        /*重复类型*/
        if (![_newsView.info.RequestType isEqualToString:@""]) {
           int reqeat=[_newsView.info.RequestType intValue];
            switch (reqeat) {
                case 0:
                    _newsView.labelReqeat.text=@"不重复";
                    self.newsView.switchReqeat.on=NO;
                    reqeatType=reqeat;
                    break;
                case 1:
                    _newsView.labelReqeat.text=@"每周";
                    reqeatType=reqeat;
                    break;
                case 2:
                    _newsView.labelReqeat.text=@"每月";
                    reqeatType=reqeat;
                    break;
                case 3:
                 _newsView.labelReqeat.text=@"每年";
                    reqeatType=reqeat;
                    
                    break;
                default:
                    break;
            }
        }else{
           self.newsView.switchReqeat.on=NO;
        }
        
        /*提醒类型*/
        if (![_newsView.info.warningType isEqualToString:@""]) {
            int reqeat=[_newsView.info.warningType intValue];
            switch (reqeat) {
                case 0:
                   [_newsView.btnClass setTitle:@"工作" forState:UIControlStateNormal];
                    break;
                case 1:
                   [_newsView.btnClass setTitle:@"生活" forState:UIControlStateNormal];
                    break;
                case 2:
                   [_newsView.btnClass setTitle:@"生日" forState:UIControlStateNormal];
                    [_newsView.switchReqeat setEnabled:NO];
                    break;
                case 3:
                   [_newsView.btnClass setTitle:@"节日" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            ScheduleType=reqeat;
        }else{
             [_newsView.btnClass setTitle:@"工作" forState:UIControlStateNormal];
        }
        
        newType =type_editing;
    }else{
        self.newsView.btnFirst.on=NO;
        self.newsView.switchReqeat.on=NO;
        newType =type_add;
    }
}

/*保存置顶信息*/
- (void)saveFristWarningWithID:(NSString *)ID{
    NSMutableDictionary *dicFirst=[[NSMutableDictionary alloc] init];
    [dicFirst setObject:_newsView.textTitle.text forKey:@"name"];/*提醒标题*/
    if (isSolarTime)[dicFirst setObject:@"0" forKey:@"solarOrLunar"];//时间类型（公历）
    else [dicFirst setObject:@"1" forKey:@"solarOrLunar"];//(农历)
    
    if (reqeatType==3)  [dicFirst setObject:[UpdataDate reqeatWithYearTodate:timeSolar] forKey:@"date"];//时间
    else if (reqeatType==2)  [dicFirst setObject:[UpdataDate reqeatWithMonthTodate:timeSolar] forKey:@"date"];//时间
    else if (reqeatType==1)  [dicFirst setObject:[UpdataDate reqeatWithWeekTodate:timeSolar] forKey:@"date"];//时间
    else [dicFirst setObject:timeSolar forKey:@"date"];
    [dicFirst setObject:ID forKey:@"ID"];//日程ID
    if (isReqeat)[dicFirst  setObject:[NSString stringWithFormat:@"%d",reqeatType] forKey:@"reqeatType"];//重复类型
    [dicFirst setObject:[NSString stringWithFormat:@"%d",ScheduleType] forKey:@"ScheduleType"];//日程类型
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];//设置地址
    [dicFirst writeToFile:strPath atomically:NO];//写入沙盒
}

/*修改置顶信息*/
- (void)deleteFirstWarningWithID:(NSString *)ID LocalNotificationWithDelete:(BOOL)isDeleteLocalNotification{
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];//设置地址
    BOOL isFirsts=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    if (isFirsts) {
        NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
        NSString *strWarningID=dic[@"ID"];
        if ([strWarningID isEqualToString:ID]) {
            [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
        }
    }
    
    if (isDeleteLocalNotification) {
         NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
         for(UILocalNotification*localNotification in allLocalNotification){
             NSString*alarmValue=[localNotification.userInfo objectForKey:@"ID"];
            if([ID isEqualToString:alarmValue]){
                 [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
                 }
             }
    }
    
}


#pragma mark -接收数据
/*修改回调*/
- (void)editingWarningData:(NSNotification *)notification{
    NSDictionary *dic =[notification userInfo];
    RespInfo *info =[AnalysisData ReTurnInfo:dic];
    
    UIImageView *imageView;
    UIImage *image ;
    if ([info.respCode isEqualToString:@"0"]) {
        /*保持置顶数据*/
        if (isFirst)[self saveFristWarningWithID:_newsView.info.warningID];
        else [self deleteFirstWarningWithID:_newsView.info.warningID LocalNotificationWithDelete:NO];
        /*********/

        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"修改成功";
        imageView = [[UIImageView alloc] initWithImage:image];
        self.HUD.customView=imageView;
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
        /*更新数据*/
        warningDataInfo *dataInfo=[warningDataInfo new];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *TimeNow = [formatter stringFromDate:[NSDate date]];
         int remainDays = [ToolUtils compareOneDay:TimeNow withAnotherDay:timeSolar];
        dataInfo.remainTime =[NSString stringWithFormat:@"%d",remainDays];
        dataInfo.warningDate=timeSolar;
        dataInfo.content=_newsView.textTitle.text;
        dataInfo.RequestType=[NSString stringWithFormat:@"%d",reqeatType];
        [_newsView.newsScheduleDelegate updataWarning:dataInfo];
        [self.newsView dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.HUD.labelText = @"修改失败";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
    }
}

/*删除回调*/
- (void)removeWarningData:(NSNotification *)notification{
    NSDictionary *dic =[notification userInfo];
    RespInfo *info =[AnalysisData ReTurnInfo:dic];
    
    UIImageView *imageView;
    UIImage *image ;
    if ([info.respCode isEqualToString:@"0"]) {
        /*删除置顶数据*/
        if (isFirst)[self deleteFirstWarningWithID:_newsView.info.warningID LocalNotificationWithDelete:YES];
        /*********/
        
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"删除成功";
        imageView = [[UIImageView alloc] initWithImage:image];
        self.HUD.customView=imageView;
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
        [self.newsView.newsScheduleDelegate deleteWarning:self.newsView];
        [self.newsView dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        self.HUD.labelText = @"删除失败";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
    }
}

/*添加回调*/
- (void)addWarningData:(NSNotification *)notification{
    NSDictionary *dic =[notification userInfo];
    RespInfo *info =[AnalysisData ReTurnInfo:dic];
    
    UIImageView *imageView;
    UIImage *image ;
    if ([info.respCode isEqualToString:@"0"]) {
        /*保持置顶数据*/
        if (isFirst) [self saveFristWarningWithID:info.ID];
        /*********/
        
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"添加成功";
        imageView = [[UIImageView alloc] initWithImage:image];
        self.HUD.customView=imageView;
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
        [self.newsView.newsScheduleDelegate upDataScheduleList:ScheduleType];
        [self.newsView dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.HUD.labelText = @"添加失败";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
    }
    


}

#pragma mark -按钮点击事件
- (void)btnBack{
    [self.newsView dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnSave{
    if (_newsView.textTitle.text.length==0) {
        [ToolUtils alertInfo:@"请设置内容"];
        [_newsView.textTitle becomeFirstResponder];
        return;
    }
    
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *warningDate =[formatter dateFromString:timeSolar];
    int isOk =[ToolUtils bigOrsmallOneDay:warningDate withAnotherDay:[NSDate date]];
    if (isOk<0&&!_newsView.switchReqeat.on) {
        [ToolUtils alertInfo:@"无效的日程"];
        return;
    }
    
    
    /*提交等待*/
    self.HUD =[[MBProgressHUD alloc] initWithView:self.newsView.view];
    self.HUD.labelText=@"正在提交..";
    [self.newsView.view addSubview:self.HUD];
    [self.HUD show:YES];
    
    
NSString *strTimeInterval=[NSString stringWithFormat:@"%f",[ToolUtils TimeStingWithInterVal:timeSolar]*1000];
    strTimeInterval =[[strTimeInterval componentsSeparatedByString:@"."] firstObject];
    if (newType==type_add) {
        [packageData addWarningData:self
                            content:_newsView.textTitle.text
                               Type:ScheduleType warningDate:strTimeInterval
                  warningRequstType:reqeatType
                            SELType:addWarning];
    }else{
        [packageData updateWarningData:self
                             warningID:_newsView.info.warningID
                               content:_newsView.textTitle.text
                                  Type:ScheduleType
                           warningDate:strTimeInterval
                     warningRequstType:reqeatType
                               SELType:editingWarning];
    }
 

    
}

/*删除*/
- (void)btnCancel{
    /*提交等待*/
    self.HUD =[[MBProgressHUD alloc] initWithView:self.newsView.view];
    self.HUD.labelText=@"正在提交..";
    [self.newsView.view addSubview:self.HUD];
    [self.HUD show:YES];
    [packageData deleteWarningData:self
                         warningID:_newsView.info.warningID
                           SELType:removeWarning];
}

- (void)btnClass{
    _sheetWarningType =[[UIActionSheet alloc] initWithTitle:@"重复类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"工作",@"生活",@"生日",@"节日",nil];
    _sheetWarningType.tag=1;
    [_sheetWarningType showInView:_newsView.view];
    
}

- (void)btnOptionTime{
    if (!timeSolar)timeSolar=_newsView.btnOptionTime.titleLabel.text;
    if (isSolarTime) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date =[dateFormatter dateFromString:timeSolar];
        ActionSheetView * sheet =[[ActionSheetView alloc] initWithViewdelegate:self WithSheetTitle:@"预约时间" sheetMode:0];
        sheet.firstDate=date;
        [sheet showInView:self.newsView.view];
    }else{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date =[dateFormatter dateFromString:timeSolar];
        /*弹出农历时间选择器*/
        solarActionView  *actionView =[[solarActionView alloc] initWithViewdelegate:self WithSheetTitle:@"农历" sheetMode:type_lunar];
        [actionView initWithDate:date];//设定初始时间
        [actionView showInView:self.newsView.view];
    }
}

#pragma mark -UISwitch点击事件
- (void)btnFirst:(UISwitch *)sender{
    isFirst=sender.on;
}

- (void)switchReqeat:(UISwitch *)sender{

    isReqeat=sender.on;
    if (isReqeat) {
        UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:@"重复类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"每周",@"每月",@"每年", nil];
        sheet.tag=0;
        [sheet showInView:_newsView.view];
    }
}

- (void)swithTimeType:(SevenSwitch *)sender {
    isSolarTime=sender.on;
    if (isSolarTime) {
         /*将当前的农历转换为公历*/
        [_newsView.btnOptionTime setTitle:timeSolar forState:UIControlStateNormal];
        
    }else{
        /*将当前的公历转换为农历*/
        NSArray *arr=[_newsView.btnOptionTime.titleLabel.text componentsSeparatedByString:@"-"];
        int year =[arr[0] intValue];
        int month =[arr[1] intValue];
        int day =[arr[2] intValue];
        timeSolar =[NSString stringWithFormat:@"%d-%d-%d",year,month,day];
        
        hjz lunar =solar_to_lunar(year, month, day);//将当前的公历时间转换为农历
        NSString *strYear =[NSString stringWithFormat:@"%d",lunar.year];
        strYear =[Date_string setYearBaseSting:strYear];
        NSString *strMonth =[NSString stringWithFormat:@"%dx%d",lunar.month,lunar.reserved];
        if (lunar.month<10) strMonth =[@"0" stringByAppendingString:strMonth];
        strMonth =[Date_string setMonthBaseSting:strMonth];
        NSString *strDay=[NSString stringWithFormat:@"%d",lunar.day];
        if (lunar.day<10) strDay =[@"0" stringByAppendingString:strDay];
        strDay=[Date_string setDayBaseSting:strDay];
        NSString *strLunarTime=[NSString stringWithFormat:@"%@年%@月%@日",strYear,strMonth,strDay];
        [_newsView.btnOptionTime setTitle:strLunarTime forState:UIControlStateNormal];
    }
}

#pragma mark - ActionSheetViewDetaSource
- (void)actionSheetSolarDate:(NSString *)year Month:(NSString *)month Day:(NSString *)day reserved:(NSString *)reserved{
    /*reserved＝1为闰月*/
    /*
        NSLog(@"lunar:%@-%@-%@-%@",year,month,day,reserved);
     */
    int year_ =[year intValue];
    int month_ =[month intValue];
    int day_ =[day intValue];
    int reserved_ =[reserved intValue];
    hjz solar =lunar_to_solar(year_, month_, day_, reserved_);
    timeSolar =[NSString stringWithFormat:@"%d-%d-%d",solar.year,solar.month,solar.day];
}

- (void)actionSheetTitleDateText:(NSString *)year Month:(NSString *)month day:(NSString *)day{
    NSString * strTime =[NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    [_newsView.btnOptionTime setTitle:strTime forState:UIControlStateNormal];
}

- (void)actionSheetTimeText:(NSString *)Text{
    NSArray *arr=[Text componentsSeparatedByString:@"/"];
    NSString *strYear=arr[0];
    NSString *strMonth=arr[1];
    NSString *strDay=arr[2];
    NSString *strTime =[NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
    [_newsView.btnOptionTime setTitle:strTime forState:UIControlStateNormal];
    timeSolar=strTime;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==0) {
        
          if (buttonIndex==3)
          {   _newsView.switchReqeat.on=NO;
              return;}
        switch (buttonIndex) {
            case 0:
                [_newsView.labelReqeat setText:@"每周"];
                break;
            case 1:
                [_newsView.labelReqeat setText:@"每月"];
                break;
            case 2:
                [_newsView.labelReqeat setText:@"每年"];
                break;
            case 3:
//                [_newsView.labelReqeat setText:@"每日"];
                break;
            default:
                break;
        }
        reqeatType=buttonIndex+1;
    }
    
    if (actionSheet.tag==1) {
        if (buttonIndex==4)return;
        switch (buttonIndex) {
            case 0:{
                [_newsView.btnClass setTitle:@"工作" forState:UIControlStateNormal];
                [_newsView.switchReqeat setEnabled:YES];}
                break;
            case 1:{
                [_newsView.btnClass setTitle:@"生活" forState:UIControlStateNormal];
                [_newsView.switchReqeat setEnabled:YES];}
                break;
            case 2:{
                [_newsView.btnClass setTitle:@"生日" forState:UIControlStateNormal];
                _newsView.switchReqeat.on=YES;
                [_newsView.switchReqeat setEnabled:NO];
                [_newsView.labelReqeat setText:@"每年"];
                reqeatType=3;
            }
                break;
            case 3:{
                [_newsView.btnClass setTitle:@"节日" forState:UIControlStateNormal];
                [_newsView.switchReqeat setEnabled:YES];}
                break;
            default:
                break;
        }
        ScheduleType=buttonIndex;
    }

}
@end
