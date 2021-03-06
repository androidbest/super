//
//  SJABHelper.m
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "SJABHelper.h"
#import <AddressBook/AddressBook.h>

@implementation SJABHelper

// 单列模式
+ (SJABHelper*)shareControl
{
    static SJABHelper *instance;
    @synchronized(self) {
        if(!instance) {
            instance = [[SJABHelper alloc] init];
        }
    }
    return instance;
}

+ (BOOL)addContactName:(NSString *)name phoneNum:(NSString *)num withLabel:(NSString *)label
{
    return [[SJABHelper shareControl] addContactName:name phoneNum:num withLabel:label];
}

// 添加联系人（联系人名称、号码、号码备注标签）
- (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num withLabel:(NSString*)label
{
//创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    
    
    ABAddressBookRef addressBook = NULL;
    //如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else
    {
        addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    }
    
    int NameNum=0;
    ABRecordRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (id obj in (__bridge_transfer NSArray *)array) {
        ABRecordRef aRecord=(__bridge_retained ABRecordRef)obj;
        //姓名
        CFStringRef firstName,LastName;
        firstName =ABRecordCopyValue(aRecord,kABPersonFirstNameProperty);
        LastName =ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
        NSString *strname ;
        if (firstName&&firstName&&!LastName) {
            strname=(__bridge_transfer NSString *)firstName;
        } else if(!firstName&&LastName){
            strname=(__bridge_transfer NSString *)LastName;
        } else if (LastName&&firstName) {
            strname =[(__bridge_transfer NSString *)LastName stringByAppendingString:(__bridge_transfer NSString *)firstName];
        }
        
        //判断是否包含此名字
        NSRange foundObj=[strname rangeOfString:name options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            NameNum ++;
        }
        
        if(aRecord){
            CFRelease(aRecord);
        }
        
    }
    if (NameNum!=0) {
        name =[NSString stringWithFormat:@"%@(%d)",name,NameNum];
    }
    
    
//设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge_retained CFTypeRef)num, kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    CFRelease(multi);
    
//将新建联系人记录添加如通讯录中
    BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
    
    CFRelease(record);
    if (!success) {
        if(addressBook){
            CFRelease(addressBook);
        }
        return NO;
    }else{
        // 如果添加记录成功，保存更新到通讯录数据库中
        success = ABAddressBookSave(addressBook, &error);
        if(addressBook){
            CFRelease(addressBook);
        }
        return success ? YES : NO;
    }
    
}

+ (ABHelperCheckExistResultType)existPhone:(NSString *)phoneNum
{
    return [[SJABHelper shareControl] existPhone:phoneNum];
}

// 指定号码是否已经存在
- (ABHelperCheckExistResultType)existPhone:(NSString*)phoneNum
{
    ABAddressBookRef addressBook = NULL;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
        {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else
    {
         addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    }
    CFArrayRef records = NULL;
    if (addressBook) {
//获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
    }else{
        return ABHelperCanNotConncetToAddressBook;
    }
    
//遍历全部联系人，检查是否存在指定号码
    for (id obj in  (__bridge NSArray *)records) {
        ABRecordRef record =CFRetain((__bridge ABRecordRef)obj);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
        CFRelease(items);
        
        if (phoneNums) {
            for (int j=0; j<CFArrayGetCount(phoneNums); j++) {
                CFStringRef phone =CFArrayGetValueAtIndex(phoneNums, j);
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
                NSString *trimmedString = [(__bridge NSString *)phone stringByTrimmingCharactersInSet:set];
                if ([trimmedString isEqualToString:phoneNum]) {
                    CFRelease(phoneNums);
                    CFRelease(record);
                    CFRelease(records);
                    CFRelease(addressBook);
                    return ABHelperExistSpecificContact;
                }
            }
            CFRelease (phoneNums);
        }
        CFRelease(record);
    }
    
    CFRelease(records);
    if (addressBook) {
     CFRelease(addressBook);
    }
    return ABHelperNotExistSpecificContact;
}

@end
