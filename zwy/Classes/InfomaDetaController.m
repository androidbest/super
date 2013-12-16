//
//  InfomaDetaController.m
//  zwy
//
//  Created by cqsxit on 13-12-13.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

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
}


- (id)init{
    self =[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initWithLabelContentFrame)
                                                     name:NOTIFICATIONIMAGEDRAWRECT
                                                   object:nil];
        strContent=@"";
    }
    return self;
}

#pragma mark - 初始化界面
- (void)initWithData{
     scrollViewContentHeight=10;
    
    InformationInfo *info=_informaView.data.informationInfo;
//标题
   _informaView.labelTitle.text=info.title;
   _informaView.labelSource.text=info.sourceName;
   _informaView.labelContent.text=info.content;
    if (info.imagePath) {
         _informaView.imageContentView.hidden=NO;
        [HTTPRequest imageWithURL:info.imagePath
                        imageView:_informaView.imageContentView
                 placeholderImage:[UIImage imageNamed:@"list_NoData.jpg"]
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
- (void)btnCommend{

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
    [CompressImage touchPress:10000 AnimationToView:_informaView.view];
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
    
    //    if (result == MessageComposeResultCancelled)
    //        NSLog(@"Message cancelled");
    //    else if (result == MessageComposeResultSent)
    //        NSLog(@"Message sent");
    //    else
    //        NSLog(@"Message failed");
}


@end
