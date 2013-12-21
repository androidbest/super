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
@implementation ChatMessageController{
    NSMutableArray *arrData;
    NSMutableArray *arrTime;
}

-(id)init{
    self=[super init];
    if(self){
        arrData=[NSMutableArray new];
        arrTime=[NSMutableArray new];
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
       
        
        
        
        
        
    }else{
        [ToolUtils alertInfo:requestError];
    }
}

-(void)sendMessage{
    [arrData addObject:self.chatMessageView.im_text.text];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat: @"yy/MM/dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    [arrTime addObject:dateString];
    
    ChatMsgObj *obj=[ChatMsgObj new];
    obj.chattype=@"0";
    obj.sendeccode=user.eccode;
    obj.sendmsisdn=user.msisdn;
    obj.receivereccode=self.chatMessageView.chatData.eccode;
    obj.receivermsisdn=self.chatMessageView.chatData.tel;
    obj.content=self.chatMessageView.im_text.text;
    obj.sendtime=dateString;
    obj.receiveravatar=self.chatMessageView.chatData.headPath;
    obj.groupid=@"";
    obj.senderavatar=@"";
    obj.receiveravatar=@"";
    obj.filepath=@"";
    [packageData imSend:self chat:obj];
    self.chatMessageView.im_text.text=nil;
    
    
    
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
//    if([self compareTime:indexPath]){
//        return 65;
//    }else{
//        return 55;
//    }
    
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strCell =@"chatmessage";
    ChatMessageCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:strCell];
    }
    NSString *text=arrData[indexPath.row];
    cell.chatTime.text=arrTime[indexPath.row];
//    [CompressImage bubbleView:text imageView:cell.leftMessage];
//    [ToolUtils bubbleView:text from:NO withPosition:60 view:cell.leftMessage];
    return cell;
}

//时间比较
-(BOOL)compareTime:(NSIndexPath *)indexPath{
    NSInteger num=arrTime.count;
    if(num>0){
        if(indexPath.row==0){
            return YES;
        }else{
            int last=[(NSDate *)arrTime[indexPath.row] timeIntervalSince1970];
            int now=[(NSDate *)arrTime[indexPath.row] timeIntervalSince1970];
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
