//
//  MailDetailController.h
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MailDetail.h"
@interface MailDetailController : BaseController
@property (strong ,nonatomic)MailDetail * mailDetailView;
-(void)initStatus;
@end
