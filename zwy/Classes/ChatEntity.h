//
//  ChatEntity.h
//  zwy
//
//  Created by cqsxit on 13-12-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SessionEntity;

@interface ChatEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * chat_groupuuid;        // 组id
@property (nonatomic, retain) NSString * chat_groupname;        // 组姓名
@property (nonatomic, retain) NSDate * chat_times;              // 时间
@property (nonatomic, retain) NSNumber * chat_msgtype;          // 0:文本 1语音
@property (nonatomic, retain) NSString * chat_content;          // 内容
@property (nonatomic, retain) NSString * chat_voiceurl;         // 语音地址
@property (nonatomic, retain) NSString * chat_MessageID;        // 自己电话_自己ec_对方电话_对方EC
@property (nonatomic, retain) NSNumber * chat_status;           // 0.自己发 1.对方发
@property (nonatomic, retain) SessionEntity *chat_sessionObjct; // 指向回话表

@end
