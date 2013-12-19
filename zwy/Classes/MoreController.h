//
//  MoreController.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MoreView.h"
#import "WeiboApi.h"
@interface MoreController : BaseController<WeiboRequestDelegate,WeiboAuthDelegate>
@property (strong ,nonatomic)MoreView * moreView;
@property (nonatomic , retain) WeiboApi *wbapi;
@end
