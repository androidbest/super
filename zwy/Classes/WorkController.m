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
    _workViews.navigationItem.title=@"日程提醒";
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

#pragma mark - newsScheduleDelegate
- (void)updataWarning:(warningDataInfo *)info{
    _workViews.info.warningDate=info.warningDate;
    _workViews.info.remainTime=info.remainTime;
    _workViews.info.content=info.content;
    
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
