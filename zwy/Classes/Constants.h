//
//  Constants.h
//  ZheWuYi
//
//  Created by wangshuang on 13-5-30.
//  Copyright (c) 2013年 Mac. All rights reserved.



#import <Foundation/Foundation.h>
#import "Tuser.h"
#import "SqlLiteHelper.h"
//全局常量 基本数据类型
#define OutTime 30
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]

//全局常量 对象
//demo
extern NSString * const xmlNotifInfo;
extern NSString * const xmlNotifInfo1;
extern NSString * const xmlNotifInfo2;
extern NSString * const xmlNotifInfo3;
extern NSString * const requestError;
extern NSString * const wnLoadAddress;

//全局变量
extern NSArray *EX_arrGroupAddressBooks;
extern NSMutableArray *EX_arrSection;
extern NSString *EX_newToken;
extern NSString *EX_chatMessageID;
extern NSTimer *EX_timerUpdateMessage;
extern Tuser *user;
extern NSMutableArray *arrEc;
extern UIView *coverView;
extern BOOL isZaiXian;
extern NSDictionary * dicLocalNotificationInfo;
extern NSMutableArray * chatArr;
extern SqlLiteHelper * sqlHelper;
@interface Constants : NSObject
@end
