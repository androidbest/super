//
//  MailDetailController.m
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MailDetailController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "RespInfo.h"
#import "MailAddressView.h"
#import "PeopelInfo.h"

@implementation MailDetailController{
    NSString *status;
    NSString *selectUser;
    
    NSString *nextShenhe;
    NSString *shenhe;
}


-(id)init{
    self=[super init];
    selectUser=[NSString new];
    if(self){
        
        if ([user.ecsystem isEqualToString:@"countrywide"]) {
            nextShenhe=@"报领导";
            shenhe=@"报审";
        }else{
            nextShenhe=@"报领导审批";
            shenhe=@"报领导审批";
        }
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

//初始化状态
-(void)initStatus{
    PublicMailDetaInfo *info=self.mailDetailView.info;
    if([info.type isEqualToString:@"0"]){
     status=@"1";
    }else{
     status=@"6";
    }
}

- (void)initWithData{
    [ConfigFile showSetAllAllGroupAddressBooksHUDWithText:@"加载中...." withView:_mailDetailView];
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];
    NSDictionary *dic=[notification userInfo];
    if(dic){
        PublicMailDetaInfo *info=self.mailDetailView.info;
        if([info.type isEqualToString:@"0"]){
            RespInfo *info=[AnalysisData processmail:dic];
            if([info.respCode isEqualToString:@"0"]){
                [self.mailDetailView.info.arr removeObjectAtIndex:self.mailDetailView.info.row];
                [self.mailDetailView.info.listview reloadData];
                [self.mailDetailView.navigationController popViewControllerAnimated:YES];
            }else{
            [ToolUtils alertInfo:@"办理失败"];
            }
        }else{
            RespInfo *info=[AnalysisData auditmail:dic];
            if([info.respCode isEqualToString:@"0"]){
                [self.mailDetailView.info.arr removeObjectAtIndex:self.mailDetailView.info.row];
                [self.mailDetailView.info.listview reloadData];
            [self.mailDetailView.navigationController popViewControllerAnimated:YES];
            }else{
            [ToolUtils alertInfo:@"审核失败"];
            }
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
}

//点击背景键盘
-(void)oneFingerOneTaps{
    [_mailDetailView.view endEditing:YES];
}

//选择状态
-(void)selectHandle{
    PublicMailDetaInfo *info=self.mailDetailView.info;
    if([info.type isEqualToString:@"0"]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"自办", @"交办",nextShenhe,nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:self.mailDetailView.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"直接审批", shenhe,nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:self.mailDetailView.view];
    
    }
}

/*选择联系人*/
- (void)brnOptionPeople{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MailAddressView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"MailAddressView"];
    [self.mailDetailView.navigationController pushViewController:detaView animated:YES];
    detaView.MailAddressDelegate=self;
}

/*选择联系人回调*/
- (void)returnDidAddress:( PeopelInfo*)deta{
    selectUser=deta.tel;
    [self.mailDetailView.brnOptionPeople setTitle:deta.Name forState:UIControlStateNormal];
}

//确定
-(void)okbtn{
//    [self.mailDetailView.MailDelegate refreshListView:0];
//    return;
   PublicMailDetaInfo *info=self.mailDetailView.info;
    //办理
    if([info.type isEqualToString:@"0"]){
        if([status isEqualToString:@"1"]){
            if((self.mailDetailView.inputContent.text.length>0)&&([self.mailDetailView.inputContent. text isEqualToString:@"请输入内容"])){
                [ToolUtils alertInfo:@"请输入内容"];
                return;
            }
        }else{
            if (selectUser.length<1) {
                [ToolUtils alertInfo:@"联系人不能为空"];
                return;
            }else{
                if((self.mailDetailView.inputContent.text.length>0)&&([self.mailDetailView.inputContent.text isEqualToString:@"请输入内容"])){
                    [ToolUtils alertInfo:@"请输入内容"];
                    return;
                }
            }
        }
        
        long long intNum= (long long)[[NSDate date] timeIntervalSince1970]+7*24*3600;
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:intNum/1000.0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString * strTime = [dateFormatter stringFromDate:date];
        
        
        self.HUD.labelText = @"正在办理中..";
        [self.HUD show:YES];
        self.HUD.dimBackground = YES;
        [packageData processmail:self LogID:self.mailDetailView.info.infoid MsgType:self.mailDetailView.info.msgtype contentType:self.mailDetailView.info.contetnType BF:status NextProcessTel:selectUser limitTime:strTime content:self.mailDetailView.inputContent.text pageName:selectUser];
        
    }else{
        //审核
        if (selectUser.length<1) {
            [ToolUtils alertInfo:@"联系人不能为空"];
            return;
        }
        if ((self.mailDetailView.inputContent.text.length>0)&&([self.mailDetailView.inputContent.text isEqualToString:@"请输入内容"])) {
            [ToolUtils alertInfo:@"请输入内容"];
            return;
        }
        
        
        self.HUD.labelText = @"正在审核中..";
        [self.HUD show:YES];
        self.HUD.dimBackground = YES;
        [packageData auditmail:self LogID:self.mailDetailView.info.infoid BF:status nextProcessTel:selectUser Recontent:self.mailDetailView.inputContent.text];
        
    }
    
}

#pragma mark -弹出键盘通知
-(void)inputKeyboardWillShow:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect rect=self.mailDetailView.view.frame;
        rect.origin.y=-keyBoardFrame.size.height;
        self.mailDetailView.view.frame=rect;
    }];
}

#pragma mark -取消键盘通知
-(void)inputKeyboardWillHide:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect rect=self.mailDetailView.view.frame;
        rect.origin.y=0;
        self.mailDetailView.view.frame=rect;
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PublicMailDetaInfo *info=self.mailDetailView.info;
    if([info.type isEqualToString:@"0"]){
    
        if (buttonIndex==0) {
//            [self.mailDetailView.selecthandle setTitle:@"自办" forState:UIControlStateNormal];
            status=@"1";
            [self.mailDetailView.brnOptionPeople setEnabled:NO];
            [self.mailDetailView.selecthandle setTitle:@"自办" forState:UIControlStateNormal];
            [self.mailDetailView.brnOptionPeople setTitle:@"" forState:UIControlStateNormal];
            selectUser=@"";
        }
        else if (buttonIndex==1) {
//            [self.mailDetailView.selecthandle setTitle:@"交办" forState:UIControlStateNormal];
            status=@"2";
            [self.mailDetailView.brnOptionPeople setEnabled:YES];
            [self.mailDetailView.selecthandle setTitle:@"交办" forState:UIControlStateNormal];
            [self.mailDetailView.brnOptionPeople setTitle:@"请选择联系人" forState:UIControlStateNormal];
            selectUser=@"";
        }
        else if (buttonIndex==2) {
//            [self.mailDetailView.selecthandle setTitle:@"报领导审批" forState:UIControlStateNormal];
            status=@"5";
            [self.mailDetailView.brnOptionPeople setEnabled:YES];
            [self.mailDetailView.selecthandle setTitle:nextShenhe forState:UIControlStateNormal];
            [self.mailDetailView.brnOptionPeople setTitle:@"请选择联系人" forState:UIControlStateNormal];
            selectUser=@"";
        }
    }else{
        if (buttonIndex==0) {
//            [self.mailDetailView.selecthandle setTitle:@"直接审批" forState:UIControlStateNormal];
            status=@"6";
            [self.mailDetailView.selecthandle setTitle:@"直接审批" forState:UIControlStateNormal];
        }else if (buttonIndex==1) {
//            [self.mailDetailView.selecthandle setTitle:@"报领导审批" forState:UIControlStateNormal];
            status=@"5";
            [self.mailDetailView.selecthandle setTitle:shenhe forState:UIControlStateNormal];
        }
    }
}

//tableview提示语
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.mailDetailView.inputContent])
    {
        if ([textView.text isEqualToString:@"请输入内容"])
        {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.mailDetailView.inputContent])
    {
        if (textView.text.length==0)
        {
            textView.text = @"请输入内容";
            textView.textColor = [UIColor lightGrayColor];
        }
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
