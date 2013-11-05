//
//  AlterPasswordController.m
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AlterPasswordController.h"

@implementation AlterPasswordController



- (id)init{
    self =[super init];
    if (self) {
        //注册通知
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
    UIImageView *imageView;
    UIImage *image;
    
    RespInfo * info =[AnalysisData ReTurnInfo:dic];
    if ([info.respCode isEqualToString:@"0"]) {
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"修改成功";
        [self performSelector:@selector(backReturnView) withObject:self afterDelay:1.0];
    }else{
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"原密码输入错误";
    }
    imageView.image=image;
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
    [self.HUD hide:YES afterDelay:1];
    
}

- (void)backReturnView{
[self.alterView.navigationController popViewControllerAnimated:YES];
}

- (void)btnOK{
    if (![_alterView.textNewPw.text isEqualToString:_alterView.textLastPw.text]) {
        [ToolUtils alertInfo:@"两次密码输入不一致"];
        return;
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.alterView.view];
	[self.alterView.navigationController.view addSubview:self.HUD];
	self.HUD.labelText = @"正在提交";
    [self.HUD show:YES];
    [packageData AlterPassword:self beforePassword:_alterView.textBeforePw.text NewPassword:_alterView.textNewPw.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length<20) {
        return YES;
    }else{
        return NO;
    }
}
@end
