//
//  MoreController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MoreController.h"
#import "ToolUtils.h"
#import "AAActivity.h"
#import  "AAActivityAction.h"
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
}


-(id)init{
    self=[super init];
    if(self){
        str=@"分享http://itunes.apple.com/lookup?id=647204141";
        
        
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
            [ToolUtils alertInfo:@"已是最新版本"];
            }
                break;
            case 1:{
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
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
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
@end
