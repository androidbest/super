//
//  ContactsDetailController.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ContactsDetailController.h"

@implementation ContactsDetailController

-(void)submit{
    [self initBackBarButtonItem:self.contactsDetailView];
[self.contactsDetailView performSegueWithIdentifier:@"chatstart" sender:self.contactsDetailView];
}

-(void)callTell{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString * strTel =[NSString stringWithFormat:@"tel:%@",self.contactsDetailView.data.tel];
    NSURL *telURL =[NSURL URLWithString:strTel];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.contactsDetailView.view addSubview:callWebview];
}
-(void)smsSend{
    NSArray *arr=@[self.contactsDetailView.data.tel];
[self sendSMS:@"" recipientList:arr];
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
        [self.contactsDetailView presentViewController:controller animated:YES completion:nil];
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
