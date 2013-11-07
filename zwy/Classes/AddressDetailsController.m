//
//  AddressDetailsController.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "AddressDetailsController.h"

@implementation AddressDetailsController


#pragma  mark - 按钮实现方法

/*发送短信*/
- (void)SendSMS{
    NSArray * arr =@[_detailsView.textTel.text];
    [self sendSMS:@"" recipientList:arr];
}

/*拨打电话*/
- (void)CallTel{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString * strTel =[NSString stringWithFormat:@"tel:%@",_detailsView.textTel.text];
    NSURL *telURL =[NSURL URLWithString:strTel];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.detailsView.view addSubview:callWebview];
}

/*修改信息*/
- (void)RightDown:(UIButton *)sender{
    if (sender.tag==0) {
        [sender setImage:[UIImage imageNamed:@"navigation_save"] forState:UIControlStateNormal];
        _detailsView.textName.enabled=YES;
        _detailsView.textName.borderStyle=UITextBorderStyleRoundedRect;
        [_detailsView.textName becomeFirstResponder];
        _detailsView.textTel.enabled=YES;
        _detailsView.textTel.borderStyle=UITextBorderStyleRoundedRect;
        sender.tag=1;
        return;
    }else{
        [sender setImage:[UIImage imageNamed:@"navigation_Edit_over"] forState:UIControlStateNormal];
        _detailsView.textName.enabled=NO;
        _detailsView.textName.borderStyle=UITextBorderStyleNone;
        _detailsView.textTel.enabled=NO;
        _detailsView.textTel.borderStyle=UITextBorderStyleNone;
        sender.tag=0;
    }
    if ([_detailsView.dicAddressData[@"name"] isEqualToString:_detailsView.textName.text]&&
        [_detailsView.dicAddressData[@"tel"] isEqualToString:_detailsView.textTel.text])return;
    
    //修改号码
    if ([_detailsView.dicAddressData[@"name"] isEqualToString:_detailsView.textName.text]&&
        ![_detailsView.dicAddressData[@"tel"] isEqualToString:_detailsView.textTel.text]) {
        [AddressDetailsController updateAddressBookPersonSetMobileWithFirstName:_detailsView.textName.text
                                                                         mobile:_detailsView.textTel.text];
    }
    
    //修改号码与姓名
    if (![_detailsView.dicAddressData[@"name"] isEqualToString:_detailsView.textName.text]&&
        ![_detailsView.dicAddressData[@"tel"] isEqualToString:_detailsView.textTel.text]) {
        /*修改号码*/
        [AddressDetailsController updateAddressBookPersonSetMobileWithFirstName:_detailsView.dicAddressData[@"name"]
                                                                         mobile:_detailsView.textTel.text];
        /*修改名字*/
        [AddressDetailsController updateAddressBookPersonSetNameWithFirstName:_detailsView.textName.text
                                                                       mobile:_detailsView.textTel.text];
    }
    
    //修改名字
    if (![_detailsView.dicAddressData[@"name"] isEqualToString:_detailsView.textName.text]&&
        [_detailsView.dicAddressData[@"tel"] isEqualToString:_detailsView.textTel.text]) {
        [AddressDetailsController updateAddressBookPersonSetNameWithFirstName:_detailsView.textName.text
                                                                       mobile:_detailsView.textTel.text];
    }
    
    //刷新通讯录
    [_detailsView.pushAddressBook updateAddressBook];
    _detailsView.dicAddressData =NULL;
    _detailsView.dicAddressData =@{@"name":_detailsView.textName.text,
                                   @"tel":_detailsView.textTel.text};
    
}

#pragma mark - 修改号码
+ (void) updateAddressBookPersonSetMobileWithFirstName:(NSString *)Name
                                       mobile:(NSString *)mobile
{
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 遍历所有的联系人并修改指定的联系人
    for (id obj in array) {
        ABRecordRef people = (__bridge ABRecordRef)obj;
        NSString *fn = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        NSString *ln = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        NSString * AllName;
        if (!ln) {
            AllName=fn;
        }
        else if(!fn&&ln){
            AllName=ln;
        }
        if (ln&&fn) {
            AllName =[ln stringByAppendingString:fn];
        }
        BOOL isSet =[AllName isEqualToString:Name];
        if (isSet) {
            /*处理多值属性*/
            ABMutableMultiValueRef multi =ABMultiValueCreateMutable(kABMultiStringPropertyType);
             ABMultiValueRef ALLTEL = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *Tel;
            
            /*保存原有的多个号码，只修改最后一个多值号码*/
            for(int i = 0 ;i < ABMultiValueGetCount(ALLTEL)-1; i++)
            {
                Tel = (__bridge NSString *)ABMultiValueCopyValueAtIndex(ALLTEL, i);
                Tel = [Tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
                Tel = [Tel stringByReplacingOccurrencesOfString:@")" withString:@""];
                Tel = [Tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                Tel = [Tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                ABMultiValueInsertValueAndLabelAtIndex(multi, (__bridge CFTypeRef)(Tel), kABPersonPhoneMobileLabel, i, NULL);
            }
            if (ABMultiValueGetCount(ALLTEL)!=0) {
                ABMultiValueInsertValueAndLabelAtIndex(multi, (__bridge CFTypeRef)(mobile), kABPersonPhoneMobileLabel, ABMultiValueGetCount(ALLTEL)-1, NULL);/*修改最后一个号码*/
                ABRecordSetValue(people, kABPersonPhoneProperty, multi, NULL);
            }
          //  bool didadd = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(mobile), kABPersonPhoneIPhoneLabel, NULL);

        }
    }
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
    
}

#pragma mark - 修改姓名
+ (void) updateAddressBookPersonSetNameWithFirstName:(NSString *)Name
                                              mobile:(NSString *)mobile
{
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (id aRecord in array) {

    //号码
    ABMultiValueRef multi = ABRecordCopyValue((__bridge ABRecordRef)(aRecord), kABPersonPhoneProperty);
    CFStringRef CellNumber;
    CellNumber = ABMultiValueCopyLabelAtIndex(multi, 0);
    NSString *Tel =(__bridge NSString *)CellNumber;
    for(int i = 0 ;i < ABMultiValueGetCount(multi); i++)
    {
        Tel = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, i);
        Tel = [Tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
        Tel = [Tel stringByReplacingOccurrencesOfString:@")" withString:@""];
        Tel = [Tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        Tel = [Tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
        if ([Tel isEqualToString:mobile]) {
            NSString *strFirstName=[Name substringFromIndex:1];
            NSString *strLastName =[Name substringToIndex:1];
            //处理单值属性
          bool didadd =  ABRecordSetValue((__bridge ABRecordRef)(aRecord), kABPersonFirstNameProperty, (__bridge CFDataRef)strFirstName, NULL)&&ABRecordSetValue((__bridge ABRecordRef)(aRecord), kABPersonLastNameProperty, (__bridge CFDataRef)strLastName, NULL);//处理单值属性
            if (!didadd) {
                NSLog(@"Error");
            }
        }
    }
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }

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
        [self.detailsView presentViewController:controller animated:YES completion:nil];
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
