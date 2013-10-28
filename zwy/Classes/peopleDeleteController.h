//
//  peopleDeleteController.h
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "peopleDeleteView.h"
@interface peopleDeleteController : BaseController
@property (strong ,nonatomic)peopleDeleteView *peopleView;
@property (strong ,nonatomic)NSMutableArray * arrAllInfo;
@end
