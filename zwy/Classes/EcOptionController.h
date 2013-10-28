//
//  EcOptionController.h
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "EcOptionView.h"
@interface EcOptionController : BaseController
@property (strong ,nonatomic)EcOptionView * ecOptionView;
-(void)getEc;
@end
