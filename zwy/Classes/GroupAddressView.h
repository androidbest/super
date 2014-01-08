//
//  GroupAddressView.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-9.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface GroupAddressView : BaseView
@property (weak, nonatomic) IBOutlet UITableView *tableViewGroup;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong ,nonatomic)NSMutableArray *arrAllPeople;

@end
