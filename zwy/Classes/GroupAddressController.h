//
//  GroupAddressController.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-9.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseController.h"
#import "GroupAddressView.h"

@interface GroupAddressController : BaseController
@property (strong ,nonatomic)MBProgressHUD *HUD_Group;
@property (strong ,nonatomic)GroupAddressView *grougView;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
@property (strong ,nonatomic)NSArray *arrFirstGroup;
@end
