//
//  InfoDetailsController.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "InfoDetailsController.h"

@implementation InfoDetailsController
#pragma mark - 按钮
- (void)SendSMS:(id)sender{
    NSArray * arr =@[_infoView.infoDeta.tel];
    [self sendSMS:@"" recipientList:arr];
}

- (void)CallPhone:(id)sender{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString * strTel =[NSString stringWithFormat:@"tel:%@",_infoView.infoDeta.tel];
    NSURL *telURL =[NSURL URLWithString:strTel];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.infoView.view addSubview:callWebview];
}

#pragma mark - 弹出信息发送页面
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self.infoView presentViewController:controller animated:YES completion:nil];
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

@end
