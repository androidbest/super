//
//  NewsScheduleController.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "NewsScheduleView.h"

typedef enum
{
    type_add,
    type_editing
}newsType;

@interface NewsScheduleController : BaseController

@property (strong ,nonatomic)NewsScheduleView * newsView;
@property (strong ,nonatomic)UIActionSheet *sheetWarningType;

/*删除置顶信息*/
+ (void)deleteFirstWarningWithID:(NSString *)ID LocalNotificationWithDelete:(BOOL)isDeleteLocalNotification;

@end
