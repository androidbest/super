//
//  CommentDetaController.m
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "CommentDetaController.h"

@implementation CommentDetaController


- (id)init{
    self =[super init];
    if (self) {
        //返回消息通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}

#pragma mark -按钮实现
//返回
- (void)btnBack{
    [self.comDetaView dismissViewControllerAnimated:YES completion:nil];
}

//发送
- (void)btnSend{
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970];
    NSString *strTime =[NSString stringWithFormat:@"%f",time];
    strTime=[[strTime componentsSeparatedByString:@"."] firstObject];
    if (_comDetaView.textContent.text.length<=0||[_comDetaView.textContent.text isEqualToString:@"请输入内容"]) {
        [ToolUtils alertInfo:@"内容不能为空"];
        return;
    }
    
    [_comDetaView.textContent resignFirstResponder];
    [packageData sendNewsComment:self content:_comDetaView.textContent.text discuesstime:strTime newsID:_comDetaView.InfoNewsDeta.newsID];
    
    /*提交等待*/
    if (!self.HUD){
        self.HUD =[[MBProgressHUD alloc] initWithView:self.comDetaView.view];
        [self.comDetaView.view addSubview:self.HUD];
    }
    self.HUD.labelText=@"正在发送..";
    [self.HUD show:YES];
}

#pragma mark - 解析数据
- (void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    RespInfo * info =[AnalysisData ReTurnInfo:dic];
    if ([info.respCode isEqualToString:@"0"]) {
        self.HUD.labelText = @"评论成功";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
        [self.comDetaView.commentDetaViewDelegate updateToCommentListView];
        [self performSelector:@selector(dismissCommendSendView) withObject:self afterDelay:1.5];
    }else{
        self.HUD.labelText = @"评论失败";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1];
    }
   
}

- (void)dismissCommendSendView{
    [self.comDetaView dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  textiew提示语
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.comDetaView.textContent])
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
    if ([textView isEqual:self.comDetaView.textContent])
    {
        if (textView.text.length==0)
        {
            textView.text = @"请输入内容";
            textView.textColor = [UIColor lightGrayColor];
        }
    }
    return YES;
}

@end
