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
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITextView *im_text;
@property (strong, nonatomic) IBOutlet UIButton *voicepress;
@property (strong, nonatomic) IBOutlet UIButton *send;
@property (strong, nonatomic) IBOutlet UIView *toolbar;
@property (strong, nonatomic) PeopelInfo *chatData;
@end
