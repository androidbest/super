//
//  MassMyaddressController.h
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MassMyAddressView.h"
@interface MassMyaddressController : BaseController
@property (strong ,nonatomic)MassMyAddressView *massView;
@property (strong ,nonatomic)NSMutableArray *arrOption;
@property (strong ,nonatomic)NSMutableArray * arrAllPeople;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
@property (strong ,nonatomic)NSArray *arrFirstGroup;
@end
