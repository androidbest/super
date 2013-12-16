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
    /*提交等待*/
    self.HUD =[[MBProgressHUD alloc] initWithView:self.comDetaView.view];
    self.HUD.labelText=@"正在发送..";
    [self.comDetaView.view addSubview:self.HUD];
    [self.HUD show:YES];
}

#pragma mark - 解析数据
- (void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    RespInfo * info =[AnalysisData ReTurnInfo:dic];
    if ([info.respCode isEqualToString:@"0"]) {
        self.HUD.labelText = @"发送成功";
    }else{
        self.HUD.labelText = @"发送失败";
    }
    self.HUD.mode = MBProgressHUDModeCustomView;
    [self.HUD hide:YES afterDelay:1];
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
