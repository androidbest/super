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
@implementation ChatMessageController{
    NSMutableArray *arrData;//数据储存
    NSMutableArray *arrTime;//时间保存
    NSMutableArray *arrBool;//判断高度
    ChatMsgObj *obj;
}

-(id)init{
    self=[super init];
    if(self){
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


//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if(dic){
        RespInfo *info=[AnalysisData imSend:dic];
        if(info.respCode==0){
        
            
            
        }else{
        
            
        }
    }else{
        [ToolUtils alertInfo:requestError];
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
    obj.receivereccode=@"4952000001";
    obj.receivermsisdn=@"13883832863";
    obj.content=self.chatMessageView.im_text.text;
    NSString *dateString = [formatter stringFromDate:date];
    obj.sendtime=dateString;
    obj.sendtimeNSdate=date;
    obj.receiveravatar=self.chatMessageView.chatData.headPath;
    obj.groupid=@"";
    obj.senderavatar=user.headurl;
    obj.receiveravatar=self.chatMessageView.chatData.headPath;
    obj.filepath=@"";
    [packageData imRevice:self chat:obj];
    
    
    [arrData addObject:self.chatMessageView.im_text.text];
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
     NSString *text=arrData[indexPath.row];
     UIView *v=[ToolUtils bubbleView:text from:NO];
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
    
    NSString *text=arrData[indexPath.row];
//    [CompressImage bubbleView:text imageView:cell.leftMessage];
    NSString *strBool=arrBool[indexPath.row];
    [ToolUtils bubbleView:text from:NO withPosition:60 view:cell.leftMessage];
    if([strBool isEqualToString:@"1"]){
        cell.chatTime.hidden=YES;
        CGRect rectLeftHead=cell.leftHead.frame;
        rectLeftHead.origin.y-=20;
        cell.leftHead.frame=rectLeftHead;
        
        CGRect rectLeftMessage=cell.leftMessage.frame;
        rectLeftMessage.origin.y-=20;
        cell.leftMessage.frame=rectLeftMessage;
        
    }else{
        NSDateFormatter * formatter = [NSDateFormatter new];
        [formatter setDateFormat: @"yy/MM/dd HH:mm"];
        NSString *dateString = [formatter stringFromDate:arrTime[indexPath.row]];
        cell.chatTime.text=dateString;
        cell.chatTime.hidden=NO;
    }
    return cell;
}

//时间比较
-(BOOL)compareTime:(NSIndexPath *)indexPath{
    NSInteger num=arrTime.count;
    if(num>0){
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
