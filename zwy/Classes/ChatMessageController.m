//
//  ChatMessageController.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ChatMessageController.h"
#import "ChatMessageCell.h"
#import "CompressImage.h"
#import "ToolUtils.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "RespInfo.h"
#import "PeopelInfo.h"
#import "CoreDataManageContext.h"
#import "Constants.h"
#import "ChatEntity.h"
#import "SessionEntity.h"
@implementation ChatMessageController{
    NSMutableArray *arrData;//数据储存
    NSMutableArray *arrTime;//时间保存
    NSMutableArray *arrBool;//判断高度
    NSInteger num;
    ChatMsgObj *obj;
}

-(id)init{
    self=[super init];
    if(self){
        num=0;
        arrData=[NSMutableArray new];
        arrTime=[NSMutableArray new];
        arrBool=[NSMutableArray new];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        

    }
    return self;
}

-(void)initDatatoData{
    PeopelInfo *info=self.chatMessageView.chatData;
    NSString *chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,info.tel,info.eccode];
    //        [arrData addObjectsFromArray:];
    NSArray *tempArr=[[CoreDataManageContext newInstance] getUserChatMessageWithChatMessageID:chatMessageID FetchOffset:num FetchLimit:10];
    
    for(ChatEntity *chat in tempArr){
        ChatMsgObj *chatObj=[ChatMsgObj new];
        chatObj.chattype=chat.chat_msgtype;
        chatObj.sendeccode=user.eccode;
        chatObj.sendmsisdn=user.msisdn;
        chatObj.receivereccode=chat.chat_sessionObjct.session_receivermsisdn;
        chatObj.receivermsisdn=chat.chat_sessionObjct.session_receivereccode;
        chatObj.receiveravatar=chat.chat_sessionObjct.session_receiveravatar;
        chatObj.receivername=chat.chat_sessionObjct.session_receivername;
        chatObj.content=chat.chat_content;
        chatObj.sendtime=[ToolUtils NSDateToNSString:chat.chat_times format:@"yy/MM/dd HH:mm"];
        chatObj.groupid=@"";
        chatObj.senderavatar=user.headurl;
        chatObj.filepath=@"";
        chatObj.status=chat.chat_status;
        [arrData addObject:chatObj];
        [arrTime addObject:chat.chat_times];
    }
}


//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if(dic){
        RespInfo *info=[AnalysisData imSend:dic];
        if([info.respCode isEqualToString:@"0"]){
           //发送成功
            [[CoreDataManageContext newInstance] setChatInfo:obj status:@"0" isChek:YES];
        }else{
        //发送失败
            
        }
    }else{
        //发送失败
    }
}

-(void)sendMessage{
    
    NSDate *date=[NSDate date];
    [arrTime addObject:date];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat: @"yy/MM/dd HH:mm"];
    
    obj=[ChatMsgObj new];
    obj.chattype=@"0";
    obj.sendeccode=user.eccode;
    obj.sendmsisdn=user.msisdn;
    obj.receivereccode=self.chatMessageView.chatData.eccode;
    obj.receivermsisdn=self.chatMessageView.chatData.tel;
    obj.receiveravatar=self.chatMessageView.chatData.headPath;
    obj.receivername=self.chatMessageView.chatData.Name;
    obj.content=self.chatMessageView.im_text.text;
    obj.sendtime=[formatter stringFromDate:date];
    obj.sendtimeNSdate=date;
    obj.groupid=@"";
    obj.senderavatar=user.headurl;
    obj.filepath=@"";
    obj.status=@"1";
    [packageData imSend:self chat:obj];
    
    
    [arrData addObject:obj];
    [arrTime addObject:date];
    self.chatMessageView.im_text.text=nil;
    [self.chatMessageView.send setEnabled:NO];
    [self.chatMessageView.send setAlpha:0.4];
    [arrBool removeAllObjects];
    [self.chatMessageView.tableview reloadData];
    NSInteger rows = [self.chatMessageView.tableview numberOfRowsInSection:0];
    if(rows > 0) {
        [self.chatMessageView.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                              atScrollPosition:UITableViewScrollPositionBottom
                                                      animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.chatMessageView.im_text resignFirstResponder];
}

//单击
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self.chatMessageView.im_text resignFirstResponder];
}

//由上往下滑动
-(void)handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
    [self.chatMessageView.im_text resignFirstResponder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float leng=0.0;
     ChatMsgObj *msgObj=arrData[indexPath.row];
    UIView *v=nil;
    if([msgObj.status isEqualToString:@"0"]){
    v=[ToolUtils bubbleView:msgObj.content from:YES];
    }else{
    v=[ToolUtils bubbleView:msgObj.content from:NO];
    }
    if([self compareTime:indexPath]){
        leng=v.frame.size.height+30;
        [arrBool addObject:@"0"];
    }else{
        leng=v.frame.size.height+10;
        [arrBool addObject:@"1"];
    }
    return leng;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strCell =@"chatmessage";
//    ChatMessageCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    
    
//    if (!cell) {
//        cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                    reuseIdentifier:strCell];
//    }
    
    ChatMessageCell * cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    ChatMsgObj *msgObj=arrData[indexPath.row];
    NSString *strBool=arrBool[indexPath.row];
    if([msgObj.status isEqualToString:@"0"]){
        cell.leftHead.hidden=YES;
        cell.rightHead.hidden=NO;
        [cell.rightHead addTarget:self action:@selector(rightPushDetail:) forControlEvents:UIControlEventTouchUpInside];
        
    [HTTPRequest imageWithURL:user.headurl imageView:cell.rightHead placeUIButtonImage:[UIImage imageNamed:@"default_avatar"]];
    [ToolUtils bubbleView:msgObj.content from:YES withPosition:60 view:cell.rightMessage];
    if([strBool isEqualToString:@"1"]){
            cell.chatTime.hidden=YES;
            CGRect rectLeftHead=cell.rightHead.frame;
            rectLeftHead.origin.y-=20;
            cell.rightHead.frame=rectLeftHead;
            CGRect rectLeftMessage=cell.rightMessage.frame;
            rectLeftMessage.origin.y-=20;
            cell.rightMessage.frame=rectLeftMessage;
        }else{
            cell.chatTime.text=[ToolUtils NSDateToNSString:arrTime[indexPath.row] format:@"yy/MM/dd HH:mm"];
            cell.chatTime.hidden=NO;
        }
    }else{
        cell.rightHead.hidden=YES;
        cell.leftHead.hidden=NO;
        cell.leftHead.tag=[ToolUtils stringToNum:msgObj.receivermsisdn];
        [cell.leftHead addTarget:self action:@selector(leftPushDetail:) forControlEvents:UIControlEventTouchUpInside];
        [HTTPRequest imageWithURL:msgObj.receiveravatar imageView:cell.rightHead placeUIButtonImage:[UIImage imageNamed:@"default_avatar"]];
        [ToolUtils bubbleView:msgObj.content from:NO withPosition:60 view:cell.leftMessage];
        if([strBool isEqualToString:@"1"]){
            cell.chatTime.hidden=YES;
            CGRect rectLeftHead=cell.leftHead.frame;
            rectLeftHead.origin.y-=20;
            cell.leftHead.frame=rectLeftHead;
            
            CGRect rectLeftMessage=cell.leftMessage.frame;
            rectLeftMessage.origin.y-=20;
            cell.leftMessage.frame=rectLeftMessage;
        }else{
            cell.chatTime.text=[ToolUtils NSDateToNSString:arrTime[indexPath.row] format:@"yy/MM/dd HH:mm"];
            cell.chatTime.hidden=NO;
        }
    }
        return cell;
}

-(void)leftPushDetail:(UIButton *)btn{
    NSMutableArray  *arr = [ConfigFile setEcNumberInfo];
    NSString *strSearchbar =[NSString stringWithFormat:@"SELF.tel CONTAINS '%@'",[ToolUtils numToString:btn.tag]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: strSearchbar];
    NSArray *arrRet =[arr filteredArrayUsingPredicate: predicate];
    if(arrRet.count>0){
        PeopelInfo *pe=arrRet[0];
        self.chatMessageView.chatHead=[PeopelInfo new];
        self.chatMessageView.chatHead.tel=pe.tel;
        self.chatMessageView.chatHead.job=pe.job;
        self.chatMessageView.chatHead.area=pe.area;
        self.chatMessageView.chatHead.status=@"1";
        self.chatMessageView.chatHead.Name=pe.Name;
        self.chatMessageView.chatHead.headPath=user.headurl;
    }
    [self initBackBarButtonItem:self.chatMessageView];
   [self.chatMessageView performSegueWithIdentifier:@"chattoDetailhead" sender:self.chatMessageView];
}

-(void)rightPushDetail:(UIButton *)btn{
    NSMutableArray  *arr = [ConfigFile setEcNumberInfo];
    NSString *strSearchbar =[NSString stringWithFormat:@"SELF.tel CONTAINS '%@'",user.msisdn];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: strSearchbar];
    NSArray *arrRet =[arr filteredArrayUsingPredicate: predicate];
    if(arrRet.count>0){
        PeopelInfo *pe=arrRet[0];
        self.chatMessageView.chatHead=[PeopelInfo new];
        self.chatMessageView.chatHead.tel=pe.tel;
        self.chatMessageView.chatHead.job=pe.job;
        self.chatMessageView.chatHead.area=pe.area;
        self.chatMessageView.chatHead.status=@"1";
        self.chatMessageView.chatHead.Name=pe.Name;
        self.chatMessageView.chatHead.headPath=pe.headPath;
    }
    [self initBackBarButtonItem:self.chatMessageView];
    [self.chatMessageView performSegueWithIdentifier:@"chattoDetailhead" sender:self.chatMessageView];
    
}

//语音切换
-(void)voicepress:(UIButton *)btn{
    if(btn.tag==0){
        self.chatMessageView.send.hidden=YES;
        self.chatMessageView.im_text.hidden=YES;
        self.chatMessageView.voiceSend.hidden=NO;
        [self.chatMessageView.voicepress setBackgroundImage:[UIImage imageNamed:@"voice_play"] forState:UIControlStateNormal];
        btn.tag=1;
    }else{
        self.chatMessageView.send.hidden=NO;
        self.chatMessageView.im_text.hidden=NO;
        self.chatMessageView.voiceSend.hidden=YES;
       [self.chatMessageView.voicepress setBackgroundImage:[UIImage imageNamed:@"voice_press"] forState:UIControlStateNormal];
        btn.tag=0;
    }
    
}

//时间比较
-(BOOL)compareTime:(NSIndexPath *)indexPath{
    NSInteger numTime=arrTime.count;
    if(numTime>0){
        if(indexPath.row==0){
            return YES;
        }else{
            NSInteger last=[arrTime[indexPath.row-1] timeIntervalSince1970];
            NSInteger now=[arrTime[indexPath.row] timeIntervalSince1970];
            if((now-last)>=120){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//文字编辑
- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length==0){
        [self.chatMessageView.send setEnabled:NO];
        [self.chatMessageView.send setAlpha:0.4];
    }else{
        [self.chatMessageView.send setEnabled:YES];
        [self.chatMessageView.send setAlpha:1.0];
    }
}
@end
