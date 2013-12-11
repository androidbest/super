//
//  scheduleView.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "DetailTextView.h"
@interface scheduleView : BaseView
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelBirthday;
@property (strong ,nonatomic)PullRefreshTableView * tableViewAll;
@property (strong ,nonatomic)PullRefreshTableView * tableViewWork;
@property (strong ,nonatomic)PullRefreshTableView * tableViewLife;
@property (strong ,nonatomic)PullRefreshTableView * tableViewBirthday;
@property (strong ,nonatomic)PullRefreshTableView * tableViewHoliday;
@property (strong, nonatomic) IBOutlet UIImageView *imageFirst;
@property (strong ,nonatomic)UILabel *labelDays;

@end
