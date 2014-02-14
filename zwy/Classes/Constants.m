//
//  Constants.m
//  ZheWuYi
//
//  Created by wangshuang on 13-5-30.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "Constants.h"

//全局常量
NSString * const xmlNotifInfo=@"xmldatahandle";
NSString * const xmlNotifInfo1=@"xmldatahandle1";
NSString * const xmlNotifInfo2=@"xmldatahandle2";
NSString * const xmlNotifInfo3=@"xmldatahandle3";
NSString * const requestError=@"网络超时";
NSString * const wnLoadAddress=@"DownLoadAddressList";
BOOL isZaiXian =YES;

//全局变量
NSMutableArray *EX_arrSection;
NSArray *EX_arrGroupAddressBooks=nil;
NSString *EX_newToken=nil;
NSTimer *EX_timerUpdateMessage=nil;
NSString *EX_chatMessageID=nil;
Tuser *user=nil;
NSMutableArray *arrEc=nil;
NSDictionary * dicLocalNotificationInfo=nil;
UIView *coverView=nil;
NSMutableArray *chatArr=nil;
SqlLiteHelper * sqlHelper=nil;

@implementation Constants
@end
