//
//  OptionAddressController.h
//  zwy
//
//  Created by cqsxit on 13-10-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "optionAddress.h"
@interface OptionAddressController : BaseController

@property (strong ,nonatomic)MBProgressHUD *HUD_Group;
@property (strong ,nonatomic)optionAddress *OptionView;
@property (strong ,nonatomic)NSMutableArray *arrOption;
@property (strong ,nonatomic)NSMutableArray * arrAllPeople;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
@property (strong ,nonatomic)NSArray *arrFirstGroup;

@end
