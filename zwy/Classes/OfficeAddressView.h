//
//  OfficeAddressView.h
//  zwy
//
//  Created by cqsxit on 13-10-20.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PullRefreshTableView.h"
@interface OfficeAddressView : BaseView
@property (strong, nonatomic) PullRefreshTableView *tableViewGroup;
@property (strong ,nonatomic) PullRefreshTableView *tableViewPeople;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmation;
@property (weak, nonatomic) IBOutlet UIButton *btnCencel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnSuperior;
@property (strong ,nonatomic)UISegmentedControl *segmentedControl;
@property (assign ,nonatomic)id officeDelegate;
- (void)returnDidAddress:(NSArray *)arr;
@end
