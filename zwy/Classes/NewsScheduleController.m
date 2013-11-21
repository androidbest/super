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
    NSString *timeLunar;
    int reqeatType;
    int ScheduleType;

}
- (id)init{
    self =[super init];
    if (self) {
        isSolarTime=YES;
    
    }
    return self;
}

- (void)initWithData{
    self.newsView.btnFirst.on=NO;
}

#pragma mark -按钮点击事件
- (void)btnBack{
    [self.newsView dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnSave{

}

- (void)btnCancel{
    [self.newsView dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnClass{
    UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:@"重复类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"工作",@"生活",@"生日",@"节日", nil];
    sheet.tag=1;
    [sheet showInView:_newsView.view];
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

/*UISwitch点击事件*/
- (void)btnFirst:(UISwitch *)sender{
    
}

- (void)switchReqeat:(UISwitch *)sender{
    if (sender.on) {
        UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:@"重复类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"每年",@"每月",@"每周",@"每日",@"每小时", nil];
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
        switch (buttonIndex) {
            case 0:
                [_newsView.labelReqeat setText:@"每年"];
                break;
            case 1:
                [_newsView.labelReqeat setText:@"每月"];
                break;
            case 2:
                [_newsView.labelReqeat setText:@"每周"];
                break;
            case 3:
                [_newsView.labelReqeat setText:@"每日"];
                break;
            case 4:
                [_newsView.labelReqeat setText:@"每小时"];
                break;
            default:
                break;
        }
    }
    
    if (actionSheet.tag==1) {
        switch (buttonIndex) {
            case 0:
                [_newsView.btnClass setTitle:@"工作" forState:UIControlStateNormal];
                break;
            case 1:
                [_newsView.btnClass setTitle:@"生活" forState:UIControlStateNormal];
                break;
            case 2:
                [_newsView.btnClass setTitle:@"生日" forState:UIControlStateNormal];
                break;
            case 3:
                [_newsView.btnClass setTitle:@"节日" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }

}
@end
