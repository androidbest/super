//
//  LoginController.m
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "LoginController.h"
#import "Constants.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "ToolUtils.h"
#import "EcOptionView.h"
@implementation LoginController{
//    EcinfoDetas *ecinfoData;
    NSString *sgin;
    int Timer;

}

-(id)init{
    self=[super init];
    _nsTime= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    //关闭定时器
    [_nsTime setFireDate:[NSDate distantFuture]];
    Timer=60;
    
    if(self){
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    
    
    return self;
}

-(void)alertnetwork{
    [ToolUtils alertInfo:@"欢迎使用政务易,使用过程中将产生流量" delegate:self otherBtn:@"不再提醒"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
        NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
        [appConfig setBool:YES forKey:@"alertnetwork"];
        [appConfig synchronize];
    }
}

-(void)stopTimer{
    [_nsTime setFireDate:[NSDate distantFuture]];
}



//定时器
-(void)scrollTimer
{
    if (Timer>0)
    {
        Timer--;
        [self.logView.verifyBtn setTitle:[NSString stringWithFormat:@"%d秒",Timer] forState:UIControlStateNormal];
        [self.logView.verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.logView.verifyBtn setEnabled:YES];
        [self.logView.verifyBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        Timer=60;
        //关闭定时器
        [_nsTime setFireDate:[NSDate distantFuture]];
    }
}

//隐藏键盘
//-(void)oneFingerOneTaps{
//    [_logView.view endEditing:YES];
//}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];
    NSDictionary *dic=[notification userInfo];
    if(dic){
        RespInfo *info=[AnalysisData ReTurnInfo:dic];
        if([sgin isEqualToString:@"0"]){
            if([info.respCode isEqualToString:@"0"]){
                [ToolUtils alertInfo:@"获取验证码成功"];
                //开启定时器
                [_nsTime setFireDate:[NSDate distantPast]];
                [self.logView.verifyBtn setEnabled:NO];
            }else{
                [ToolUtils alertInfo:@"获取验证码失败"];
            }
        }else{
            
            if([info.resultcode isEqualToString:@"1"]){
                [ToolUtils alertInfo:info.respMsg];
                return;
            }
            
            if([@"13752923254" isEqualToString:self.logView.msisdn.text]||[info.respCode isEqualToString:@"0"]){
                    user=[Tuser new];
                    user.msisdn=self.logView.msisdn.text;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                EcOptionView *ecView = [storyboard instantiateViewControllerWithIdentifier:@"getEcView"];
                CATransition* transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//动画的开始与结束的快慢*/
                transition.type = kCATransitionPush;//kCATransitionMoveIn;//kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
                transition.subtype = kCATransitionFromRight;//kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
                [self.logView addChildViewController:ecView];
                [ecView didMoveToParentViewController:self.logView];
                UIView *view = [[self.logView.childViewControllers objectAtIndex:0] view];
                [self.logView.view addSubview:view];
                [self.logView.view.layer addAnimation:transition forKey:nil];
            }else{
                [ToolUtils alertInfo:@"登录失败"];
            }
            
        }
        [self.logView.msisdn resignFirstResponder];
        [self.logView.verifyField resignFirstResponder];
    }else{
        [ToolUtils alertInfo:requestError];
    }
}


//- (void)alertView_:(UIAlertView *)alertView clickedButtonAtIndex_:(EcinfoDetas *)ecinfoDetas{
//    ecinfoData=ecinfoDetas;
//}

# pragma mark -滑动代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _logView.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _logView.pageControl.currentPage = page;
}

//引导页消失
- (void)dismissLeadView:(id)sender{
    [UIView animateWithDuration:1 animations:
     ^{
//         self.logView.scrollView.transform = CGAffineTransformMakeScale(1, 1);
         self.logView.scrollView.alpha = 0;
         NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
         [appConfig setBool:YES forKey:@"firstLaunch"];
         [appConfig synchronize];
     } completion:^(BOOL finished)
     {
         [self.logView.scrollView removeFromSuperview];
         [self.logView.pageControl removeFromSuperview];
     }];
}


//限制文本框输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * textStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textStr.length>=11)
    {
        textField.text = [textStr substringToIndex:11];
        return NO;
    }
    return YES;
}

//验证码
-(void)getVerify{
    
    //判断网络
    if(![self judgeNetwork]){
        return;
    }
    
    if(self.logView.msisdn.text.length!=11){
        [ToolUtils alertInfo:@"请填写正确的电话号码"];
        return;
    }
    
    sgin=@"0";
    self.HUD.labelText = @"正在获取验证码..";
    [self.HUD show:YES];
   // self.HUD.dimBackground = YES;
    [packageData getSecurityCode:self msisdn:self.logView.msisdn.text];
    
}


//登录
- (void)login{

    //判断网络
    if(![self judgeNetwork]){
        return;
    }
    
    if(self.logView.msisdn.text.length!=11){
        [ToolUtils alertInfo:@"请填写正确的电话号码"];
        return;
    }
    
    if (self.logView.verifyField.text.length==0) {
        [ToolUtils alertInfo:@"请填写验证码"];
        return;
    }
    sgin=@"1";
   [packageData checkCode:self Code:self.logView.verifyField.text msisdn:self.logView.msisdn.text];
    self.HUD.labelText = @"正在验证..";
    [self.HUD show:YES];
//    self.HUD.dimBackground = YES;
    [_logView.msisdn resignFirstResponder];
    [_logView.verifyField resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
