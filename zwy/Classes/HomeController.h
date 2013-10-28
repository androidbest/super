//
//  HomeController.h
//  zwy
//
//  Created by wangshuang on 10/11/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "HomeView.h"
@interface HomeController : BaseController
@property (strong ,nonatomic)HomeView * homeView;
-(void)sendEc;
-(void)getCount;
@end
