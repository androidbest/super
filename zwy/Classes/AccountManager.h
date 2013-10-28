//
//  AccountManager.h
//  zwy
//
//  Created by wangshuang on 10/20/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface AccountManager : BaseView
@property (strong, nonatomic) IBOutlet UITableView *accountList;
@property (strong, nonatomic) IBOutlet UIButton *logout;

@end
