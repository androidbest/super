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
    ABRecordRef array =ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 遍历所有的联系人并修改指定的联系人
    for (id obj in  (__bridge NSArray *)array) {
        ABRecordRef people = CFRetain((__bridge ABRecordRef)obj);
        CFStringRef fn = ABRecordCopyValue(people, kABPersonFirstNameProperty);
        CFStringRef ln = ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        CFStringRef AllName = NULL;
        if (ln&&fn) {
            AllName =CFRetain((__bridge CFStringRef)([(__bridge NSString *)ln stringByAppendingString:(__bridge NSString *)(fn)]));
            CFRelease(ln);
            CFRelease(fn);
        }else  if (!ln&&fn){
            AllName=(CFRetain(fn));
          CFRelease(fn);
        }
        else if(!fn&&ln) {
            AllName=(CFRetain(ln));
            CFRelease(ln);
        }else{
            AllName =CFRetain((__bridge CFStringRef)mobile);
        }
       
        BOOL isSet =[(__bridge NSString *)AllName isEqualToString:Name];
        CFRelease(AllName);
        if (isSet) {
            /*处理多值属性*/
            ABMutableMultiValueRef multi =ABMultiValueCreateMutable(kABMultiStringPropertyType);
             ABMultiValueRef ALLTEL = ABRecordCopyValue(people, kABPersonPhoneProperty);
            
            
            /*保存原有的多个号码，只修改最后一个多值号码*/
            for(int i = 0 ;i < ABMultiValueGetCount(ALLTEL)-1; i++)
            {
                NSString *Tel=Nil;
                Tel =CFAutorelease((ABMultiValueCopyValueAtIndex(ALLTEL, i))) ;
                Tel = ([Tel stringByReplacingOccurrencesOfString:@"(" withString:@""]);
                Tel = ([Tel stringByReplacingOccurrencesOfString:@")" withString:@""]);
                Tel = ([Tel stringByReplacingOccurrencesOfString:@"-" withString:@""]);
                Tel = ([Tel stringByReplacingOccurrencesOfString:@" " withString:@""]);
                ABMultiValueInsertValueAndLabelAtIndex(multi, (__bridge CFTypeRef)(Tel), kABPersonPhoneMobileLabel, i, NULL);
               
            }
            if (ABMultiValueGetCount(ALLTEL)!=0) {
                ABMultiValueInsertValueAndLabelAtIndex(multi, (__bridge CFTypeRef)(mobile), kABPersonPhoneMobileLabel, ABMultiValueGetCount(ALLTEL)-1, NULL);/*修改最后一个号码*/
                ABRecordSetValue(people, kABPersonPhoneProperty, multi, NULL);
            }
            CFRelease(ALLTEL);
            CFRelease(multi);
        }
        CFRelease(people);
    }
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    
    // 释放通讯录对象的内存
    CFRelease(array);
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
    ABRecordRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (id aRecord in (__bridge NSArray *)array) {

    //号码
    ABMultiValueRef multi =ABRecordCopyValue(CFRetain((__bridge ABRecordRef)(aRecord)), kABPersonPhoneProperty);
    CFRelease((__bridge CFTypeRef)(aRecord));
    NSString *Tel=Nil;
    for(int i = 0 ;i < ABMultiValueGetCount(multi); i++)
    {
        Tel = CFAutorelease(ABMultiValueCopyValueAtIndex(multi, i));
        Tel = [Tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
        Tel = [Tel stringByReplacingOccurrencesOfString:@")" withString:@""];
        Tel = [Tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        Tel = [Tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
        
        if ([Tel isEqualToString:mobile]) {
            CFStringRef strFirstName=CFRetain((__bridge CFStringRef)[Name substringFromIndex:1]);
            CFStringRef strLastName =CFRetain((__bridge CFStringRef)[Name substringToIndex:1]);
            //处理单值属性
        ABRecordSetValue((__bridge ABRecordRef)(aRecord), kABPersonFirstNameProperty, strFirstName, NULL)&&ABRecordSetValue((__bridge ABRecordRef)(aRecord), kABPersonLastNameProperty,strLastName, NULL);//处理单值属性
            CFRelease(strFirstName);
            CFRelease(strLastName);
        }
        CFRelease(multi);
    }
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    CFRelease(array);
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
