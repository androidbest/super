//
//  ScheduleCell.h
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@interface ScheduleCell : UITableViewCell
@property (strong ,nonatomic)UILabel *labelTitle;
@property (strong ,nonatomic)UILabel *labelTime;
@property (strong ,nonatomic)UILabel *labelDays;
@property (strong ,nonatomic)UIView *contentViews;
@end
