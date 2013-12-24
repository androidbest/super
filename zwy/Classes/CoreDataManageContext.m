//
//  CoreDataManageContext.m
//  zwy
//
//  Created by cqsxit on 13-12-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//


#import "CoreDataManageContext.h"
#import "SessionEntity.h"
#import "ChatEntity.h"
#import "Constants.h"
#import "ToolUtils.h"
static CoreDataManageContext *coreData=nil;

@implementation CoreDataManageContext
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark -单实例
+(CoreDataManageContext *)newInstance{
    @synchronized(self){
        if(!coreData){
            coreData= [[super allocWithZone:NULL] init];
        }
    }
    return coreData;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [self newInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


/*
 *获取会话表单
 *返回object为“SessionEntity”
 */
- (NSArray *)getSessionListWithSelfID:(NSString *)selfID{
    NSEntityDescription * emEty = [NSEntityDescription entityForName:@"SessionEntity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:emEty];
    
    //设置搜索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session_selfid == %@", selfID];
    [frq setPredicate:predicate];
    
    //设置排序方式
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"session_times" ascending:NO];
    NSArray * sortDescriptors = [NSArray arrayWithObject: sort];
    [frq setSortDescriptors: sortDescriptors];
    
    NSArray *objs =[self.managedObjectContext executeFetchRequest:frq error:nil];
    return objs;
}

/*
 *接受、发送消息，更新表单信息
 *chatType: 0.自己发 1.对方发
 *isChek: 如果已点击查看为 YES ,否则 NO
 */
- (void)setChatInfo:(ChatMsgObj *)messageObjct status:(NSNumber *)chatType isChek:(BOOL)isChek{
    NSEntityDescription * emEty = [NSEntityDescription entityForName:@"SessionEntity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:emEty];
    
    //设置搜索条件
    NSString *chatMessageID =[NSString stringWithFormat:@"%@_%@_%@_%@",user.msisdn,user.eccode,messageObjct.receivermsisdn,messageObjct.receivereccode];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session_chatMessageID == %@", chatMessageID];
    [frq setPredicate:predicate];
    
    NSArray *objs =[self.managedObjectContext executeFetchRequest:frq error:nil];
    
    //获取对应的实体
    SessionEntity *Sessions=nil;
    if (objs.count<=0){
        Sessions =(SessionEntity *)[[NSManagedObject alloc] initWithEntity:emEty insertIntoManagedObjectContext:self.managedObjectContext];
        Sessions.session_groupuuid=[NSNumber numberWithInt:[messageObjct.groupid intValue]];
        Sessions.session_chatMessageID=chatMessageID;
        Sessions.session_receivermsisdn=messageObjct.sendmsisdn;
        Sessions.session_receivereccode=messageObjct.sendeccode;
        Sessions.session_selfid=[user.msisdn stringByAppendingString:user.eccode];
        Sessions.session_pinyinName =[ToolUtils pinyinFromString:messageObjct.receivername];
    }else{
        Sessions=objs[0];
    }
    
    //更新Sessions消息
    Sessions.session_receiveravatar=messageObjct.receiveravatar;
    Sessions.session_receivername=messageObjct.receivername;
    Sessions.session_content=messageObjct.content;
    if (isChek) Sessions.session_unreadcount =[NSNumber numberWithInt:0];
    else Sessions.session_unreadcount=[NSNumber numberWithInt:[Sessions.session_unreadcount intValue]+1];
    Sessions.session_times =[[NSDate alloc]initWithTimeIntervalSince1970:[messageObjct.sendtime doubleValue]];
    
    
    //插入聊天记录
    ChatEntity *chatInfo =[NSEntityDescription insertNewObjectForEntityForName:@"ChatEntity" inManagedObjectContext:self.managedObjectContext];
    chatInfo.chat_groupuuid=[NSNumber numberWithInt:[messageObjct.groupid intValue]];
    chatInfo.chat_groupname=messageObjct.receivername;
    chatInfo.chat_times=[[NSDate alloc]initWithTimeIntervalSince1970:[messageObjct.sendtime doubleValue]];
    chatInfo.chat_msgtype=[NSNumber numberWithInt:[messageObjct.chattype intValue]];
    chatInfo.chat_content=messageObjct.content;
    chatInfo.chat_voiceurl=messageObjct.filepath;
    chatInfo.chat_MessageID=chatMessageID;
    chatInfo.chat_status=chatType;
    chatInfo.chat_sessionObjct=Sessions;
    
    [Sessions addSession_chatsObject:chatInfo];
    [self saveContext];//保存
}


/*
 *获取对应聊天记录
 *返回object为“ChatEntity”
 */
- (NSArray *)getUserChatMessageWithChatMessageID:(NSString *)chatMessageID FetchOffset:(NSUInteger)offset FetchLimit:(NSUInteger)limit{
    NSEntityDescription * emEty = [NSEntityDescription entityForName:@"ChatEntity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:emEty];
    
    //设置搜索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chat_MessageID == %@", chatMessageID];
    [frq setPredicate:predicate];
    
    //设置排序方式
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"chat_times" ascending:NO];
    NSArray * sortDescriptors = [NSArray arrayWithObject: sort];
    [frq setSortDescriptors: sortDescriptors];
    
    [frq setFetchOffset:offset];//从第几条开始取
    [frq setFetchLimit:limit];//最大取值数
    
    NSArray *objs =[self.managedObjectContext executeFetchRequest:frq error:nil];
    return objs;
}

/*
 *删除对应聊天记录
 */
- (void)deleteChatInfoWithChatMessageID:(NSString *)chatMessageID{
    NSEntityDescription * emEty = [NSEntityDescription entityForName:@"SessionEntity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *frq = [[NSFetchRequest alloc]init];
    [frq setEntity:emEty];
    
    //设置搜索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session_chatMessageID == %@", chatMessageID];
    [frq setPredicate:predicate];
    
    NSArray *objs =[self.managedObjectContext executeFetchRequest:frq error:nil];
   
    //获取对应的实体
    SessionEntity *Sessions=nil;
    if (objs.count>0)  Sessions=objs[0];
    else return;
    
    //删除并保存设置
    [self.managedObjectContext deleteObject:Sessions];
    
    //获取对应的所用聊天记录
    NSEnumerator *enumerator = [Sessions.session_chats objectEnumerator];
    for (NSObject *object in enumerator) {
        [self.managedObjectContext deleteObject:(ChatEntity *)object];//删除
    }
    
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ChatSQLMode" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ChatSQLMode.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [NSURL URLWithString:@"file:///Users/sxit/Desktop/test/"];
}

@end
