//
//  MyAddressController.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-8.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAddressView.h"
#import "AIMTableViewIndexBar.h"
#import "BaseController.h"

@interface MyAddressController : BaseController

@property (strong ,nonatomic)MyAddressView *addressView;


@property (strong ,nonatomic)NSMutableArray *arrAllLink;
@property (strong ,nonatomic)NSMutableArray * arrSection;
@end
