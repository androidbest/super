//
//  ChatMsgObj.h
//  zwy
//
//  Created by wangshuang on 12/20/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMsgObj : NSObject
@property (strong ,nonatomic)NSString *chattype;//0.文本 1.语音
@property (strong ,nonatomic)NSString *sendname;
@property (strong ,nonatomic)NSString *sendeccode;
@property (strong ,nonatomic)NSString *sendmsisdn;
@property (strong ,nonatomic)NSString *receivereccode;
@property (strong ,nonatomic)NSString *receivermsisdn;
@property (strong ,nonatomic)NSString *receivername;
@property (strong ,nonatomic)NSString *content;
@property (strong ,nonatomic)NSString *filepath;//上传语音地址
@property (strong ,nonatomic)NSString *groupid;//组id
@property (strong ,nonatomic)NSString *senderavatar;//自己头像地址
@property (strong ,nonatomic)NSString *receiveravatar;//对方头像地址
@property (strong ,nonatomic)NSString *sendtime;//字符串格式
@property (strong ,nonatomic)NSDate *sendtimeNSdate;//发送时间 date格式
@property (strong ,nonatomic)NSString *voicetime;//语音秒数
@property (strong ,nonatomic)NSString *status;//0.自己发 1.对方发
@property (strong ,nonatomic)NSString *gsendermsisdn;//组发送者电话
@property (strong ,nonatomic)NSString *gsenderheadurl;//组发送者头像
@end
