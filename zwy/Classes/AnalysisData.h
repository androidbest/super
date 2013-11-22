//
//  AnalysisData.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUser.h"
#import "RespInfo.h"
#import "EcinfoDetas.h"
#import "SMSInfo.h"
#import "GroupsInfo.h"
#import "DocContentInfo.h"
#import "AddressInfo.h"
#import "FlowDocInfo.h"
#import "SumEmailOrDocInfo.h"
#import "Tuser.h"
#import "RespList.h"
#import "OfficeInfo.h"
#import "officeDetaInfo.h"
#import "PeopleDedaInfo.h"
#import "GroupDetaInfo.h"
#import "warningInfo.h"
#import "warningDataInfo.h"

@interface AnalysisData : NSObject

//返回结果（获取验证码、检查验证码、短信发送、语音发送、发起会议电话、获取公文处理状态、办理与审核公文、意见反馈）
+ (RespInfo*)ReTurnInfo:(NSDictionary *)dic;

//检查通讯录更新
+ (RespInfo *)addressUpdataInfo:(NSDictionary *)dic;

//获取所有EC单位
+ (RespList *)AllECinterface:(NSDictionary *)dic;


//新闻与笑话
+ (RespList *)newsInfo:(NSDictionary *)dic;
//笑话
+ (RespList *)JokeInfo:(NSDictionary *)dic;

//登录
+ (Tuser*)LoginData:(NSDictionary *)dicData;

//自动登录
+ (Tuser*)autoLoginData:(NSDictionary *)dicData;

//短信模板分类列表
+ (SMSInfo *)templateInfor:(NSDictionary *)dic;

//获取短信模板信息
+ (SMSInfo *)getTemplate:(NSDictionary *)dic;

//政府公告信息
+ (RespList *)getNoticeList:(NSDictionary *)dic;

//通讯录分组信息
+ (GroupsInfo *)getGroups:(NSDictionary *)dic;

//通讯录成员信息
+ (GroupsInfo *)getGroupmember:(NSDictionary *)dic;

//获取公文待办或待审列表
+ (RespList *)getDocList:(NSDictionary *)dic;

//获取公文已办或已审列表
//+ (RespList *)alreadyDocList:(NSDictionary *)dic;

//获取公文信息
+ (DocContentInfo *)getDocContentInfo:(NSDictionary *)dic;

//获取公文附件列表
+ (OfficeInfo *)getDocAccessory:(NSDictionary *)dic;

//获取群众信箱办理列表
+ (RespList *)getPublicMailList:(NSDictionary *)dic;

//获取群众信箱审批列表
+ (RespList *)getAuditMailList:(NSDictionary *)dic;

//获取群众信箱办理人信息
//+ (RespList *)getPublicMailUsers:(NSDictionary *)dic;

//群众信箱办理流程
+ (RespInfo *)processmail:(NSDictionary *)dic;

//群众信箱审核流程
+ (RespInfo *)auditmail:(NSDictionary *)dic;

//获取公文与邮箱数量
+ (SumEmailOrDocInfo *)getSum:(NSDictionary *)dic;

//本地通讯录信息展示
//+ (AddressInfo *)showAddressInfo:(NSDictionary *)dic;

//公文流程展示
+ (RespList *)showFlowDocList:(NSDictionary *)dic;

//日程提醒列表
+ (warningInfo *)warningList:(NSDictionary *)dic;
@end
