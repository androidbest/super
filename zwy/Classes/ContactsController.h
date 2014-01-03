//
//  ContactsController.h
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "ContactsView.h"
@interface ContactsController : BaseController
@property (strong ,nonatomic)ContactsView * contactsView;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
-(void)initECnumerData;
@end
