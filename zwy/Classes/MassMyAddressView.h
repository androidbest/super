//
//  MassMyAddressView.h
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface MassMyAddressView : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UIButton *btnCencel;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAddress;
@property (assign ,nonatomic)id MassDelegate;
- (void)returnDidAddress:(NSArray *)arr;
@end
