//
//  packageData.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface packageData : NSObject

//获取EC单位信息列表接口
+(void)getECinterface:(id)delegate msisdn:(NSString *)msisdn;

//检查验证码
+ (void)checkCode:(id)delegate  Code:(NSString *)code msisdn:(NSString *) msisdn;

//获取验证码
+(void)getSecurityCode:(id)delegate msisdn:(NSString *) msisdn;

//获取密码
+(void)checkPassword:(id)delegate msisdn:(NSString *) msisdn;

//登录
+ (void)Loginvalidation:(id)delegate Password:(NSString *)passWord  Count:(NSString *)count msisdn:(NSString *)msisdn eccode:(NSString *)eccode;

//发送eccode
+ (void)sendEc:(id)delegate;

//自动登录
+ (void)autoLoginvalidation:(id)delegate Count:(NSString *)count msisdn:(NSString *)msisdn eccode:(NSString *)eccode;

//发送短信
+ (void)SendSMS:(id)delegate receiverTel:(NSString*)receiverTel receiverName:(NSString *)receiverName content:(NSString *)content sendTime:(NSString*)time groupId:(NSString *)groupId;

//发送语音
+ (void)SendVoice:(id)delegate receiverTel:(NSString*)receiverTel receiverName:(NSString *)receiverName content:(NSString *)content sendTime:(NSString*)time groupId:(NSString *)groupId;

//获取短信模板分类列表
+(void)templateInfor:(id)delegate;

//获取短信模板信息
+ (void)getTemplate:(id)delegate TemplateID:(NSString *)ID pageNmu:(NSString *)pageNum;

//发起会议电话
+ (void)scheduleConf:(id)delegate receiverTel:(NSString*)receiverTel receiverName:(NSString *)receiverName groupID:(NSString *)groupID time:(NSString *)time;

//新闻资讯
+ (void)reqHotNewsInfoXml:(id)delegate start:(NSString *)start end:(NSString *)end SELType:(NSString *)sel;

//经典笑话
+ (void)reqJokeInfoXml:(id)delegate start:(NSString *)start end:(NSString *)end SELType:(NSString *)sel;

//获取政府公告列表
+ (void)getNoticeList:(id)delegate pages:(NSString *)pageID;

//获取用户总数
+ (void)getUserCount:(id)delegate groupID:(NSString *)gorupID Type:(NSString *)type;

//查部门总数
+ (void)getGroupCount:(id)delegate groupID:(NSString *)groupid;

//通讯录分组信息
+ (void)getGroups:(id)delegate groupID:(NSString *)groupid pages:(NSString *)pageID groupName:(NSString *)groupName SELType:(NSString *)sel;

//通讯录成员信息
+ (void)getGroupmember:(id)delegate groupID:(NSString *)gorupid pages:(NSString *)pageId Type:(NSString *)type condition:(NSString *)condition SELType:(NSString *)sel;

//获取公文待办或待审列表(1、为待办公文，2，为待审公文)
+ (void)getDocList:(id)delegate infoType:(NSString *)type pages:(NSString *)pageid SELType:(NSString *)sel;

//获取已办或者已审公文列表(1、已办 2、已审)
+(void)alreadyDocList:(id)delegate type:(NSString *)type pageNum:(NSString *)pageNum SELType:(NSString *)sel;

//获取公文流程 
+(void)docFlow:(id)delegate ID:(NSString *)ID;

//获取公文信息
+ (void)getDocInfo:(id)delegate ID:(NSString *)Id;

//获取公文处理状态
+ (void)getDocInfoType:(id)delegate ID:(NSString *)Id Type:(NSString *)type;

//办理与审核公文//(type:  1、办理 2、审核 OperType: 0、办理结束 1、下一步办理人 2、报领导审批 status：1、同意 2、不同意)
+ (void)handleDoc:(id)delegate ID:(NSString *)Id Type:(NSString *)type OperType:(NSString *)operType tempTel:(NSString *)tel Status:(NSString *)status context:(NSString *)content groupid:(NSString *)groupid;

//获取公文附件
+ (void)queryDocumentAttachment:(id)delegate ID:(NSString *)Id SELType:(NSString *)sel;

//获取群众信箱办理列表
+ (void)getPublicMailList:(id)delegate Pages:(NSString *)pageId SELType:(NSString *)sel;

//获取群众信箱审批列表
+ (void)getAuditMailList:(id)delegate Pages:(NSString *)pageId SELType:(NSString *)sel;

//获取群众信箱办理人信息
+ (void)getPublicMailUsers:(id)delegate pages:(NSString *)pageId Condition:(NSString *)condition;

//获取群众信箱关联单位信息
+ (void)getPublicMailGroups:(id)delegate pages:(NSString *)pageId Condition:(NSString *)condition;

//群众信箱办理流程
+ (void)processmail:(id)delegate LogID:(NSString *)logId MsgType:(NSString *)MsgType contentType:(NSString *)ContentType BF:(NSString *)BF NextProcessTel:(NSString *)ProcessTel limitTime:(NSString *)time content:(NSString *)content pageName:(NSString *)pageName;

//群众信箱审核流程
+ (void)auditmail:(id)delegate LogID:(NSString *)logId BF:(NSString *)BF nextProcessTel:(NSString *)ProcessTel Recontent:(NSString *)content;

//意见反馈
+ (void)saveFeedback:(id)delegate Title:(NSString *)title Type:(NSString *)type Content:(NSString *)content;

//安装量
+ (void)phoneStatisticsFun:(id)delegate Install:(NSString *)install;

//获取公文与邮箱数量
+ (void)getSum:(id)delegate;

//本地通讯录信息展示
+ (void)showAddressInfo:(id)delegate GroupID:(NSString *)groupId Pages:(NSString *)PageId Type:(NSString *)type Condition:(NSString *)condition;

//公文流程展示
+ (void)showFlowDocList:(id)delegate DocID:(NSString *)docId;

//上次单位码上传
+ (void)updateLastEccoed:(id)delegate lastEcconde:(NSString *)lastEcconde;

//系统通讯录更新
+ (void)updateAddressBook:(id)delegate updatetime:(NSString *)time;


@end
