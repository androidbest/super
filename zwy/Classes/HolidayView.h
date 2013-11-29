//
//  HolidayView.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "warningDataInfo.h"
#import "scheduleView.h"
@interface HolidayView : BaseView

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *lableDate;
@property (strong, nonatomic) IBOutlet UILabel *LableDays;
@property (strong, nonatomic) PullRefreshTableView *tableViewSMSMode;
@property (strong, nonatomic) warningDataInfo *info;
@property (assign)id HolidayViewDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageFirst;
- (void)upDataScheduleList:(int)TableViewType;
@end
