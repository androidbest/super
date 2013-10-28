//
//  OfficeDetailController.h
//  zwy
//
//  Created by wangshuang on 10/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "OfficeDetailView.h"
#import "KxMenu.h"
#import "DocContentInfo.h"
@interface OfficeDetailController : BaseController<KxMenuViewdelegate>
@property (strong, nonatomic)  OfficeDetailView *officedetailView;
@property (strong ,nonatomic) NSMutableArray *arrDidAllPeople;
-(void)reqData;
@end
