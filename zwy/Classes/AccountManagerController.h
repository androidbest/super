//
//  AccountManagerController.h
//  zwy
//
//  Created by wangshuang on 10/20/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "AccountManager.h"
@interface AccountManagerController : BaseController
@property (strong ,nonatomic)AccountManager * account;
-(void)startCell;
-(void)loginout;
@end
