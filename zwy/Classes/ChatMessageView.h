//
//  ChatMessageView.h
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PeopelInfo.h"
#import "ChatVoiceRecorderVC.h"
#import "SessionEntity.h"
@interface ChatMessageView : BaseView
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UITextView *im_text;
@property (strong, nonatomic) UIButton *voicepress;
@property (strong, nonatomic) UIButton *send;
@property (strong, nonatomic) UIButton *voiceSend;
@property (strong, nonatomic) UIView *toolbar;
@property (strong, nonatomic) PeopelInfo *chatData;
@property (strong, nonatomic) PeopelInfo *chatHead;
@property (strong, nonatomic) NSMutableArray *arrPeoples;
@property (strong, nonatomic)ChatVoiceRecorderVC *recorderVC;
@property (retain, nonatomic)AVAudioPlayer *player;
@property (strong, nonatomic) SessionEntity *sessionInfo;
@end
