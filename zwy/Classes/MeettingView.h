//
//  MeettingView.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface MeettingView : BaseView
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (strong, nonatomic) UITableView *tableViewPeople;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) UIButton *btnAddpeople;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *meetting_date;
@property (strong, nonatomic) IBOutlet UIImageView *meetting_time;
@property (strong, nonatomic) IBOutlet UILabel *atonce_time;
@property (strong, nonatomic) IBOutlet UIView *viewPeople;
@property (strong, nonatomic) UILabel *reciver;
@property (strong, nonatomic)  NSTimer *nsTimer;

- (void)setTaleViewframe;
@end
