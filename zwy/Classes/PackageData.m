//
//  packageData.m
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import "packageData.h"
#import "HTTPRequest.h"
#import "Constants.h"
#import "Tuser.h"
#import "ChatMsgObj.h"
#import "ParseXML.h"
@implementation packageData

//获取URL
+ (NSURL *)urlByConfigFile{
    NSString * strPath =[[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
    NSURL *URL =[NSURL URLWithString:dic[@"httpurl"]];
    return URL;
}

//获取EC单位信息列表接口
+(void)getECinterface:(id)delegate msisdn:(NSString *) msisdn{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>NOKEY</SECURITYKEY><ECCODE>null</ECCODE></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>queryEcInfo</METHOD></BODY></MESSAGE>",msisdn];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}


//获取验证码
+(void)getSecurityCode:(id)delegate msisdn:(NSString *) msisdn{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>requestVerifyCode</METHOD></BODY></MESSAGE>",msisdn,@""];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
    
}

//检查验证码
+ (void)checkCode:(id)delegate  Code:(NSString *)code msisdn:(NSString *) msisdn{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>LOGIN</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>checkVerifyCode</METHOD><VERFYCODE>%@</VERFYCODE></BODY></MESSAGE>",msisdn,@"",code];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取密码
+(void)checkPassword:(id)delegate msisdn:(NSString *) msisdn{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getPassword</METHOD></BODY></MESSAGE>",msisdn];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];

}

//登录
+ (void)Loginvalidation:(id)delegate Password:(NSString *)passWord  Count:(NSString *)count msisdn:(NSString *)msisdn eccode:(NSString *)eccode{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>auth</METHOD><PASSWORD>%@</PASSWORD><COUNT>%@</COUNT></BODY></MESSAGE>",msisdn,eccode,passWord,count];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
    
}

//发送eccode
+ (void)sendEc:(id)delegate Type:(NSString *)type{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>updateLastEccoed</METHOD><LASTECCODE>%@</LASTECCODE></BODY></MESSAGE>",user.msisdn,user.eccode,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:type];
    
}


//自动登录
+ (void)autoLoginvalidation:(id)delegate  Count:(NSString *)count msisdn:(NSString *)msisdn eccode:(NSString *)eccode{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>autoLogin</METHOD><COUNT>%@</COUNT></BODY></MESSAGE>",msisdn,eccode,count];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
    
}

//发送短信
+ (void)SendSMS:(id)delegate receiverTel:(NSString*)receiverTel receiverName:(NSString *)receiverName content:(NSString *)content sendTime:(NSString*)time groupId:(NSString *)groupId{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>111</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>sendSms</METHOD><SESSIONID>2</SESSIONID><SENDER>%@</SENDER><CONTENT>%@</CONTENT><RECEIVERMSISDN>%@</RECEIVERMSISDN><RECEIVERNAME>%@</RECEIVERNAME><AUDITER></AUDITER><SENDTIME>%@</SENDTIME><GROUPID>%@</GROUPID></BODY></MESSAGE>",user.msisdn,user.eccode,user.msisdn,content,receiverTel,receiverName,time,groupId];
//    NSString * str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>13752923254</PHONE><SECURITYKEY>null</SECURITYKEY><ECCODE>4952000001</ECCODE></HEAD><BODY><REQSIGN>0</REQSIGN><METHOD>sendSms</METHOD><SESSIONID>null</SESSIONID><SENDER>13752923254</SENDER><CONTENT>元旦来到，祝你在新年里：事业如日中天，心情阳光灿烂，工资地覆天翻，未来风光无限，爱情浪漫依然，快乐游戏人间。 重庆市渝北区星光三村</CONTENT><RECEIVERMSISDN>18716688785,18716467628,13752923254,</RECEIVERMSISDN><RECEIVERNAME>唐何易,史进,王爽,</RECEIVERNAME><AUDITER>null</AUDITER><SENDTIME>0</SENDTIME><GROUPID></GROUPID></BODY></MESSAGE>";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//发送语音
+ (void)SendVoice:(id)delegate receiverTel:(NSString*)receiverTel receiverName:(NSString *)receiverName content:(NSString *)content sendTime:(NSString*)time groupId:(NSString *)groupId{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>sendTTS</METHOD><SESSIONID>2</SESSIONID><SENDER>%@</SENDER><CONTENT>%@</CONTENT><RECEIVERMSISDN>%@</RECEIVERMSISDN><RECEIVERNAME>%@</RECEIVERNAME><AUDITER></AUDITER><SENDTIME>%@</SENDTIME><GROUPID>%@</GROUPID></BODY></MESSAGE>",user.msisdn,user.eccode,user.msisdn,content,receiverTel,receiverName,time,groupId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];

}

//获取短信模板分类列表
+(void)templateInfor:(id)delegate{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>queryTemplateTypeInfo</METHOD><SESSIONID>2</SESSIONID><TYPE>1</TYPE></BODY></MESSAGE>",user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取短信模板信息
+ (void)getTemplate:(id)delegate TemplateID:(NSString *)ID pageNmu:(NSString *)pageNum{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getTemplateInfo</METHOD><SESSIONID>2</SESSIONID><TYPE>1</TYPE><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><TEMPLATEID>%@</TEMPLATEID><CONTENT></CONTENT></BODY></MESSAGE>",user.msisdn,user.eccode,pageNum,ID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//发起会议电话
+ (void)scheduleConf:(id)delegate receiverTel:(NSString*)receiverTel receiverName:(NSString *)receiverName groupID:(NSString *)groupID time:(NSString *)time{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
   NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>NOKEY</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>scheduleConf</METHOD><SESSIONID>2</SESSIONID><STARTTIME>%@</STARTTIME><RECEIVERLIST>%@</RECEIVERLIST><RECEIVERNAME>%@</RECEIVERNAME><GROUPID>%@</GROUPID><USERNAME>%@</USERNAME></BODY></MESSAGE>",user.msisdn,user.eccode,time,receiverTel,receiverName,groupID,user.username];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取政府公告列表
+ (void)getNoticeList:(id)delegate pages:(NSString *)pageID{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getNoticeList</METHOD><SESSIONID>2</SESSIONID><INFOTYPE>0</INFOTYPE><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE></BODY></MESSAGE>",user.msisdn,user.eccode,pageID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//新闻资讯
+ (void)reqHotNewsInfoXml:(id)delegate start:(NSString *)start end:(NSString *)end SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getNews</METHOD><PHONE>%@</PHONE><STARTRN>%@</STARTRN><ENDRN>%@</ENDRN></BODY></MESSAGE>",user.msisdn,start,end];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//经典笑话
+ (void)reqJokeInfoXml:(id)delegate start:(NSString *)start end:(NSString *)end SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getJoke</METHOD><PHONE>%@</PHONE><STARTRN>%@</STARTRN><ENDRN>%@</ENDRN></BODY></MESSAGE>",user.msisdn,start,end];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取用户总数
+ (void)getUserCount:(id)delegate groupID:(NSString *)gorupID Type:(NSString *)type{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getUserCount</METHOD><SESSIONID>2</SESSIONID><GROUPID>%@</GROUPID><TYPE>%@</TYPE></BODY></MESSAGE>",user.msisdn,user.eccode,gorupID,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//查部门总数
+ (void)getGroupCount:(id)delegate groupID:(NSString *)groupid{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getGroupCount</METHOD><SESSIONID>2</SESSIONID><GROUPID>%@</GROUPID></BODY></MESSAGE>",user.msisdn,user.eccode,groupid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];

}

//通讯录分组信息
+ (void)getGroups:(id)delegate groupID:(NSString *)groupid pages:(NSString *)pageID groupName:(NSString *)groupName SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getGroups</METHOD><SESSIONID>2</SESSIONID><GROUPID>%@</GROUPID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><GROUPNAME><%@/GROUPNAME></BODY></MESSAGE>",user.msisdn,user.eccode,groupid,pageID,groupName];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

 //通讯录成员信息
+ (void)getGroupmember:(id)delegate groupID:(NSString *)groupid pages:(NSString *)pageId Type:(NSString *)type condition:(NSString *)condition SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getUsers</METHOD><SESSIONID>2</SESSIONID><GROUPID>%@</GROUPID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><TYPE>%@</TYPE><CONDITION>%@</CONDITION></BODY></MESSAGE>",user.msisdn,user.eccode,groupid,pageId,@"1",condition];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取公文待办或待审列表(1、为待办公文，2，为待审公文)
+ (void)getDocList:(id)delegate infoType:(NSString *)type pages:(NSString *)pageid SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getDocList</METHOD><SESSIONID>1</SESSIONID><INFOTYPE>%@</INFOTYPE><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE></BODY></MESSAGE>",user.msisdn,user.eccode,type,pageid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];

}

//获取公文待办或待审列表(1、为待办公文，2，为待审公文)
+(void)alreadyDocList:(id)delegate type:(NSString *)type pageNum:(NSString *)pageNum SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
   NSString *str =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>2</SECURITYKEY><ECCODE>%@</ECCODE></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getDocListend</METHOD><SESSIONID>1</SESSIONID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><INFOTYPE>%@</INFOTYPE></BODY></MESSAGE>",user.msisdn,user.eccode,pageNum,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//公文流程
+(void)docFlow:(id)delegate ID:(NSString *)ID{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>LOGIN</SECURITYKEY><ECCODE>%@</ECCODE></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>showFlowDocList</METHOD><SESSIONID></SESSIONID><DOCID>%@</DOCID></BODY></MESSAGE>",user.msisdn,user.eccode,ID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];

}

//获取公文信息
+ (void)getDocInfo:(id)delegate ID:(NSString *)Id transactdocid:(NSString *)transactdocid{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getDocInfo</METHOD><SESSIONID>2</SESSIONID><ID>%@</ID><transactdocid>%@</transactdocid></BODY></MESSAGE>",user.msisdn,user.eccode,Id,transactdocid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取公文处理状态
+ (void)getDocInfoType:(id)delegate ID:(NSString *)Id Type:(NSString *)type{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getDocInfo</METHOD><SESSIONID>null</SESSIONID><ID>%@<ID><TYPE>%@<TYPE></BODY></MESSAGE>",user.msisdn,user.eccode,Id,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];

}

//办理与审核公文 (type：1、办理 2、审核 OperType: 0、办理结束 1、下一步办理人 2、报领导审批 status：1、同意 2、不同意)
+ (void)handleDoc:(id)delegate ID:(NSString *)Id Type:(NSString *)type OperType:(NSString *)operType tempTel:(NSString *)tel Status:(NSString *)status context:(NSString *)content groupid:(NSString *)groupid transactdocid:(NSString *)transactdocid {
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>handleDoc</METHOD><SESSIONID>2</SESSIONID><ID>%@</ID><TYPE>%@</TYPE><OPERTYPE>%@</OPERTYPE><TEMP>%@</TEMP><STATUS>%@</STATUS><REPLYCONTENT>%@</REPLYCONTENT><GROUPID>%@</GROUPID><TRANSACTDOCID>%@</TRANSACTDOCID></BODY></MESSAGE>",user.msisdn,user.eccode,Id,type,operType,tel,status,content,groupid,transactdocid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取公文附件
+ (void)queryDocumentAttachment:(id)delegate ID:(NSString *)Id SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>queryDocumentAttachment</METHOD><SESSIONID>2</SESSIONID><ID>%@</ID></BODY></MESSAGE>",user.msisdn,user.eccode,Id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取群众信箱办理列表
+ (void)getPublicMailList:(id)delegate Pages:(NSString *)pageId SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getPublicMailList</METHOD><SESSIONID>2</SESSIONID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE></BODY></MESSAGE>",user.msisdn,user.eccode,pageId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取群众信箱审批列表
+ (void)getAuditMailList:(id)delegate Pages:(NSString *)pageId SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getAuditMailList</METHOD><SESSIONID>2</SESSIONID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE></BODY></MESSAGE>",user.msisdn,user.eccode,pageId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取群众信箱办理人信息
+ (void)getPublicMailUsers:(id)delegate pages:(NSString *)pageId Condition:(NSString *)condition{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getPublicMailUsers</METHOD><SESSIONID>2</SESSIONID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><CONDITION>%@</CONDITION></BODY></MESSAGE>",user.msisdn,user.eccode,pageId,condition];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取群众信箱关联单位信息
+ (void)getPublicMailGroups:(id)delegate pages:(NSString *)pageId Condition:(NSString *)condition{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getPublicMailGroups</METHOD><SESSIONID>2</SESSIONID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><CONDITION>%@</CONDITION></BODY></MESSAGE>",user.msisdn,user.eccode,pageId,condition];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//群众信箱办理流程
+ (void)processmail:(id)delegate LogID:(NSString *)logId MsgType:(NSString *)MsgType contentType:(NSString *)ContentType BF:(NSString *)BF NextProcessTel:(NSString *)ProcessTel limitTime:(NSString *)time content:(NSString *)content pageName:(NSString *)pageName{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>processmail</METHOD><SESSIONID>2</SESSIONID><LOGID>%@</LOGID><MSGTYPE>%@</MSGTYPE><CONTENTTYPE>%@</CONTENTTYPE><BF>%@</BF><NEXTPROCESS>%@</NEXTPROCESS><LIMITTIME>%@</LIMITTIME><RECONTENT>%@</RECONTENT><PAGENAME>%@</PAGENAME></BODY></MESSAGE>",user.msisdn,user.eccode,logId,MsgType,ContentType,BF,ProcessTel,time,content,pageName];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//群众信箱审核流程
+ (void)auditmail:(id)delegate LogID:(NSString *)logId BF:(NSString *)BF nextProcessTel:(NSString *)ProcessTel Recontent:(NSString *)content{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>auditmail</METHOD><SESSIONID>2</SESSIONID><LOGID>%@</LOGID><BF>%@</BF><NEXTPROCESS>%@</NEXTPROCESS><RECONTENT>%@</RECONTENT></BODY></MESSAGE>",user.msisdn,user.eccode,logId,BF,ProcessTel,content];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}


//意见反馈
+ (void)saveFeedback:(id)delegate Title:(NSString *)title Type:(NSString *)type Content:(NSString *)content{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>saveFeedback</METHOD><SESSIONID>2</SESSIONID><TITLE>%@</TITLE><TYPE>%@</TYPE><CONTENT>%@</CONTENT></BODY></MESSAGE>",user.msisdn,user.eccode,title,type,content];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//安装量
+ (void)phoneStatisticsFun:(id)delegate Install:(NSString *)install{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>SaveException</METHOD><INSTALL>%@</INSTALL></BODY></MESSAGE>",install];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取公文与邮箱数量
+ (void)getSum:(id)delegate Type:(NSString *)type{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getSum</METHOD></BODY></MESSAGE>",user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:type];
}

//本地通讯录信息展示
+ (void)showAddressInfo:(id)delegate GroupID:(NSString *)groupId Pages:(NSString *)PageId Type:(NSString *)type Condition:(NSString *)condition{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>showAddressInfo</METHOD><SESSIONID>2</SESSIONID><GROUPID>%@</ GROUPID><PAGEID>%@</PAGEID><PAGESIZE>20</PAGESIZE><TYPE>%@</TYPE><CONDITION>%@</CONDITION></BODY></MESSAGE>",user.msisdn,user.eccode,groupId,PageId,type,condition];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//公文流程展示
+ (void)showFlowDocList:(id)delegate DocID:(NSString *)docId{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:OutTime];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>showFlowDocList</METHOD><DOCID>%@</DOCID></BODY></MESSAGE>",user.msisdn,user.eccode,docId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//上次单位码上传
+ (void)updateLastEccoed:(id)delegate lastEcconde:(NSString *)lastEcconde{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>updateLastEccoed</METHOD><LASTECCODE>%@</LASTECCODE></BODY></MESSAGE>",user.msisdn,lastEcconde];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//系统通讯录更新
+ (void)updateAddressBook:(id)delegate updatetime:(NSString *)time{
   NSURL * url =[self urlByConfigFile];
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>NOKEY</SECURITYKEY><ECCODE>%@</ECCODE></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getEcInfoList</METHOD><updatetime>%@</updatetime></BODY></MESSAGE>",user.msisdn,user.eccode,time];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//修改密码
+ (void)AlterPassword:(id)delegate beforePassword:(NSString *)beforePassword NewPassword:(NSString *)newPassword{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><PHONE>%@</PHONE><SECURITYKEY>NOKEY</SECURITYKEY><ECCODE>%@</ECCODE></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>modifyECMemberPass</METHOD><ECCODE>%@</ECCODE><PHONE>%@</PHONE><OLDPASSWORD>%@</OLDPASSWORD><NEWPASSWORD>%@</NEWPASSWORD></BODY></MESSAGE>",user.msisdn,user.eccode,user.eccode,user.msisdn,beforePassword,newPassword];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//获取日程提醒
+ (void)getWarningDatas:(id)delegate pages:(int)pageId Type:(int)type SELType:(NSString *)sel{
    NSString * waringType;
    if (type==10000)waringType =@"";
    else waringType  =[NSString stringWithFormat:@"%d",type];
  ////////////////////////////////////////////////////////////
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getWarningDatas</METHOD><SESSIONID>2</SESSIONID><PAGEID>%d</PAGEID><PAGESIZE>0</PAGESIZE><TYPE>%@</TYPE></BODY></MESSAGE>",user.msisdn,user.eccode,0,waringType];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//添加日程提醒
+ (void)addWarningData:(id)delegate content:(NSString *)content Type:(int)tpye warningDate:(NSString *)date warningRequstType:(int)requstType SELType:(NSString *)sel{
    NSString * waringRequstType;
    if (requstType==10000)waringRequstType =@"";
    else waringRequstType  =[NSString stringWithFormat:@"%d",requstType];
    
    int greetingType ;
    if (tpye==2)greetingType=99;
    else greetingType=-1;
    ////////////////////////////////////////////////////////////
    
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>addWarningdata</METHOD><SESSIONID>2</SESSIONID><CONTENT>%@</CONTENT><TYPE>%d</TYPE><WARNINGDATE>%@</WARNINGDATE><REPEATTIME>%@</REPEATTIME><GREETINGTYPE>%d</GREETINGTYPE></BODY></MESSAGE>",user.msisdn,user.eccode,content,tpye,date,waringRequstType,greetingType];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//修改日程提醒
+ (void)updateWarningData:(id)delegate warningID:(NSString *)ID content:(NSString *)content Type:(int)tpye warningDate:(NSString *)date warningRequstType:(int)requstType SELType:(NSString *)sel{
    int greetingType ;
    if (tpye==2)greetingType=99;
    else greetingType=-1;
     ////////////////////////////////////////////////////////////
    
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>updateWarningData</METHOD><SESSIONID>2</SESSIONID><UPDATEID>%@</UPDATEID><CONTENT>%@</CONTENT><TYPE>%d</TYPE><WARNINGDATE>%@</WARNINGDATE><REPEATTIME>%d</REPEATTIME><GREETINGTYPE>%d</GREETINGTYPE></BODY></MESSAGE>",user.msisdn,user.eccode,ID,content,tpye,date,requstType,greetingType];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//删除日程提醒
+ (void)deleteWarningData:(id)delegate warningID:(NSString *)ID SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>deleteWarningData</METHOD><SESSIONID>2</SESSIONID><DELETEID>%@</DELETEID></BODY></MESSAGE>",user.msisdn,user.eccode,ID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取日程提醒短信模版
+ (void)getGreetings:(id)delegate greetingType:(NSString *)type SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getGreetings</METHOD><GREETINGTYPE>%@</GREETINGTYPE><SESSIONID>2</SESSIONID></BODY></MESSAGE>",user.msisdn,user.eccode,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//更新短信人气（＋1）
+ (void)updateGreetingCount:(id)delegate greetingID:(NSString *)ID greetingCount:(NSString *)count SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>updateGreetingCount</METHOD><SESSIONID>2</SESSIONID><GREETID>%@</GREETID><GREETINGCOUNT>%@</GREETINGCOUNT></BODY></MESSAGE>",user.msisdn,user.eccode,ID,count];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//新闻资讯评论列表
+ (void)getCommentListData:(id)delegate newsID:(NSString *)ID pages:(int)pageId  SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getNewsDiscuess</METHOD><SESSIONID>2</SESSIONID><NEWSID>%@</NEWSID></BODY></MESSAGE>",user.msisdn,user.eccode,ID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//发表新闻评论
+ (void)sendNewsComment:(id)delegate  content:(NSString *)content discuesstime:(NSString *)discuesstime newsID:(NSString *)ID{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><ECNAME>%@</ECNAME><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>addNewsDiscuess</METHOD><SESSIONID>2</SESSIONID><NAME>%@</NAME><CONTENT>%@</CONTENT><DISCUESSTIME>%@</DISCUESSTIME><NEWSID>%@</NEWSID></BODY></MESSAGE>",user.msisdn,user.eccode,user.ecname,user.username,content,discuesstime,ID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//新闻点赞
+ (void)commendNews:(id)delegate newsID:(NSString *)ID SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>updateAgree</METHOD><NEWSID>%@</NEWSID><SESSIONID>2</SESSIONID></BODY></MESSAGE>",user.msisdn,user.eccode,ID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}
//即时聊天发送信息
+ (void)imSend:(id)delegate chat:(ChatMsgObj *)obj{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>addChatData</METHOD><CHATTYPE>%@</CHATTYPE><SENDERECCODE>%@</SENDERECCODE><SENDERMSISDN>%@</SENDERMSISDN><RECEIVERECCODE>%@</RECEIVERECCODE><RECEIVERMSISDN>%@</RECEIVERMSISDN><SENDERTIME>%@</SENDERTIME><CONTENT>%@</CONTENT><FILEPATH>%@</FILEPATH><GROUPID>%@</GROUPID><SENDERIMGPATH>%@</SENDERIMGPATH><RECEIVERIMGPATH>%@</RECEIVERIMGPATH><SENDERNAME>%@</SENDERNAME><RECEIVERNAME>%@</RECEIVERNAME><VOICETIME>%@</VOICETIME></BODY></MESSAGE>",user.msisdn,user.eccode,obj.chattype,obj.sendeccode,obj.sendmsisdn,obj.receivereccode,obj.receivermsisdn,obj.sendtime,obj.content,obj.filepath,obj.groupid,obj.senderavatar,obj.receiveravatar,user.username,obj.receivername,obj.voicetime];
//    NSLog(@"%@\n",str);
    
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//即时聊天接收信息
+ (void)imRevice:(id)delegate SELType:(NSString *)sel{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getChatData</METHOD><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE></BODY></MESSAGE>",user.msisdn,user.eccode,user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:sel];
}

//获取头像地址
+ (void)imHeadUrl:(id)delegate msisdn:(NSString *)msisdn eccode:(NSString *)eccode{
    NSURL * url =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>getAvatarAddr</METHOD><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE></BODY></MESSAGE>",msisdn,eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request];
}

//上传头像
+ (void)imUploadUrl:(id)delegate type:(NSString *)type data:(NSData *)data selType:(NSString *)selType uuid:(NSString *)uuid{
    NSString * strPath =[[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
    NSURL * url =[NSURL URLWithString:dic[@"hosturl"]];
    [HTTPRequest uploadRequestOperation:delegate type:type imageData:data url:url selType:selType uuid:uuid];
}

//上传链接
+ (void)imUploadLink:(id)delegate msisdn:(NSString *)msisdn eccode:(NSString *)eccode memberid:(NSString *)memberid selType:(NSString *)selType url:(NSString *)url{
    NSURL * nsurl =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>updateAvatarPath</METHOD><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><MEMBERID>%@</MEMBERID><IMGPATH>%@</IMGPATH></BODY></MESSAGE>",user.msisdn,user.eccode,user.msisdn,user.eccode,user.userid,url];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request SELType:selType];
}

//登录提示（回传服务器）
+ (void)iosLoginIn:(id)delegate{
 //   EX_newToken =@"ca8e35608d346b6adc16526ecc254e0673bc3618a2226caf08b2d3f58e9a004f";
    if (!EX_newToken)return;
    NSURL * nsurl =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>iosLoginIn</METHOD><BASICCODE>%@</BASICCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE></BODY></MESSAGE>",user.msisdn,user.eccode,EX_newToken,user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request  SELType:@"servicelayer"];
}

//注销提示（回传服务器）
+ (void)iosLoginOut:(id)delegate{
//    EX_newToken =@"ca8e35608d346b6adc16526ecc254e0673bc3618a2226caf08b2d3f58e9a004f";
    if (!EX_newToken)return;
    NSURL * nsurl =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>iosLoginOut</METHOD><BASICCODE>%@</BASICCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE></BODY></MESSAGE>",user.msisdn,user.eccode,EX_newToken,user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
//    NSData *Servciedata =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *dic =[ParseXML dictionaryForXMLData:Servciedata error:nil];
//    NSLog(@"%@",dic);
   [HTTPRequest JSONRequestOperation:delegate Request:request  SELType:@"servicelayer"];
}

//转入后台提示（回传服务器）
+ (void)iosProcessKill:(id)delegate{
  //  EX_newToken =@"ca8e35608d346b6adc16526ecc254e0673bc3618a2226caf08b2d3f58e9a004f";
    if (!EX_newToken)return;
    if (!user.msisdn)return;
    NSURL * nsurl =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>iosProcessKill</METHOD><BASICCODE>%@</BASICCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE></BODY></MESSAGE>",user.msisdn,user.eccode,EX_newToken,user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request  SELType:@"servicelayer"];
}

//回到前台提示(回传服务器)
+ (void)iosProcessRestart:(id)delegate{
    if (!EX_newToken)return;
    if (!user.msisdn)return;
    NSURL * nsurl =[self urlByConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    NSString * str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><HEAD><FROMCODE>ZWY-C</FROMCODE><TOCODE>ZWY-S</TOCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE><SECURITYKEY>2</SECURITYKEY></HEAD><BODY><PHONETYPE>1</PHONETYPE><REQSIGN>0</REQSIGN><METHOD>iosProcessRestart</METHOD><BASICCODE>%@</BASICCODE><MSISDN>%@</MSISDN><ECCODE>%@</ECCODE></BODY></MESSAGE>",user.msisdn,user.eccode,EX_newToken,user.msisdn,user.eccode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [HTTPRequest JSONRequestOperation:delegate Request:request  SELType:@"servicelayer"];
}
@end
