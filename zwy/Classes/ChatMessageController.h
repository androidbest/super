//
//  ChatMessageController.h
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "ChatMessageView.h"
#import "ChatVoiceRecorderVC.h"
@interface ChatMessageController : BaseController
@property (strong ,nonatomic)ChatMessageView * chatMessageView;
-(void)initDatatoData;
@end
