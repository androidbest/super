//
//  MailAddressController.h
//  zwy
//
//  Created by cqsxit on 13-10-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MailAddressView.h"
@interface MailAddressController : BaseController
@property(strong ,nonatomic)MailAddressView * mailView;
@property (strong ,nonatomic)NSMutableArray * allPeople;
@end
