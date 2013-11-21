//
//  HolidayView.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface HolidayView : BaseView

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *lableDate;
@property (strong, nonatomic) IBOutlet UILabel *LableDays;
@property (strong, nonatomic) PullRefreshTableView *tableViewSMSMode;
@end
