//
//  CallTelController.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-11.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "BaseController.h"
#import "CallTelView.h"
@interface CallTelController : BaseController
@property (strong ,nonatomic)CallTelView *  callView;
@property (strong ,nonatomic)NSString * strTel;
@property (strong ,nonatomic)NSMutableArray *arrAllPeople;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
@end
