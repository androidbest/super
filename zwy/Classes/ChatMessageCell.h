//
//  ChatMessageCell.h
//  zwy
//
//  Created by wangshuang on 12/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceBtn.h"
@interface ChatMessageCell : UITableViewCell
@property (strong, nonatomic) UIImageView *sendFail;
@property (strong, nonatomic) UILabel *chatTime;
@property (strong, nonatomic) UILabel *rightVoiceTimes;
@property (strong, nonatomic) UILabel *leftVoiceTimes;
@property (strong, nonatomic) UIButton *leftHead;
@property (strong, nonatomic) UIButton *rightHead;
@property (strong, nonatomic) VoiceBtn *leftMessage;
@property (strong, nonatomic) VoiceBtn *rightMessage;
@end
