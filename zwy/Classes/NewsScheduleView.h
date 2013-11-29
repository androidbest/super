//
//  NewsScheduleView.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "SevenSwitch.h"
#import "scheduleView.h"
#import "warningDataInfo.h"
@interface NewsScheduleView : BaseView
@property (strong, nonatomic) IBOutlet UITextField *textTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnClass;
@property (strong, nonatomic) IBOutlet UISwitch *btnFirst;
@property (strong, nonatomic) IBOutlet UISwitch *switchReqeat;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBarNews;
@property (strong, nonatomic) IBOutlet UIButton *btnOptionTime;
@property (strong, nonatomic) IBOutlet UILabel *labelReqeat;
@property (strong, nonatomic) SevenSwitch * swithTimeType;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) scheduleView *schedView;
@property (strong, nonatomic) PullRefreshTableView *tableViewShedule;
@property (strong, nonatomic) warningDataInfo *info;
@property (assign)id newsScheduleDelegate;
- (void)updataWarning:(warningDataInfo *)info;
- (void)upDataScheduleList:(int)TableViewType;
- (void)deleteWarning:(NewsScheduleView *)newsView;
@end
