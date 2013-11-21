//
//  ActionSheetView.m
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "ActionSheetView.h"

@implementation ActionSheetView
{
    NSInteger sheetMode;
    long long time;
    NSString *timeText;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithViewdelegate:(id)delegate WithSheetTitle:(NSString *)_title sheetMode:(NSInteger)Mode{
    self=[super init];
    NSString * strTitle;
    if (self) {
        strTitle =[NSString stringWithFormat:@"%@%@",_title,@"\n\n\n\n\n\n\n\n\n\n\n\n"];
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        sheetMode=Mode;
        _DetaSource=delegate;
    }
    return [self initWithTitle:strTitle
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:@"确定",nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _dataSetView =[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 216)];
    if (_firstDate)[_dataSetView setDate:_firstDate];
    [_dataSetView addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    if (sheetMode==0) {
        _dataSetView.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
       [formatter setDateFormat:@"yyyy/MM/dd"];
        timeText = [formatter stringFromDate:[NSDate date]];
        if (_firstDate)timeText = [formatter stringFromDate:_firstDate];
    }
    else {
        _dataSetView.datePickerMode=UIDatePickerModeTime;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        timeText = [formatter stringFromDate:[NSDate date]];
        if (_firstDate)timeText = [formatter stringFromDate:_firstDate];
    }
   
    _dataSetView.tag=0;
    [self addSubview:_dataSetView];

}

- (void)setFirstDate:(NSDate *)firstDate{
    _firstDate=firstDate;
}

#pragma  mark - 选择时间回调
- (void)dateChanged{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];//创建日期时间格式对象
    if (sheetMode==0) [dateFormatter setDateFormat:@"yyyy/MM/dd"];//设置日期时间格式
        else [dateFormatter setDateFormat:@"HH:mm"];//设置日期时间格式

    NSString * dateAndTime = [dateFormatter stringFromDate:_dataSetView.date];//得到字符串  选择的日期间
    timeText = dateAndTime;
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [_DetaSource actionSheetTimeText:timeText];
    }
}

//- (void)weiboBtn:(id)sender{
//    UIButton * btn =(UIButton*)sender;
//    [self dismissWithClickedButtonIndex:btn.tag animated:YES];
//    [self.delegate actionSheet:self clickedButtonAtIndex:btn.tag];
//}

@end
