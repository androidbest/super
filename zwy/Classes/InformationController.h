//
//  InformationController.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "InformationView.h"
@interface InformationController : BaseController
@property (strong ,nonatomic) InformationView* informationView;
//新闻下一篇
- (void)PushNextNewsFromInformationDetaController;
@end
