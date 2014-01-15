//
//  optionAddress.h
//  zwy
//
//  Created by cqsxit on 13-10-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface optionAddress : BaseView
@property (weak, nonatomic) IBOutlet UITableView *tableViewAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UIButton *btnCencel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (assign ,nonatomic)id optionDelegate;
@property (assign ,nonatomic)BOOL isECMember;
- (void)returnDidAddress:(NSArray *)arr;
@end
