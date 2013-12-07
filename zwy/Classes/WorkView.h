//
//  WorkView.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "warningDataInfo.h"
#import "scheduleView.h"
@interface WorkView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *labelLastTime;

@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

@property (strong, nonatomic)  UIView *dayBackgroudView1;
@property (strong, nonatomic)  UIView *dayBackgroudView2;
@property (strong ,nonatomic)warningDataInfo *info;
@property (strong, nonatomic) IBOutlet UIView *wariningBackView;

@property (assign)id WorkViewDelegate;
- (void)upDataScheduleList:(int)TableViewType;
@end
