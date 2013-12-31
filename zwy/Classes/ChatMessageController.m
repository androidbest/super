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
#import "EditingChatPeoplesview.h"
#import "VoiceGestureRecognizer.h"

@implementation ChatMessageController{
    NSMutableArray *arrData;//数据储存
    NSMutableArray *arrTime;//时间保存
    NSMutableArray *arrBool;//判断高度
    NSInteger num;
    ChatMsgObj *obj;
    NSMutableArray *chatMsgObjArr;//群组发送者临时的数组
    NSString *grouid;
    NSString *originWav;
    NSString *chatMessageID;
    NSString *convertAmr;        //转换后的amr文件名
    NSString *convertWav;        //amr转wav的文件名
    NSString *voicetime;         //语音秒数
    NSString *amrSavePath;       //语音保存地址
    NSString *wavSavePath;       //语音保存地址
    AVAudioPlayer *player;
    NSData *voicedata;           //上传的数据流
    BOOL isSend;                 //发送状态
    UIActivityIndicatorView *activityIndicatorView;
    BOOL isPut;                  //入库状态

}

-(id)init{
    self=[super init];
    if(self){
        num=0;
        arrData=[NSMutableArray new];
        arrTime=[NSMutableArray new];
        arrBool=[NSMutableArray new];
        chatMsgObjArr=[NSMutableArray new];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleDataSelf:)
                                                    name:xmlNotifInfo
                                         object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(uploadVoice:)
                                                    name:@"uploadVoice"
                                                  object:self];
        player=[AVAudioPlayer new];
        activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
        [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];

    }
    return self;
}

//上传结果
-(void)uploadVoice:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if(dic){
        obj.filepath=dic[@"fileurl"];
        if(chatMsgObjArr.count>0){
            for(ChatMsgObj *msgobj in chatMsgObjArr){
               [packageData imSend:self chat:msgobj];
            }
        }else{
             [packageData imSend:self chat:obj];
        }
    }else{
    
    
    }
}


//初始化数据
-(void)initDatatoData{
    PeopelInfo *info=self.chatMessageView.chatData;
    NSString *temp=@"";
    
    //群组处理
    if(info.imGroupid&&![info.imGroupid isEqualToString:@"null"]&&![info.imGroupid isEqualToString:@""]&&![info.imGroupid isEqualToString:@"(null)"]){
        grouid=info.imGroupid;
        NSArray * msisdn =[info.tel componentsSeparatedByString:@","];
        NSArray * name =[info.Name componentsSeparatedByString:@","];
        NSArray * headPath =[info.headPath componentsSeparatedByString:@","];
        for(int i=0;i<msisdn.count;i++){
            PeopelInfo *peopel=[PeopelInfo new];
            peopel.Name=name[i];
            peopel.tel=msisdn[i];
            peopel.headPath=headPath[i];
            peopel.eccode=user.eccode;
            [self.chatMessageView.arrPeoples addObject:peopel];
        }
        temp=info.imGroupid;
    }else{
        temp=info.tel;
    }
    //读取聊天记录
    chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,temp,info.eccode];

    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    chatMessageID = [chatMessageID stringByTrimmingCharactersInSet:set];

    //
    EX_chatMessageID=chatMessageID;
    //        [arrData addObjectsFromArray:];
    NSArray *tempArr=[[CoreDataManageContext newInstance] getUserChatMessageWithChatMessageID:chatMessageID FetchOffset:num FetchLimit:10];
    
    for(ChatEntity *chat in tempArr){
        ChatMsgObj *chatObj=[ChatMsgObj new];
        chatObj.chattype=chat.chat_msgtype;
        chatObj.sendeccode=user.eccode;
        chatObj.sendmsisdn=user.msisdn;
        chatObj.receivereccode=chat.chat_sessionObjct.session_receivereccode;
        chatObj.receivermsisdn=chat.chat_sessionObjct.session_receivermsisdn;
        chatObj.receiveravatar=chat.chat_sessionObjct.session_receiveravatar;
        chatObj.receivername=chat.chat_sessionObjct.session_receivername;
        chatObj.content=chat.chat_content;
        chatObj.sendtime=[ToolUtils NSDateToNSString:chat.chat_times format:@"yy/MM/dd HH:mm"];
        chatObj.groupid=chat.chat_sessionObjct.session_groupuuid;
        chatObj.senderavatar=user.headurl;
        chatObj.filepath=chat.chat_voiceurl;
        chatObj.status=chat.chat_status;
        chatObj.voicetime=chat.chat_voicetime;
        chatObj.gsendermsisdn=chat.chat_gsendermsisdn;
        chatObj.gsenderheadurl=chat.chat_gsenderheadurl;
        [arrData addObject:chatObj];
        [arrTime addObject:chat.chat_times];
    }
}


#pragma mark -接收聊天新消息，更新表单
/*
 *通告中心为"HomeController"
 */
- (void)getMessage:(NSNotification *)notification{
    [arrData removeAllObjects];
    [arrTime removeAllObjects];
    
    if(!chatMessageID||[chatMessageID isEqualToString:@""]){
      chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,grouid,user.eccode];
    }
    
    NSArray *tempArr=[[CoreDataManageContext newInstance] getUserChatMessageWithChatMessageID:chatMessageID FetchOffset:num FetchLimit:10];
    
    for(ChatEntity *chat in tempArr){
        ChatMsgObj *chatObj=[ChatMsgObj new];
        chatObj.chattype=chat.chat_msgtype;
        chatObj.sendeccode=user.eccode;
        chatObj.sendmsisdn=user.msisdn;
        chatObj.receivereccode=chat.chat_sessionObjct.session_receivereccode;
        chatObj.receivermsisdn=chat.chat_sessionObjct.session_receivermsisdn;
        chatObj.receiveravatar=chat.chat_sessionObjct.session_receiveravatar;
        chatObj.receivername=chat.chat_sessionObjct.session_receivername;
        chatObj.content=chat.chat_content;
        chatObj.sendtime=[ToolUtils NSDateToNSString:chat.chat_times format:@"yy/MM/dd HH:mm"];
        chatObj.groupid=chat.chat_sessionObjct.session_groupuuid;
        chatObj.senderavatar=user.headurl;
        chatObj.filepath=chat.chat_voiceurl;
        chatObj.status=chat.chat_status;
        chatObj.gsendermsisdn=chat.chat_gsendermsisdn;
        chatObj.gsenderheadurl=chat.chat_gsenderheadurl;
        [arrData addObject:chatObj];
        [arrTime addObject:chat.chat_times];
    }
    
    [self.chatMessageView.tableview reloadData];
    NSInteger rows = [self.chatMessageView.tableview numberOfRowsInSection:0];
    if(rows > 0) {
        [self.chatMessageView.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                              atScrollPosition:UITableViewScrollPositionBottom
                                                      animated:YES];
    }
}

//处理网络数据
-(void)handleDataSelf:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if(dic){
        RespInfo *info=[AnalysisData imSend:dic];
        if([info.respCode isEqualToString:@"0"]){
            [activityIndicatorView stopAnimating];
            
           //发送成功,入本地数据库
            if(chatMsgObjArr.count>0){
            if(!isPut){
            [[CoreDataManageContext newInstance] setChatInfo:obj status:@"0" isChek:YES gid:grouid arr:chatMsgObjArr];
                isPut=YES;
            }
            }else{
            [[CoreDataManageContext newInstance] setChatInfo:obj status:@"0" isChek:YES gid:grouid arr:chatMsgObjArr];
            }
        }else{
        //发送失败
            
        }
    }else{
        //发送失败
    }
}

/*************************************/
//编辑群组人员
- (void)rightDown
{
    [self.chatMessageView.im_text resignFirstResponder];
    [self.chatMessageView performSegueWithIdentifier:@"ChatMessageToEditingPeoplesView" sender:nil];
}
- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ChatMessageToEditingPeoplesView"]){
        EditingChatPeoplesview *editingView =segue.destinationViewController;
        editingView.chatView=_chatMessageView;
        editingView.chatMessageID=chatMessageID;
    }
}
/*************************************/


-(void)sendMessage{
    [chatMsgObjArr removeAllObjects];
    NSDate *date=[NSDate date];
//    NSString *groupid=[ToolUtils uuid];
    if(self.chatMessageView.arrPeoples.count>0){
        
//        NSString *temp=@"";
//        for(PeopelInfo *info in self.chatMessageView.arrPeoples){
//         temp=[NSString stringWithFormat:@"%@,",[temp stringByAppendingString:info.Name]];
//        }
//        temp=[temp substringToIndex:temp.length-1];
        
        if(!(grouid&&![grouid isEqualToString:@"null"]&&![grouid isEqualToString:@""])){
           grouid=[ToolUtils uuid];
        }
        
        //如果是群组，是多人接收
        for(PeopelInfo *info in self.chatMessageView.arrPeoples){
            if(self.chatMessageView.voicepress.tag==0){
                obj=[ChatMsgObj new];
                obj.chattype=@"0";
                obj.sendeccode=user.eccode;
                obj.sendmsisdn=user.msisdn;
                obj.receivereccode=info.eccode;
                obj.receivermsisdn=info.tel;
                obj.receiveravatar=info.headPath;
                obj.receivername=info.Name;
                obj.content=self.chatMessageView.im_text.text;
                obj.sendtime=[ToolUtils NSDateToNSString:date format:@"yy/MM/dd HH:mm"];
                obj.sendtimeNSdate=date;
                obj.groupid=grouid;
                obj.senderavatar=user.headurl;
                obj.filepath=@"";
                obj.status=@"0";
                [packageData imSend:self chat:obj];
                
            }else{
                obj=[ChatMsgObj new];
                obj.chattype=@"1";
                obj.sendeccode=user.eccode;
                obj.sendmsisdn=user.msisdn;
                obj.receivereccode=info.eccode;
                obj.receivermsisdn=info.tel;
                obj.receiveravatar=info.headPath;
                obj.receivername=info.Name;
                obj.content=@"语音";
                obj.sendtime=[ToolUtils NSDateToNSString:date format:@"yy/MM/dd HH:mm"];
                obj.sendtimeNSdate=date;
                obj.groupid=grouid;
                obj.senderavatar=user.headurl;
                obj.filepath=amrSavePath;
                obj.status=@"0";
                obj.voicetime=voicetime;
            }
            [chatMsgObjArr addObject:obj];
        }
        
        if(self.chatMessageView.voicepress.tag==0){
            self.chatMessageView.im_text.text=nil;
            [self.chatMessageView.send setEnabled:NO];
            [self.chatMessageView.send setAlpha:0.4];
            
        }
        
        if([obj.chattype isEqualToString:@"1"]){
           [packageData imUploadUrl:self type:@"1" data:voicedata selType:@"uploadVoice" uuid:@""];
        }
    }else{
        //单个，单人接收
        if(self.chatMessageView.voicepress.tag==0){
            obj=[ChatMsgObj new];
            obj.chattype=@"0";
            obj.sendeccode=user.eccode;
            obj.sendmsisdn=user.msisdn;
            obj.receivereccode=self.chatMessageView.chatData.eccode;
            obj.receivermsisdn=self.chatMessageView.chatData.tel;
            obj.receiveravatar=self.chatMessageView.chatData.headPath;
            obj.receivername=self.chatMessageView.chatData.Name;
            obj.content=self.chatMessageView.im_text.text;
            obj.sendtime=[ToolUtils NSDateToNSString:date format:@"yy/MM/dd HH:mm"];
            obj.sendtimeNSdate=date;
            obj.senderavatar=user.headurl;
            obj.filepath=@"";
            obj.status=@"0";
            
            self.chatMessageView.im_text.text=nil;
            [self.chatMessageView.send setEnabled:NO];
            [self.chatMessageView.send setAlpha:0.4];
            [packageData imSend:self chat:obj];
        }else{
            obj=[ChatMsgObj new];
            obj.chattype=@"1";
            obj.sendeccode=user.eccode;
            obj.sendmsisdn=user.msisdn;
            obj.receivereccode=self.chatMessageView.chatData.eccode;
            obj.receivermsisdn=self.chatMessageView.chatData.tel;
            obj.receiveravatar=self.chatMessageView.chatData.headPath;
            obj.receivername=self.chatMessageView.chatData.Name;
            obj.content=@"语音";
            obj.sendtime=[ToolUtils NSDateToNSString:date format:@"yy/MM/dd HH:mm"];
            obj.sendtimeNSdate=date;
            obj.senderavatar=user.headurl;
            obj.filepath=@"";
            obj.status=@"0";
            obj.voicetime=voicetime;
            [packageData imUploadUrl:self type:@"1" data:voicedata selType:@"uploadVoice" uuid:@""];
        }
       
    }
    
    [arrData addObject:obj];
    [arrTime addObject: date];
    [arrBool removeAllObjects];
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self.chatMessageView.tableview beginUpdates];
//    [self.chatMessageView.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    [self.chatMessageView.tableview endUpdates];
    isSend=YES;
    isPut=NO;
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
    v=[ToolUtils bubbleView:msgObj.content from:YES selfType:msgObj.chattype];
    }else{
    v=[ToolUtils bubbleView:msgObj.content from:NO selfType:msgObj.chattype];
    }
    if([self compareTime:indexPath]){
        leng=v.frame.size.height+30;
        [arrBool addObject:@"0"];
    }else{
        leng=v.frame.size.height+10;
        [arrBool addObject:@"1"];
    }
    return leng;
    
//    return 55;
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
//    cell.leftMessage.frame=CGRectMake(60, 10, 200, 50);
//    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    view.image=[UIImage imageNamed:@"chat_lefttext"];
//    [cell.leftMessage addSubview:view];
    ChatMsgObj *msgObj=arrData[indexPath.row];
    NSString *strBool=arrBool[indexPath.row];
    if([msgObj.status isEqualToString:@"0"]){
        cell.leftHead.hidden=YES;
        cell.rightHead.hidden=NO;
        [cell.rightHead addTarget:self action:@selector(rightPushDetail:) forControlEvents:UIControlEventTouchUpInside];
        
    [HTTPRequest imageWithURL:user.headurl imageView:cell.rightHead placeUIButtonImage:[UIImage imageNamed:@"default_avatar"]];
    [ToolUtils bubbleView:msgObj.content from:YES withPosition:60 view:cell.rightMessage selfType:msgObj.chattype];
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
        
        //语音点击事件
        if([msgObj.chattype isEqualToString:@"1"]){
            [HTTPRequest voiceWithURL:msgObj.filepath];
            [cell.rightMessage addTarget:self action:@selector(UesrClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.rightMessage.voiceurl=msgObj.filepath;
            cell.voiceTimes.text=msgObj.voicetime;
            cell.voiceTimes.frame=CGRectMake(cell.rightMessage.frame.origin.x-20, cell.rightMessage.center.y,20,10);
        }else{
            cell.voiceTimes.hidden=YES;
        }
        
        //加指示灯
        if(isSend){
            if((arrData.count-1)==indexPath.row){
                activityIndicatorView.center=CGPointMake(cell.rightMessage.frame.origin.x-20,cell.rightMessage.center.y-5);
                NSLog(@"%f",cell.frame.size.height/2);
                
                [cell addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                cell.rightMessage.voiceurl=wavSavePath;
                cell.voiceTimes.text=voicetime;
                isSend=NO;
            }
        }
        
    }else{
        cell.rightHead.hidden=YES;
        cell.leftHead.hidden=NO;
        NSString *url=@"";
        if(msgObj.groupid&&![msgObj.groupid isEqualToString:@"null"]&&![msgObj.groupid isEqualToString:@""]){
        cell.leftHead.tag=indexPath.row;
            url=msgObj.gsenderheadurl;
        }else{
        cell.leftHead.tag=indexPath.row;
            url=msgObj.receiveravatar;
        }
        [HTTPRequest imageWithURL:url imageView:cell.leftHead placeUIButtonImage:[UIImage imageNamed:@"default_avatar"]];
        [cell.leftHead addTarget:self action:@selector(leftPushDetail:) forControlEvents:UIControlEventTouchUpInside];
        [ToolUtils bubbleView:msgObj.content from:NO withPosition:60 view:cell.leftMessage selfType:msgObj.chattype];
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
        
        //语音点击事件
        if([msgObj.chattype isEqualToString:@"1"]){
            [HTTPRequest voiceWithURL:msgObj.filepath];
            [cell.leftMessage addTarget:self action:@selector(UesrClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.leftMessage.voiceurl=msgObj.filepath;
            cell.voiceTimes.text=msgObj.voicetime;
            cell.voiceTimes.frame=CGRectMake(cell.rightMessage.frame.origin.x-20, cell.rightMessage.frame.origin.y,10,10);
        }else{
            cell.voiceTimes.hidden=YES;
        }
    }
        return cell;
}

//播放音频
-(void)UesrClicked:(UIButton*)btn{
    
    
    
    NSString *voiceurl=((VoiceBtn *)btn).voiceurl;
    if (!voiceurl)return;
    NSString * PicPath =[[voiceurl componentsSeparatedByString:@"/"] lastObject];
    NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    NSData * data = [NSData dataWithContentsOfFile:strpaths];
    if (!data) return;
    PicPath=[PicPath stringByDeletingPathExtension];
    strpaths =[NSString stringWithFormat:@"%@/%@/%@.wav",DocumentsDirectory,MESSGEFILEPATH,PicPath];
    data = [NSData dataWithContentsOfFile:strpaths];
    if(data){
        [self audioPlay:PicPath];
    }else{
        [self amrTowav:PicPath];
    data = [NSData dataWithContentsOfFile:strpaths];
    if(data){
    [self audioPlay:PicPath];
    }
//      [[NSFileManager defaultManager] fileExistsAtPath:strSavePath];  
    }
}

//点击左边头像
-(void)leftPushDetail:(UIButton *)btn{
    NSMutableArray  *arr = [ConfigFile setEcNumberInfo];
    ChatMsgObj *msgobj=arrData[btn.tag];
    NSString *msisdn=@"";
    if(msgobj.groupid&&![msgobj.groupid isEqualToString:@"null"]&&![msgobj.groupid isEqualToString:@""]){
        msisdn=msgobj.gsendermsisdn;
    }else{
        msisdn=msgobj.receivermsisdn;
    }
    NSString *strSearchbar =[NSString stringWithFormat:@"SELF.tel CONTAINS '%@'",msisdn];
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

//点击右边头像
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
        [self.chatMessageView.im_text resignFirstResponder];
        btn.tag=1;
    }else{
        self.chatMessageView.send.hidden=NO;
        self.chatMessageView.im_text.hidden=NO;
        self.chatMessageView.voiceSend.hidden=YES;
       [self.chatMessageView.voicepress setBackgroundImage:[UIImage imageNamed:@"voice_press"] forState:UIControlStateNormal];
        btn.tag=0;
    }
    
}

-(void)recordBtnLongPressed:(UITapGestureRecognizer*)longPressedRecognizer{
   NSLog(@"ok");
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
         NSLog(@"kaishi");
        //设置文件名
        originWav = [ToolUtils uuid];
        //开始录音
        [self.chatMessageView.recorderVC beginRecordByFileName:originWav];
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getChatVideo" object:nil userInfo:nil];//(ZWY改动)
        NSLog(@"结束");
    }
}

#pragma mark - VoiceRecorderBaseVC Delegate Methods
//录音完成回调，返回文件路径和文件名
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{
    NSLog(@"录音完成，文件路径:%@",_filePath);
    wavSavePath=_filePath;
    [self getVoicetime:_filePath fileName:_fileName convertTime:0 label:nil];
    [self wavToamr];
    [self sendMessage];
}

//wav转amr
-(void)wavToamr{
    if (originWav.length > 0){
        //转格式
        amrSavePath=[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"amr"];
        [VoiceConverter wavToAmr:[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"wav"] amrSavePath:amrSavePath];
        voicedata=[NSData dataWithContentsOfFile:amrSavePath];
    }
}

//获取语音秒数
- (void)getVoicetime:(NSString*)_filePath fileName:(NSString*)_fileName convertTime:(NSTimeInterval)_convertTime label:(UILabel*)_label{
    NSRange range = [_filePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:_filePath] error:nil];
        voicetime=[NSString stringWithFormat:@"%d",(int)play.duration];
    }
}

//amr转wav
-(void)amrTowav:(NSString *)_fileName{
    if (_fileName.length > 0){
        //转格式
        [VoiceConverter amrToWav:[VoiceRecorderBaseVC getPathByFileName:_fileName ofType:@"amr"] wavSavePath:[VoiceRecorderBaseVC getPathByFileName:_fileName ofType:@"wav"]];
    }
}

//播放音频
-(void)audioPlay:(NSString *)_fileName{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    player = [player initWithContentsOfURL:[NSURL URLWithString:[VoiceRecorderBaseVC getPathByFileName:_fileName ofType:@"wav"]] error:nil];
    
    [player play];
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
//    ChatMessageCell *cell=(ChatMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%@",cell.rightMessage.gestureRecognizers);
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
