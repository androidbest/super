//
//  MoreController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#define WiressSDKDemoAppKey     @"801213517"
#define WiressSDKDemoAppSecret  @"9819935c0ad171df934d0ffb340a3c2d"
#define REDIRECTURI             @"http://www.ying7wang7.com"

#import "MoreController.h"
#import "ToolUtils.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ActionSheetWeibo.h"
#import "SendMessageToWeiboViewController.h"
@implementation MoreController{
    NSArray *allsec;
    NSArray *firstsec;
    NSArray *second;
    NSArray *third;
    NSArray *allimage;
    NSArray *image1;
    NSArray *image2;
    NSArray *image3;
    NSString *str;
    NSArray *tempArray;
    NSString *trackViewURL;
    NSString *isnetwork;
}


-(id)init{
    self=[super init];
    if(self){
        str=@"分享政务易地址https://appsto.re/cn/T04KM.i";
        isnetwork=@"0";
        
        firstsec=@[@"账号管理"];
//        firstsec=@[@"账号管理",@"密码修改"];
        second=@[@"检查更新",@"修改密码"];
//        third=@[@"帮助",@"关于"];
        third=@[@"下载分享",@"帮助",@"关于"];
        allsec=@[firstsec,second,third];
        
//        image1=@[[UIImage imageNamed:@"more_accounts_image"],[UIImage imageNamed:@"more_update_pwd_img"]];
        image1=@[[UIImage imageNamed:@"more_accounts_image"]];
        image2=@[[UIImage imageNamed:@"check_update_img"],[UIImage imageNamed:@"more_update_pwd_img"]];
        image3=@[[UIImage imageNamed:@"more_download_image"],[UIImage imageNamed:@"more_help_img"],[UIImage imageNamed:@"more_about_img"]];
        allimage=@[image1,image2,image3];
        
        if(self.wbapi == nil)
        {
            self.wbapi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey
                                               andSecret:WiressSDKDemoAppSecret
                                          andRedirectUri:REDIRECTURI];
        }
        
    }
    return self;
}


//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//对应的section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr =[allsec objectAtIndex:section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        UIView* header =[UIView new];
        header.alpha=0;
        return header;
    }
        
        else
        {
            return nil;
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0){
        switch (indexPath.row) {
            case 0:{
                [self initBackBarButtonItem:self.moreView];
                self.moreView.tabBarController.tabBar.hidden=YES;
               [self.moreView performSegueWithIdentifier:@"moretoaccount" sender:self.moreView];
            }
                break;
        }
    }else if(indexPath.section==1){
        switch (indexPath.row) {
            case 0:{
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                CFShow((__bridge CFTypeRef)(infoDic));
                
                NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.moreView.view];
                [self.moreView.view addSubview:HUD];
                
                //设置对话框文字
                HUD.labelText = @"检查更新中..";
                
                //显示对话框
                [HUD showAnimated:YES whileExecutingBlock:^{
                    //对话框显示时需要执行的操作
                    if ([ToolUtils isExistenceNetwork]) {
                        isnetwork=@"0";
                        [self onCheckVersion];
                    }else{
                        isnetwork=@"1";
                    }
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    
                    if([isnetwork isEqualToString:@"1"]){
                        [ToolUtils alertInfo:@"网络不可用，请检查网络"];
                    }else if([isnetwork isEqualToString:@"2"]){
                        [ToolUtils alertInfo:@"服务器异常"];
                    }else{
                        NSString *lastVersion=nil;
                        NSMutableDictionary *releaseInfo=nil;
                        
                        if (tempArray.count>0) {
                            releaseInfo = tempArray[0];
                            lastVersion = releaseInfo[@"version"];
                        }
                        
                        if(lastVersion!=nil){
                            if (![lastVersion isEqualToString:appVersion]) {
                                trackViewURL = releaseInfo[@"trackViewUrl"];
                                [ToolUtils alertInfo:@"有新的版本更新,是否前往更新" delegate:self otherBtn:@"更新"];
                                
                                
//                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
//                                [alert show];
                                
                            }else{
//                                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                [alert show];
                                [ToolUtils alertInfo:@"已是最新版"];
                                
                            }
                            
                        }else{
//                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alert show];
                            [ToolUtils alertInfo:@"已是最新版"];
                        }
                    }
                }];
            }
                break;
            case 1:{
            [self initBackBarButtonItem:self.moreView];
           [self.moreView performSegueWithIdentifier:@"MoreToAlterPw" sender:self.moreView];
            }
                break;
    }
    }else if(indexPath.section==2){
        switch (indexPath.row) {
            case 0:{
                ActionSheetWeibo * sheet =[[ActionSheetWeibo alloc] initWithViewdelegate:self WithSheetTitle:@"分享"];
                [sheet showInView:self.moreView.view];
            }
                break;
            case 1:{
                [self initBackBarButtonItem:self.moreView];
                self.moreView.tabBarController.tabBar.hidden=YES;
                [self.moreView performSegueWithIdentifier:@"moretohelp" sender:self.moreView];
            }
                break;
            case 2:{
                [self initBackBarButtonItem:self.moreView];
                self.moreView.tabBarController.tabBar.hidden=YES;
                [self.moreView performSegueWithIdentifier:@"moretoabout" sender:self.moreView];
            }
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:trackViewURL]];
    }
}

//检查最新版本
-(void)onCheckVersion
{
    NSString *URL = @"http://itunes.apple.com/lookup?id=647204141";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:25];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if(recervedData){
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:recervedData options:kNilOptions error:nil];
        tempArray =root[@"results"];
    }else{
    isnetwork=@"2";
    }
}


//选择分享方式
- (void)actionSheetIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [self sendSMS:str recipientList:nil];
            break;
            
        case 1:
        {
            if([WXApi openWXApp]) [self sendWeiXinTextContent:str];
            else [ToolUtils alertInfo:@"请安装微信"];
        }
            break;
            
        case 2:{
//            SendMessageToWeiboViewController *weibo1=[SendMessageToWeiboViewController new];
//            [weibo1 shareButtonPressed];
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            
            [WeiboSDK sendRequest:request];
            
        }
            break;
            
        case 3:{
            //腾讯微博
            [self.wbapi requestWithParams:[self packageData] apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
        }
            
            break;
            
        default:
            
            break;
    }
}

//新浪微博数据
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = str;
    return message;
}

//发送微信
- (void) sendWeiXinTextContent:(NSString *)content
{
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

//发送短信
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self.moreView presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark -信息发送回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
//    if (result == MessageComposeResultCancelled)
//        NSLog(@"Message cancelled");
//    else if (result == MessageComposeResultSent)
//        NSLog(@"Message sent");
//    else
//        NSLog(@"Message failed");
}



//操作每一行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strcell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:strcell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font=[UIFont systemFontOfSize:16];
    }
    cell.textLabel.text= [[allsec objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
    cell.imageView.image=[[allimage objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark WeiboRequestDelegate

/**
 *分享成功回调
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    [self showHUDText:@"分享成功" showTime:1.0];
}

/**
 * @brief 未授权分享调用接口
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *ErrorInfo =error.userInfo[@"errcode"];
    if ([ErrorInfo isEqualToString:@"203"]) {//未授权
        //腾讯微博
        [_wbapi loginWithDelegate:self andRootController:self.moreView];
    }else if(ErrorInfo){
        [self showHUDText:@"授权失败" showTime:1.0];
    }else{
        [self showHUDText:@"网络错误" showTime:1.0];
    }
}

#pragma mark TengxunWeiboAuthDelegate
/**
 * @brief   授权成功后的回调
 */
- (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    /*授权成功后发送发送内容*/
    [self.wbapi requestWithParams:[self packageData] apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
}

//组装腾讯微博数据
- (NSMutableDictionary *)packageData{
    UIImage *pic = [UIImage imageNamed:@"about.png"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   str, @"content",
                                   pic, @"pic",
                                   nil];
    return params;
}

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.moreView.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

@end
