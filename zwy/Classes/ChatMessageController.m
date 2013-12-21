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
    [arrTime addObject:[NSDate date]];
    self.chatMessageView.im_text.text=nil;
    [self.chatMessageView.tableview reloadData];
    NSInteger rows = [self.chatMessageView.tableview numberOfRowsInSection:0];
    if(rows > 0) {
        [self.chatMessageView.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
    ChatMsgObj *obj=[ChatMsgObj new];
    obj.
    
    [packageData imSend:self chat:nil];
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
    cell.chatTime.text=[NSDateFormatter localizedStringFromDate:arrTime[indexPath.row]
                                                      dateStyle:kCFDateFormatterMediumStyle
                                                      timeStyle:NSDateFormatterShortStyle];
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

@end
