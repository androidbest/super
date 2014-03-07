//
//  CoreDataManageContext.h
//  zwy
//
//  Created by cqsxit on 13-12-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChatMsgObj.h"
#import "SessionEntity.h"

@interface CoreDataManageContext : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark -单实例
+(CoreDataManageContext *)newInstance;

#pragma mark -获取会话表单
- (NSArray *)getSessionListWithSelfID:(NSString *)selfID;

#pragma mark -接受、发送消息，更新表单信息
- (void)setChatInfo:(ChatMsgObj *)messageObjct status:(NSString *)chatType isChek:(BOOL)isChek gid:(NSString *)gid arr:(NSMutableArray*)arr;

- (void)setChatInfo:(ChatMsgObj *)messageObjct status:(NSString *)chatType isChek:(BOOL)isChek;

#pragma mark -获取对应的聊天记录
- (NSArray *)getUserChatMessageWithChatMessageID:(NSString *)chatMessageID FetchOffset:(NSUInteger)offset FetchLimit:(NSUInteger)limit;

#pragma mark - 删除对应聊天记录
- (void)deleteChatInfoWithChatMessageID:(NSString *)chatMessageID;

#pragma mark - 更新数据
- (void)updateWithSessionEntity:(SessionEntity *)sessionInfo;
//依据电话与eccode查找会话ID
- (NSArray *)getSessionID:(NSString *)phone_ec selfid:(NSString*)selfid;

- (void)saveContext;
@end
