//
//  OptionChatPeopleController.h
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "OptionChatPeopleView.h"

@interface OptionChatPeopleController : BaseController
@property (strong ,nonatomic)OptionChatPeopleView *optionView;
@property (strong ,nonatomic)NSMutableArray *arrSection;
@property (strong ,nonatomic)NSMutableArray *arrAllLink;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
@property (strong ,nonatomic)NSMutableArray *arrOption;
@end
