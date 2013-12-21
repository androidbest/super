//
//  SessionEntity.h
//  zwy
//
//  Created by cqsxit on 13-12-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatEntity;

@interface SessionEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * session_groupuuid;       //组id
@property (nonatomic, retain) NSString * session_receiveravatar;  //对方头像地址
@property (nonatomic, retain) NSString * session_receivername;    //对方姓名
@property (nonatomic, retain) NSString * session_receivermsisdn;  //对方电话
@property (nonatomic, retain) NSString * session_receivereccode;  //对方ec
@property (nonatomic, retain) NSString * session_chatMessageID;   //自己电话_自己ec_对方电话_对方EC
@property (nonatomic, retain) NSString * session_selfid;          //自己电话_自己ec
@property (nonatomic, retain) NSString * session_content;         //内容
@property (nonatomic, retain) NSNumber * session_unreadcount;     //未读总条数
@property (nonatomic, retain) NSDate * session_times;             //时间
@property (nonatomic, retain) NSSet *session_chats;               //指向"消息表"
@end

@interface SessionEntity (CoreDataGeneratedAccessors)

- (void)addSession_chatsObject:(ChatEntity *)value;
- (void)removeSession_chatsObject:(ChatEntity *)value;
- (void)addSession_chats:(NSSet *)values;
- (void)removeSession_chats:(NSSet *)values;

@end
