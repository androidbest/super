//
//  MessageController.h
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MessageView.h"
@interface MessageController : BaseController
@property (strong ,nonatomic)MessageView * messageView;
@property (strong ,nonatomic)NSMutableArray *arrSession;
@property (strong ,nonatomic)NSArray *arrSeaPeople;
/*设置全局通讯录信息*/
- (void)setAllGroupAddressBooksWithHUDText:(NSString *)text;
@end
