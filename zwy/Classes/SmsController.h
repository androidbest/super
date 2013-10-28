//
//  SmsController.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "OfficeView.h"
#import "SmsView.h"
@interface SmsController : BaseController
@property (strong ,nonatomic)NSMutableArray * arrDidAllPeople;
@property (strong ,nonatomic)SmsView * smsView;
@end
