//
//  CommentDetaView.h
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "InformationInfo.h"

@interface CommentDetaView : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) UITextView *textContent;
@property (strong, nonatomic) InformationInfo *InfoNewsDeta;
@property (assign) id commentDetaViewDelegate;
- (void)updateToCommentListView;
@end
