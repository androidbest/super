//
//  InfomaDetaController.m
//  zwy
//
//  Created by cqsxit on 13-12-13.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#define NOTIFICATIONCOMMEND @"notificationcommend"

#define WiressSDKDemoAppKey     @"801213517"
#define WiressSDKDemoAppSecret  @"9819935c0ad171df934d0ffb340a3c2d"
#define REDIRECTURI             @"http://www.ying7wang7.com"

#import "InfomaDetaController.h"
#import "InformationController.h"
#import "CompressImage.h"
#import "ConfigFile.h"
#import "ActionSheetWeibo.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SendMessageToWeiboViewController.h"
#import "CommentListView.h"




@implementation InfomaDetaController

{
    float scrollViewContentHeight;
    NSString *strContent;
    NSMutableArray *arrComment;
    NSString *strCommendPath;
    NSString *newsID;
}


- (id)init{
    self =[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initWithLabelContentFrame)
                                                     name:NOTIFICATIONIMAGEDRAWRECT
                                                   object:nil];
        strContent=@"";
        newsID=@"000000";
    }
    return self;
}

#pragma mark - 初始化界面
- (void)initWithData{
    
    if(self.wbapi == nil)
    {
    self.wbapi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey
                                        andSecret:WiressSDKDemoAppSecret
                                   andRedirectUri:REDIRECTURI];
    }
    
    
    if ([_informaView.data.informationInfo.newsID isEqualToString:newsID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.informaView.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已是最后一篇";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }else{
        if (![newsID isEqualToString:@"000000"])
            [CompressImage touchPress:10000 AnimationToView:_informaView.view];
        
        newsID=_informaView.data.informationInfo.newsID;
    }
    
    strCommendPath =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,PATH_COMMEND];
    arrComment =[[NSMutableArray alloc] initWithContentsOfFile:strCommendPath];
    if (arrComment) {
        if ([arrComment containsObject:_informaView.data.informationInfo.newsID]) {
            _informaView.btnCommend.enabled=NO;
            [_informaView.btnCommend setTitle:@"已赞" forState:UIControlStateNormal];
        }else{
            _informaView.btnCommend.enabled=YES;
            [_informaView.btnCommend setTitle:@"点赞" forState:UIControlStateNormal];
        }
    }else{
        arrComment =[[NSMutableArray alloc] init];
    }
    
     scrollViewContentHeight=10;
    
    InformationInfo *info=_informaView.data.informationInfo;
//标题
    strContent=info.title;
   _informaView.labelTitle.text=info.title;
   _informaView.labelSource.text=info.sourceName;
   _informaView.labelContent.text=info.content;
    if (info.imagePath) {
         _informaView.imageContentView.hidden=NO;
        [HTTPRequest imageWithURL:info.imagePath
                        imageView:_informaView.imageContentView
                 placeholderImage:[UIImage imageNamed:@"error_image.jpg"]
                       isDrawRect:drawRect_height];
        scrollViewContentHeight+=_informaView.imageContentView.frame.size.height+10;
    }else{
        _informaView.imageContentView.hidden=YES;
    }
    CGRect textRect = [_informaView.labelContent.text boundingRectWithSize:CGSizeMake(300.0f, 10000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:_informaView.labelContent.font}
                                                      context:nil];
    _informaView.labelContent.frame=CGRectMake(10, scrollViewContentHeight, 300, textRect.size.height);
    _informaView.scrollView.contentSize=CGSizeMake(0, scrollViewContentHeight+textRect.size.height);
}

#pragma mark -按钮操作

//返回
- (void)btnBack{
    [self.informaView.navigationController popViewControllerAnimated:YES];
    [self.informaView.navigationController setNavigationBarHidden:NO animated:YES];
}

//赞
- (void)btnCommend:(id)sender{
    //添加“+1”动画效果
    CAAnimation *animation =[CompressImage groupAnimation:_informaView.labelCommend];
    [_informaView.labelCommend.layer addAnimation:animation forKey:@"animation"];

    //添加点赞记录到本地
    [arrComment addObject:_informaView.data.informationInfo.newsID];
    [arrComment writeToFile:strCommendPath atomically:NO];
    [_informaView.btnCommend setTitle:@"已赞" forState:UIControlStateNormal];
    [(UIButton *)sender setEnabled:NO];
    
    [packageData commendNews:self newsID:_informaView.data.informationInfo.newsID SELType:NOTIFICATIONCOMMEND];
    
}

//转发
- (void)btnShare{
    ActionSheetWeibo * sheet =[[ActionSheetWeibo alloc] initWithViewdelegate:self WithSheetTitle:@"分享"];
    [sheet showInView:self.informaView.view];
}

//评论
- (void)btnComment{
    [self.informaView performSegueWithIdentifier:@"InforMationDetaToCommentList" sender:self.informaView];
}

//下一篇
- (void)btnNextNews{
    
    [(InformationController *)_informaView.data.controller PushNextNewsFromInformationDetaController];
    //刷新数据
    _informaView.scrollView.contentOffset=CGPointMake(0, 0);
    [self initWithData];
}

#pragma mark - baseControllerDelagete
- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 UIViewController *viewController=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"InforMationDetaToCommentList"]) {
        [(CommentListView *)viewController setInfoNewsDeta:_informaView.data.informationInfo];
    }
}


#pragma mark -  compressImgae_Notification
//刷新新闻内容坐标
- (void)initWithLabelContentFrame{
    scrollViewContentHeight=10;
    scrollViewContentHeight+=_informaView.imageContentView.frame.size.height+10;
    CGRect textRect = [_informaView.labelContent.text boundingRectWithSize:CGSizeMake(300.0f, 10000.0f)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:_informaView.labelContent.font}
                                                                   context:nil];
    _informaView.labelContent.frame=CGRectMake(10, scrollViewContentHeight, 300, textRect.size.height);
    _informaView.scrollView.contentSize=CGSizeMake(0, scrollViewContentHeight+textRect.size.height);
}

#pragma mark -ActionSheetWeiboDetaSource
//选择分享方式
- (void)actionSheetIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [self sendSMS:strContent recipientList:nil];
            break;
            
        case 1:
        {
            if([WXApi openWXApp]) [self sendWeiXinTextContent:strContent];
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
    message.text = strContent;
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
        [self.informaView presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark -信息发送回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultSent) {
        [self showHUDText:@"发送成功" showTime:1.0];
    }
}

#pragma mark WeiboRequestDelegate

/**
 *分享成功回调
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    [self showHUDText:@"转发成功" showTime:1.0];
    
}

/**
 * @brief 未授权分享调用接口
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *ErrorInfo =error.userInfo[@"errcode"];
    if ([ErrorInfo isEqualToString:@"203"]) {//未授权
        //腾讯微博
        [_wbapi loginWithDelegate:self andRootController:self.informaView];
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
    UIImage *pic = _informaView.imageContentView.image;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                  _informaView.data.informationInfo.title, @"content",
                                   pic, @"pic",
                                   nil];
    return params;
}

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.informaView.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

@end
