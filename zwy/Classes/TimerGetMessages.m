//
//  TimerGetMessages.m
//  zwy
//
//  Created by cqsxit on 14-2-28.
//  Copyright (c) 2014年 sxit. All rights reserved.
//
#define NOTIFICATIONMESSAGE @"notificationMessage"

#import "TimerGetMessages.h"

#import "CoreDataManageContext.h"

#import "AnalysisData.h"

#import "ConfigFile.h"

#import "Constants.h"

#import "ToolUtils.h"

#import "PackageData.h"

@implementation TimerGetMessages


- (id)init{
    self =[super init];
    if (self) {
        //注册接收即时聊天的通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationImRevice:)
                                                    name:NOTIFICATIONMESSAGE
                                                  object:self];
            }
    return self;
}

+ (TimerGetMessages*)sharedInstance
{
    // 1 ,声明一个静态变量去保存类的实例，确保它在类中的全局可用性。
    static TimerGetMessages *_sharedInstance = nil;
    
    // 2 ,声明一个静态变量dispatch_once_t ,它确保初始化器代码只执行一次
    static dispatch_once_t oncePredicate;
    
    // 3 ,使用Grand Central Dispatch(GCD)执行初始化LibraryAPI变量的block.这正是单例模式的关键：一旦类已经被初始化，初始化器永远不会再被调用。
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TimerGetMessages alloc] init];
    });
    return _sharedInstance;
}


- (NSTimer *)timerGetMsg{
    if (!_timerGetMsg) {
        _timerGetMsg=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    return _timerGetMsg;
}


- (void)onTimer{
    [self.timerGetMsg setFireDate:[NSDate distantPast]];
}

- (void)offTimer{
  [self.timerGetMsg setFireDate:[NSDate distantFuture]];
}

- (void)deleteTimer{
    [self.timerGetMsg setFireDate:[NSDate distantFuture]];
    [self.timerGetMsg invalidate];
    self.timerGetMsg=nil;
}

- (void)timerFired:(id)sender{
      [packageData imRevice:self SELType:NOTIFICATIONMESSAGE];
}


/*接受消息*/
- (void)notificationImRevice:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    NSMutableArray *arrmessages =[AnalysisData imRevice:dic];
    
    if (!arrmessages||arrmessages.count==0)return;
    
    
    /*插入数据*/
    CoreDataManageContext *coredataManage =[CoreDataManageContext newInstance];
    BOOL ischek=NO;
    for (int i=0; i<arrmessages.count; i++) {
        ChatMsgObj *obj =arrmessages[i];
        
        NSString *chatMessageID =nil;
        
        if (!obj.groupid||[obj.groupid isEqualToString:@"(null)"]||[obj.groupid isEqualToString:@""]||[obj.groupid isEqualToString:@"null"]) {
            chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,obj.receivermsisdn,user.eccode];
            ischek =[EX_chatMessageID  isEqualToString:chatMessageID];
            [coredataManage setChatInfo:obj status:@"1" isChek:ischek  gid:nil arr:nil];
            
        }else{
            chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,obj.groupid,user.eccode];
            //是否在聊天界面，返回yes＝是 返回no=否
            ischek =[EX_chatMessageID  isEqualToString:chatMessageID];
            [coredataManage setChatInfo:obj status:@"1" isChek:ischek];
        }
    }
    
    
    //ischek 0,增加未读提示 1.不加
    NSDictionary *dicNOtification;
    if (!ischek) dicNOtification =@{@"isCheck":@"0"};
    else dicNOtification =@{@"isCheck":@"1"};
    /*刷新数据
     *发送通告
     *观察者为"MessageController"--"ChatMessageController"--"HomeController"
     */
    //接收消息刷新数据，触发以上三个界面
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCHAT object:arrmessages userInfo:dicNOtification];
    
}

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}

@end
