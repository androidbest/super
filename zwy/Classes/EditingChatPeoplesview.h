//
//  EditingChatPeoplesview.h
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "ChatMessageView.h"
@interface EditingChatPeoplesview : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnRemove;
@property (strong ,nonatomic)ChatMessageView *chatView;
@end
