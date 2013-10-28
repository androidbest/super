//
//  AccessoryView.h
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface AccessoryView : BaseView
@property (weak, nonatomic) IBOutlet UITableView *tableViewDowning;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEndDown;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@end
