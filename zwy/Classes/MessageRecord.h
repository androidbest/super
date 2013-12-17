//
//  MessageRecord.h
//  zwy
//
//  Created by wangshuang on 12/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageRecord : NSObject
@property (strong ,nonatomic)NSString *mid;//主键
@property (strong ,nonatomic)NSString *memberid;//用户ID做为一方
@property (strong ,nonatomic)NSString *membername;//用户名称
@property (strong ,nonatomic)NSString *msisdn;//电话号码
@property (strong ,nonatomic)NSString *eccode;//eccode
@property (strong ,nonatomic)NSString *groupid;//群组id
@property (strong ,nonatomic)NSString *time;//最后修改时间
@property (strong ,nonatomic)NSString *content;//最后发送内容
@property (strong ,nonatomic)NSString *msgType;//0.发送 1.接收
@end
