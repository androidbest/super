//
//  OfficeAddressController.h
//  zwy
//
//  Created by cqsxit on 13-10-20.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "OfficeAddressView.h"
@interface OfficeAddressController : BaseController
@property (strong ,nonatomic)OfficeAddressView * officeView;
@property (strong ,nonatomic)NSMutableArray * arrOption;
@property (strong ,nonatomic)NSMutableArray * arrAllGroup;
@property (strong ,nonatomic)NSMutableArray * arrAllPeople;
@property (strong ,nonatomic)NSMutableArray * arrSuperGroup;
@property (strong ,nonatomic)NSMutableArray * arrSuperPeople;
@end
