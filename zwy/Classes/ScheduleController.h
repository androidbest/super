//
//  ScheduleController.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "scheduleView.h"
typedef enum
{
    tableView_ScheduleType_All=0,
    tableView_ScheduleType_Work,
    tableView_ScheduleType_Life,
    tableView_ScheduleType_Birthday,
    tableView_ScheduleType_Holiday
}tableViewScheduleType;

@interface ScheduleController : BaseController
@property (strong ,nonatomic)scheduleView * schedView;
@property (strong ,nonatomic)NSMutableArray * arrAll;
@property (strong ,nonatomic)NSMutableArray *arrWork;
@property (strong ,nonatomic)NSMutableArray *arrLife;
@property (strong ,nonatomic)NSMutableArray *arrBirthday;
@property (strong ,nonatomic)NSMutableArray *arrholiday;
@property (assign) BOOL *isInit;
@end
