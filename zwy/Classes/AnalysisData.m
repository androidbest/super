//
//  AnalysisData.m
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import "AnalysisData.h"
#import "Constants.h"
#import "Tuser.h"
#import "ToolUtils.h"
#import "NoticeDetaInfo.h"
#import "PublicMailDetaInfo.h"
#import "InformationInfo.h"
#import "DocContentInfo.h"
#import "DocFlow.h"
#import "UpdataDate.h"
@implementation AnalysisData


//判断请求返回结果
+ (RespInfo*)ReTurnInfo:(NSDictionary *)dic{
    RespInfo *info=[RespInfo new];
    info.resultcode=[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"HEAD"] objectForKey:@"RESULTCODE"] objectForKey:@"text"];
    info.respCode=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"respCode"] objectForKey:@"text"];
    info.respMsg=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"respMessage"] objectForKey:@"text"];
    info.ID=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"id"] objectForKey:@"text"];
    return info;
}

//检查通讯录更新
+ (RespInfo *)addressUpdataInfo:(NSDictionary *)dic{
RespInfo *info=[RespInfo new];
    info.resultcode=[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"HEAD"] objectForKey:@"RESULTCODE"] objectForKey:@"text"];
    info.respCode =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"respCode"] objectForKey:@"text"];
    info.respMsg =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"respMessage"] objectForKey:@"text"];
    info.updatetime=[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"updatetime"] objectForKey:@"text"];
    return info;

}

//所有EC单位
+ (RespList *)AllECinterface:(NSDictionary *)dic{
    RespList * resplist =[RespList new];
    resplist.resplist=[NSMutableArray new];
    NSArray *arrEC=nil;
    NSObject *obj =[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"]objectForKey:@"EcInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arrEC=[NSArray arrayWithArray:(NSArray *)obj];
    }else if([obj isKindOfClass:[NSDictionary class]]){
        arrEC=[NSArray arrayWithObjects:(NSDictionary  *)obj, nil];
    }
    for (int i=0; i<arrEC.count; i++) {
        NSString* ecid  =[[[arrEC objectAtIndex:i] objectForKey:@"eccode"] objectForKey:@"text"];
        NSString * ecname=[[[arrEC objectAtIndex:i] objectForKey:@"ecname"] objectForKey:@"text"];
        
        if(!ecid){
            continue;
        }
        
        NSString *lastecid=[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"]objectForKey:@"LASTECCODE"] objectForKey:@"text"];
        EcinfoDetas *detas=[EcinfoDetas new];
        detas.ECID=ecid;
        detas.ECName=ecname;
        detas.lastEcid=lastecid;
        [resplist.resplist addObject:detas];
    }
    return resplist;
}

//登录
+ (Tuser*)LoginData:(NSDictionary *)dicData{
    Tuser *user=[Tuser new];
    user.respcode=[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"respCode"] objectForKey:@"text"];

        user.username =[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"userName"] objectForKey:@"text"];
        user.ecname=[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"ecName"] objectForKey:@"text"];
        user.ecsignname=[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"ecSignName"] objectForKey:@"text"];

    return user;
}

//登录
+ (Tuser*)autoLoginData:(NSDictionary *)dicData{
    Tuser *user=[Tuser new];
    user.respcode=[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"respCode"] objectForKey:@"text"];
    
    user.username =[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"userName"] objectForKey:@"text"];
    user.ecname=[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"ecName"] objectForKey:@"text"];
    user.ecsignname=[[[[[dicData objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"AuthInfo"] objectForKey:@"ecSignName"] objectForKey:@"text"];
    
    return user;
}

//短信模板分类列表
+ (SMSInfo *)templateInfor:(NSDictionary *)dic{
    SMSInfo *SMS =[SMSInfo new];
    SMS.AllSMSLate =[[NSMutableArray alloc] init];
    NSMutableArray *arrAll =nil;
    NSMutableArray * arrTitle=[[NSMutableArray alloc] init];
    arrAll=[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"TemplateTypeInfo"];
    for (int i=0; i<arrAll.count; i++) {
        NSString * strID =[[[arrAll objectAtIndex:i] objectForKey:@"parentid"] objectForKey:@"text"];
        if ([strID isEqualToString:@"-1"]) {
            [arrTitle addObject:[arrAll objectAtIndex:i]];
        }
    }
    for (int j=0; j<arrTitle.count; j++) {
        NSString * strLastID=[[[arrTitle objectAtIndex:j] objectForKey:@"templateid"]objectForKey:@"text"];
        NSString * strLastName =[[[arrTitle objectAtIndex:j] objectForKey:@"templatename"]objectForKey:@"text"];
        SMS.detas=[SMSDetaInfo new];
        SMS.detas.templatename=strLastName;
        SMS.detas.Alltitle =[[NSMutableArray alloc] init];
        for (int k=0; k<arrAll.count; k++) {
            NSString * strTitleID=[[[arrAll objectAtIndex:k] objectForKey:@"parentid"] objectForKey:@"text"];
            NSString * strTitleName =[[[arrAll objectAtIndex:k] objectForKey:@"templatename"] objectForKey:@"text"];
            if ([strTitleID isEqualToString:strLastID]&&![strTitleID isEqualToString:@"-1"]) {
                NSString * strRowTitleID=[[[arrAll objectAtIndex:k] objectForKey:@"templateid"] objectForKey:@"text"];
                SMS.detas.sonDetas=[SmsSonDetaInto new];
                SMS.detas.sonDetas.SmsID=strRowTitleID;
                SMS.detas.sonDetas.SmsName=strTitleName;
                [SMS.detas.Alltitle addObject:SMS.detas.sonDetas];
            }
        }
        [SMS.AllSMSLate addObject:SMS.detas];
    }
    return SMS;
}

//获取短信模板信息
+ (SMSInfo *)getTemplate:(NSDictionary *)dic{
    SMSInfo *SMS =[SMSInfo new];
    SMS.AllSMSContent =[[NSMutableArray alloc] init];
    NSArray *arr;
    NSObject *obj =[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"]objectForKey:@"TemplateDataInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    SMS.rowCount=[[[arr objectAtIndex:0] objectForKey:@"countRow"] objectForKey:@"text"];
    for (int i=0; i<arr.count; i++) {
        NSString * strContent=[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        NSString * strID=[[[arr objectAtIndex:i] objectForKey:@"contentid"] objectForKey:@"text"];
        SMS.detas =[SMSDetaInfo new];
        SMS.detas.content=strContent;
        SMS.detas.contentid=strID;
        [SMS.AllSMSContent addObject:SMS.detas];
    }
    return SMS;
}


//新闻
+ (RespList *)newsInfo:(NSDictionary *)dic{
   RespList * resplist=[RespList new];
    resplist.resplist=[NSMutableArray new];
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"NewsList"] objectForKey:@"NewsInfo"];
    NSArray *arr;
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++){
        NSString *StrContent =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        NSString * title=[[[arr objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"];
        NSString * ID =[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
        InformationInfo *detail=[InformationInfo new];
        detail.agreecount =[[[arr objectAtIndex:i] objectForKey:@"agreecount"] objectForKey:@"text"];
        detail.imagePath=[[[arr objectAtIndex:i] objectForKey:@"imgpath"] objectForKey:@"text"];
        detail.insertTime=[[[arr objectAtIndex:i] objectForKey:@"insertTime"] objectForKey:@"text"];
        detail.releaseTime=[[[arr objectAtIndex:i] objectForKey:@"releaseTime"] objectForKey:@"text"];
        detail.sourceName=[[[arr objectAtIndex:i] objectForKey:@"sourcename"] objectForKey:@"text"];
        detail.sourcepath=[[[arr objectAtIndex:i] objectForKey:@"sourcepath"] objectForKey:@"text"];
        detail.content=StrContent;
        detail.title=title;
        detail.newsID=ID;
        [resplist.resplist addObject:detail];
    }
    return resplist;
}

//笑话
+ (RespList *)JokeInfo:(NSDictionary *)dic{
    RespList * resplist=[RespList new];
    resplist.resplist=[NSMutableArray new];
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"JokeList"] objectForKey:@"JokeInfo"];
    NSArray *arr;
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++){
        NSString *StrContent =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        NSString * title=[[[arr objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"];
        InformationInfo *detail=[InformationInfo new];
        detail.agreecount =[[[arr objectAtIndex:i] objectForKey:@"agreecount"] objectForKey:@"text"];
        detail.imagePath=[[[arr objectAtIndex:i] objectForKey:@"imgpath"] objectForKey:@"text"];
        detail.insertTime=[[[arr objectAtIndex:i] objectForKey:@"insertTime"] objectForKey:@"text"];
        detail.releaseTime=[[[arr objectAtIndex:i] objectForKey:@"releaseTime"] objectForKey:@"text"];
        detail.sourceName=[[[arr objectAtIndex:i] objectForKey:@"sourcename"] objectForKey:@"text"];
        detail.sourcepath=[[[arr objectAtIndex:i] objectForKey:@"sourcepath"] objectForKey:@"text"];
        detail.content=StrContent;
        detail.title=title;
        [resplist.resplist addObject:detail];
    }
    return resplist;
}

//政府公告信息
+ (RespList *)getNoticeList:(NSDictionary *)dic{
    RespList * NoticeInfo=[RespList new];
    NoticeInfo.resplist=[[NSMutableArray alloc] init];
    NoticeInfo.rowCount=[ToolUtils stringToNum:[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"PublicInfoList"] objectForKey:@"rowcount"] objectForKey:@"text"]];
    NSArray *arr;
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"PublicInfoList"] objectForKey:@"PublicInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
       arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    
    for (int i=0; i<arr.count; i++){
        NSString *StrContent =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        NSString * strInfoid=[[[arr objectAtIndex:i] objectForKey:@"infoid"] objectForKey:@"text"];
        NSString *strPublicdate=[[[arr objectAtIndex:i] objectForKey:@"publicdate"] objectForKey:@"text"];
        NSString *strStatusid =[[[arr objectAtIndex:i] objectForKey:@"statusid"] objectForKey:@"text"];
        NSString * strTitle =[[[arr objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"];
        NoticeDetaInfo *detail=[NoticeDetaInfo new];
        detail.content=StrContent;
        detail.infoid=strInfoid;
        detail.publicdate=strPublicdate;
        detail.statusid=strStatusid;
        detail.title=strTitle;
        [NoticeInfo.resplist addObject:detail];
    }
    return NoticeInfo;
}

//
////获取用户总数
//
////查部门总数
//
//通讯录分组信息
+ (GroupsInfo *)getGroups:(NSDictionary *)dic{
    GroupsInfo * group =[GroupsInfo new];
    group.AllGroups =[[NSMutableArray alloc] init];
    
    group.rowCount =[[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"GroupList"] objectForKey:@"rowCount"] objectForKey:@"text"] intValue];
    NSArray *arr;
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"GroupList"] objectForKey:@"GroupInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++){
        group.detas=[GroupDetaInfo new];
        group.detas.groupId =[[[arr objectAtIndex:i] objectForKey:@"groupid"] objectForKey:@"text"];
        group.detas.groupName =[[[arr objectAtIndex:i] objectForKey:@"groupname"] objectForKey:@"text"];
        [group.AllGroups addObject:group.detas];
    }
    return group;
}

//通讯录成员信息
+ (GroupsInfo *)getGroupmember:(NSDictionary *)dic{
    GroupsInfo * group =[GroupsInfo new];
    group.AllGroupmembers =[[NSMutableArray alloc] init];
    
      group.rowCount =[[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"UserList"] objectForKey:@"rowCount"] objectForKey:@"text"] intValue];
    NSArray *arr;
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"UserList"] objectForKey:@"UserInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++){
        group.peopleDetas =[PeopleDedaInfo new];
        group.peopleDetas.ecCode=[[arr[i] objectForKey:@"eccode"] objectForKey:@"text"];
        group.peopleDetas.email =[[arr[i] objectForKey:@"email"] objectForKey:@"text"];
        group.peopleDetas.groupid=[[arr[i] objectForKey:@"groupid"] objectForKey:@"text"];
        group.peopleDetas.groupname =[[arr[i] objectForKey:@"groupname"] objectForKey:@"text"];
        group.peopleDetas.sex =[[arr[i] objectForKey:@"sex"] objectForKey:@"text"];
        group.peopleDetas.userName=[[arr[i] objectForKey:@"userName"] objectForKey:@"text"];
        group.peopleDetas.userTel =[[arr[i] objectForKey:@"usernumber"] objectForKey:@"text"];
        [group.AllGroupmembers addObject:group.peopleDetas];
    }
    return group;
}
//
//获取公文列表
+ (RespList *)getDocList:(NSDictionary *)dic{
    RespList * doc =[RespList new];
    doc.resplist =[[NSMutableArray alloc] init];
    doc.rowCount=[ToolUtils stringToNum:[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocInfoList"] objectForKey:@"rowCount"] objectForKey:@"text"] ];
    
    NSArray * arr ;
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocInfoList"] objectForKey:@"DocInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[[NSArray alloc] initWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++) {
        DocContentInfo *info=[DocContentInfo new];
        info.affixUrl =[[[arr objectAtIndex:i] objectForKey:@"affixUrl"] objectForKey:@"text"];
        info.content=[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        info.fileSize=[[[arr objectAtIndex:i] objectForKey:@"fileSize"] objectForKey:@"text"];
        info.ID=[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
        info.InfoType=[[[arr objectAtIndex:i] objectForKey:@"infoType"] objectForKey:@"text"];
        info.textUrl=[[[arr objectAtIndex:i] objectForKey:@"textUrl"] objectForKey:@"text"];
        info.time =[[[arr objectAtIndex:i] objectForKey:@"time"] objectForKey:@"text"];
        info.title= [[[arr objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"];
        info.type =[[[arr objectAtIndex:i] objectForKey:@"type"] objectForKey:@"text"];
        [doc.resplist addObject:info];
    }
    return doc;
}

////获取公文已办或已审列表
//+ (RespList *)alreadyDocList:(NSDictionary *)dic{
//
//    RespList * doc =[RespList new];
//    doc.resplist =[[NSMutableArray alloc] init];
//    doc.rowCount=[ToolUtils stringToNum:[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocInfoList"] objectForKey:@"rowCount"] objectForKey:@"text"] ];
//    
//    NSArray * arr ;
//    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocInfoList"] objectForKey:@"DocInfo"];
//    if ([obj isKindOfClass:[NSArray class]]) {
//        arr=[[NSArray alloc] initWithArray:(NSArray *)obj];
//    }else{
//        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
//    }
//    for (int i=0; i<arr.count; i++) {
//        DocContentInfo *info=[DocContentInfo new];
//        info.affixUrl =[[[arr objectAtIndex:i] objectForKey:@"affixUrl"] objectForKey:@"text"];
//        info.content=[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
//        info.fileSize=[[[arr objectAtIndex:i] objectForKey:@"fileSize"] objectForKey:@"text"];
//        info.ID=[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
//        info.InfoType=[[[arr objectAtIndex:i] objectForKey:@"infoType"] objectForKey:@"text"];
//        info.textUrl=[[[arr objectAtIndex:i] objectForKey:@"textUrl"] objectForKey:@"text"];
//        info.time =[[[arr objectAtIndex:i] objectForKey:@"time"] objectForKey:@"text"];
//        info.title= [[[arr objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"];
//        info.type =[[[arr objectAtIndex:i] objectForKey:@"type"] objectForKey:@"text"];
//        [doc.resplist addObject:info];
//    }
//    return doc;
//}


//获取公文信息
+ (DocContentInfo *)getDocContentInfo:(NSDictionary *)dic{
    DocContentInfo *info =[DocContentInfo new];
    NSArray * arr ;
    NSObject * obj =[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocInfo"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[[NSArray alloc] initWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++) {
        info.affixUrl =[[[arr objectAtIndex:i] objectForKey:@"affixUrl"] objectForKey:@"text"];
        info.content=[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        info.fileSize=[[[arr objectAtIndex:i] objectForKey:@"fileSize"] objectForKey:@"text"];
        info.ID=[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
        info.InfoType=[[[arr objectAtIndex:i] objectForKey:@"infoType"] objectForKey:@"text"];
        info.textUrl=[[[arr objectAtIndex:i] objectForKey:@"textUrl"] objectForKey:@"text"];
        info.time =[[[arr objectAtIndex:i] objectForKey:@"time"] objectForKey:@"text"];
        info.title= [[[arr objectAtIndex:i] objectForKey:@"title"] objectForKey:@"text"];
        info.type =[[[arr objectAtIndex:i] objectForKey:@"type"] objectForKey:@"text"];
        info.name =[[[arr objectAtIndex:i] objectForKey:@"name"] objectForKey:@"text"];
    }
    
    
    return info;
}

//获取附件列表
+ (OfficeInfo *)getDocAccessory:(NSDictionary *)dic{
    OfficeInfo *info=[OfficeInfo new];
    info.AllOfficeInfo =[[NSMutableArray alloc] init];
    NSArray * arr ;
    NSObject * obj =[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocAttachment"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[[NSArray alloc] initWithArray:(NSArray *)obj];
    }else{
        arr=[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++) {
        info.detaInfo=[officeDetaInfo new];
        info.detaInfo.fileid =[[[arr objectAtIndex:i] objectForKey:@"fileid"] objectForKey:@"text"];
        info.detaInfo.filename=[[[arr objectAtIndex:i] objectForKey:@"filename"] objectForKey:@"text"];
        info.detaInfo.filesize =[[[arr objectAtIndex:i] objectForKey:@"filesize"] objectForKey:@"text"];
        info.detaInfo.infoid=[[[arr objectAtIndex:i] objectForKey:@"infoid"] objectForKey:@"text"];
        info.detaInfo.url=[[[arr objectAtIndex:i] objectForKey:@"url"] objectForKey:@"text"];
        [info.AllOfficeInfo addObject:info.detaInfo];
    }
    return info;
}

////获取公文附件

//获取群众信箱办理列表
+ (RespList *)getPublicMailList:(NSDictionary *)dic{
    RespList *list =[RespList new];
    list.rowCount=[ToolUtils stringToNum:[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"PublicMailList"] objectForKey:@"rowCount"] objectForKey:@"text"]];
    
    list.resplist =[[NSMutableArray alloc] init];
    NSArray * arr ;
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"PublicMailList"] objectForKey:@"PublicMail"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr =[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++) {
        PublicMailDetaInfo *info=[PublicMailDetaInfo new];
        info.content =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        info.contetnType =[[[arr objectAtIndex:i] objectForKey:@"contenttype"] objectForKey:@"text"];
        info.infoid =[[[arr objectAtIndex:i] objectForKey:@"infoid"] objectForKey:@"text"];
        info.msgtype=[[[arr objectAtIndex:i] objectForKey:@"msgtype"] objectForKey:@"text"];
        info.msisdn=[[[arr objectAtIndex:i] objectForKey:@"msisdn"] objectForKey:@"text"];
        info.senddate=[[[arr objectAtIndex:i] objectForKey:@"senddate"] objectForKey:@"text"];
        info.sendtype =[[[arr objectAtIndex:i] objectForKey:@"sendtype"] objectForKey:@"text"];
        [list.resplist addObject:info];
    }
    return list;
}

//获取群众信箱审批列表
+ (RespList *)getAuditMailList:(NSDictionary *)dic{
    RespList *list =[RespList new];
     list.rowCount=[ToolUtils stringToNum:[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"PublicMailList"] objectForKey:@"rowcount"] objectForKey:@"text"]];
  
    list.resplist =[[NSMutableArray alloc] init];
    NSArray * arr ;
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"PublicMailList"] objectForKey:@"PublicMail"];
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr =[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++) {
        PublicMailDetaInfo *info=[PublicMailDetaInfo new];
        info.content =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        info.contetnType =[[[arr objectAtIndex:i] objectForKey:@"contenttype"] objectForKey:@"text"];
        info.infoid =[[[arr objectAtIndex:i] objectForKey:@"infoid"] objectForKey:@"text"];
        info.msgtype=[[[arr objectAtIndex:i] objectForKey:@"msgtype"] objectForKey:@"text"];
        info.msisdn=[[[arr objectAtIndex:i] objectForKey:@"msisdn"] objectForKey:@"text"];
        info.senddate=[[[arr objectAtIndex:i] objectForKey:@"senddate"] objectForKey:@"text"];
        info.sendtype =[[[arr objectAtIndex:i] objectForKey:@"sendtype"] objectForKey:@"text"];
        [list.resplist addObject:info];
    }
    return list;
}
//
////获取群众信箱办理人信息
//+ (PublicUserDetaInfo *)getPublicMailUsers:(NSDictionary *)dic{
//    PublicUserDetaInfo *pubInfo=[PublicUserDetaInfo new];
//    return pubInfo;
//}
//
////获取群众信箱关联单位信息
//+ (PublicUserDetaInfo *)getPublicMailGroups:(NSDictionary *)dic{
//    PublicUserDetaInfo *pubInfo =[PublicUserDetaInfo new];
//    return pubInfo;
//}

//群众信箱办理流程
+ (RespInfo *)processmail:(NSDictionary *)dic{
    RespInfo *info=[RespInfo new];
    info.resultcode=[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"HEAD"] objectForKey:@"RESULTCODE"] objectForKey:@"text"];
    info.respCode=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"respCode"] objectForKey:@"text"];
    info.respMsg=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"respMessage"] objectForKey:@"text"];
    return info;
}

//群众信箱审核流程
+ (RespInfo *)auditmail:(NSDictionary *)dic{
    RespInfo *info=[RespInfo new];
    info.resultcode=[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"HEAD"] objectForKey:@"RESULTCODE"] objectForKey:@"text"];
    info.respCode=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"respCode"] objectForKey:@"text"];
    info.respMsg=[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"RespInfo"] objectForKey:@"respMessage"] objectForKey:@"text"];
    return info;
}
//
//获取公文与邮箱数量
+ (SumEmailOrDocInfo *)getSum:(NSDictionary *)dic{
    SumEmailOrDocInfo *sumInfo =[SumEmailOrDocInfo new];
    sumInfo.sumDoc =[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"Sum"] objectForKey:@"docSum"] objectForKey:@"text"];
    sumInfo.sumEmail =[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"Sum"] objectForKey:@"mailSum"] objectForKey:@"text"];
    return sumInfo;
}
//
////本地通讯录信息展示
//+ (AddressInfo *)showAddressInfo:(NSDictionary *)dic{
//    AddressInfo * address=[AddressInfo new];
//    return address;
//}
//
//公文流程展示
+ (RespList *)showFlowDocList:(NSDictionary *)dic{
    RespList * flowDoc=[RespList new];
    flowDoc.resplist=[NSMutableArray new];
    NSObject * obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"DocInfoList"] objectForKey:@"DocFlow"];
    NSArray * arr ;
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr =[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0; i<arr.count; i++) {
        DocFlow *info=[DocFlow new];
        info.membername=[[[arr objectAtIndex:i] objectForKey:@"membername"] objectForKey:@"text"];
        info.overTime=[[[arr objectAtIndex:i] objectForKey:@"overTime"] objectForKey:@"text"];
        info.describe=[[[arr objectAtIndex:i] objectForKey:@"describe"] objectForKey:@"text"];
        info.doStatus=[[[arr objectAtIndex:i] objectForKey:@"doStatus"] objectForKey:@"text"];
        info.content=[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        [flowDoc.resplist addObject:info];
    }
    return flowDoc;
}

//日程提醒列表
+ (warningInfo *)warningList:(NSDictionary *)dic{
    warningInfo * warning =[warningInfo new];
    warning.warningList=[[NSMutableArray alloc] init];
    NSString *count =[[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"WaringData"] objectForKey:@"allcount"] objectForKey:@"text"];
    warning.AllCount=[count intValue];
    
    NSObject *obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"WaringData"] objectForKey:@"WaringDataInfo"];
    if (!obj) return warning;
    NSArray * arr ;
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr =[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    
    for (int i=0;i<arr.count; i++) {
        warningDataInfo *data=[warningDataInfo new];
        data.content =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        data.warningID=[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
        data.UserTel =[[[arr objectAtIndex:i] objectForKey:@"msisdn"] objectForKey:@"text"];
        data.RequestType=[[[arr objectAtIndex:i] objectForKey:@"repeatime"] objectForKey:@"text"];
        data.warningType =[[[arr objectAtIndex:i] objectForKey:@"type"] objectForKey:@"text"];
        data.greetingType =[[[arr objectAtIndex:i] objectForKey:@"greetingtype"] objectForKey:@"text"];
        data.isUserHandAdd=[[[arr objectAtIndex:i] objectForKey:@"datatype"] objectForKey:@"text"];
        /****/
        NSString *strDate =[[[arr objectAtIndex:i] objectForKey:@"warningdate"] objectForKey:@"text"];//毫秒数
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:[strDate doubleValue]];//毫秒转date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//初始化转换格式
        [formatter setDateFormat:@"yyyy-MM-dd"];//设置转换格式
        data.warningDate =[formatter stringFromDate:d];//
        data.brithdayDate=data.warningDate;//生日
        NSString *TimeNow = [formatter stringFromDate:[NSDate date]];
        if ([data.RequestType isEqualToString:@"1"]) {
            data.warningDate =[UpdataDate reqeatWithWeekTodate:data.warningDate];
        }
        if ([data.RequestType isEqualToString:@"2"]) {
            data.warningDate =[UpdataDate reqeatWithMonthTodate:data.warningDate];
        }
        if ([data.RequestType isEqualToString:@"3"]) {
            data.warningDate =[UpdataDate reqeatWithYearTodate:data.warningDate];
        }
        
        int remainDays = [ToolUtils compareOneDay:TimeNow withAnotherDay:data.warningDate];
        data.remainTime  =[NSString stringWithFormat:@"%d",remainDays];
        /****/
       [warning.warningList addObject:data];
    }
    return warning;
}

//获取日程提醒短信模版
+ (GreetingInfo *)getGreetingList:(NSDictionary *)dic{
    GreetingInfo *info=[GreetingInfo new];
    info.arrGreetList =[[NSMutableArray alloc] init];
    
    NSObject *obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"Greeting"] objectForKey:@"GreetingInfo"];
    if (!obj) return info;
    NSArray * arr ;
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr =[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0;i<arr.count; i++) {
        info.detaInfo =[GreetDetaInfo new];
        info.detaInfo.Content =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        info.detaInfo.ID =[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
        int strCount =[[[[arr objectAtIndex:i] objectForKey:@"greetingcount"] objectForKey:@"text"] intValue];
        if (strCount>0)info.detaInfo.greetingcount=[NSString stringWithFormat:@"%d",strCount];
        else info.detaInfo.greetingcount=@"0";
        [info.arrGreetList addObject:info.detaInfo];
    }
    return info;
}

//新闻资讯列表
+ (CommentListInfo *)getCommentList:(NSDictionary *)dic{
    CommentListInfo *info =[CommentListInfo new];
    info.arrCommentList =[[NSMutableArray alloc] init];
    
    NSObject *obj =[[[[dic objectForKey:@"MESSAGE"] objectForKey:@"BODY"] objectForKey:@"NewsDiscuessList"] objectForKey:@"NewsDiscuessInfo"];
    if (!obj) return info;
    NSArray * arr ;
    if ([obj isKindOfClass:[NSArray class]]) {
        arr=[NSArray arrayWithArray:(NSArray *)obj];
    }else{
        arr =[NSArray arrayWithObjects:(NSDictionary *)obj, nil];
    }
    for (int i=0;i<arr.count; i++) {
        info.detaInfo =[CommentDetaInfo new];
        info.detaInfo.content =[[[arr objectAtIndex:i] objectForKey:@"content"] objectForKey:@"text"];
        info.detaInfo.content=[info.detaInfo.content stringByReplacingOccurrencesOfString:@"\n" withString:@"*"];
        info.detaInfo.discuesstime=[[[arr objectAtIndex:i] objectForKey:@"discuesstime"] objectForKey:@"text"];
        info.detaInfo.ID=[[[arr objectAtIndex:i] objectForKey:@"id"] objectForKey:@"text"];
        info.detaInfo.inserttime=[[[arr objectAtIndex:i] objectForKey:@"inserttime"] objectForKey:@"text"];
        info.detaInfo.msisdn=[[[arr objectAtIndex:i] objectForKey:@"msisdn"] objectForKey:@"text"];
        info.detaInfo.name=[[[arr objectAtIndex:i] objectForKey:@"name"] objectForKey:@"text"];
        info.detaInfo.newsid=[[[arr objectAtIndex:i] objectForKey:@"newsid"] objectForKey:@"text"];
        [info.arrCommentList addObject:info.detaInfo];
    }
    return info;
}
@end
