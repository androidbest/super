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
@property (strong ,nonatomic)MBProgressHUD *HUD_Group;

/*同步全局通讯录缓存指示灯*/
- (void)showSetAllAllGroupAddressBooksHUDWithText:(NSString *)text;
- (void)initWithData;
@end
