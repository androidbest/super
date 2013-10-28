//
//  MyAddressView.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-8.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMTableViewIndexBar.h"
#import "BaseView.h"

@interface MyAddressView : BaseView
@property (strong, nonatomic) IBOutlet UITableView *tableViewAddress;
@property (weak ,nonatomic) IBOutlet  AIMTableViewIndexBar *indexBar;
@end
