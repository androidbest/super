//
//  MassTextingController.h
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MassTextingView.h"
@interface MassTextingController : BaseController
@property (strong ,nonatomic)MassTextingView *massView;
@property (strong ,nonatomic)NSMutableArray * arrDidAllPeople;
@end
