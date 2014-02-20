//
//  HolidayCalendarView.h
//  zwy
//
//  Created by cqsxit on 14-2-20.
//  Copyright (c) 2014年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface HolidayCalendarView : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnCalendar;
@property (strong, nonatomic) IBOutlet UIButton *btnDown;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) NSString *holidayName;
@end
