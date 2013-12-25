//
//  ChatMessageView.h
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PeopelInfo.h"
@interface ChatMessageView : BaseView
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UITextView *im_text;
@property (strong, nonatomic) UIButton *voicepress;
@property (strong, nonatomic) UIButton *send;
@property (strong, nonatomic) UIButton *voiceSend;
@property (strong, nonatomic) UIView *toolbar;
@property (strong, nonatomic) PeopelInfo *chatData;
@property (strong, nonatomic) PeopelInfo *chatHead;
@end
