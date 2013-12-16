//
//  Constants.h
//  ZheWuYi
//
//  Created by wangshuang on 13-5-30.
//  Copyright (c) 2013年 Mac. All rights reserved.



#import <Foundation/Foundation.h>
#import "Tuser.h"

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
extern Tuser *user;
extern NSMutableArray *arrEc;
extern UIView *coverView;
extern BOOL isZaiXian;
extern BOOL isLocalNotification;
extern NSDictionary * dicLocalNotificationInfo;
extern NSMutableArray * chatArr;
@interface Constants : NSObject
@end
