//
//  ChatRecord.h
//  zwy
//
//  Created by wangshuang on 12/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRecord : NSObject
@property (strong ,nonatomic)NSString *memberid;//相关联的id做为多方
@property (strong ,nonatomic)NSString *sendmsisdn;//发送者电话号码
@property (strong ,nonatomic)NSString *sendeccode;//发送者eccode
@property (strong ,nonatomic)NSString *sendecontent;//发送者内容
@property (strong ,nonatomic)NSString *sendetime;//发送者语音url
@property (strong ,nonatomic)NSString *voiceurl;//音频url
@property (strong ,nonatomic)NSString *receivermsisdn;//接收者电话号码
@property (strong ,nonatomic)NSString *receivereccode;//接收者eccode
@property (strong ,nonatomic)NSString *receivercontent;//接收者内容
@property (strong ,nonatomic)NSString *receivertime;//接收者时间
@end
