//
//  MyAddressController.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-8.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "MyAddressController.h"
#import "AddressDetailsView.h"
#import "pinyin.h"

#import <AddressBook/AddressBook.h>
@implementation MyAddressController
{
    
}
- (NSArray * )Allpeople{
    
    NSMutableArray * Allpeople=[[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
     {
         addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);

        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
  }
    
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBooks);
    for (int i=0; i<array.count; i++) {
        ABRecordRef aRecord=(__bridge ABRecordRef)([array objectAtIndex:i]);
    
        //号码
        ABMultiValueRef multi = ABRecordCopyValue(aRecord, kABPersonPhoneProperty);
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
        
        //姓名
        CFStringRef firstName,LastName;
        firstName =ABRecordCopyValue(aRecord,kABPersonFirstNameProperty);
        LastName =ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
        
        NSString * Name ;
        if (firstName&&firstName&&!LastName) {
            Name=(__bridge NSString *)firstName;
        } else if(!firstName&&LastName){
            Name=(__bridge NSString *)LastName;
        } else if (LastName&&firstName) {
            Name =[(__bridge NSString *)LastName stringByAppendingString:(__bridge NSString *)firstName];
        }else if(!Tel){
            Name =@"未命名";
        }else if (Tel){
            Name=Tel;
        }
        if (Name.length==0) {
              Name =@"未命名";
        }
        //首字母
        NSString* Letter;
        if (Name.length>0) {
            Letter =[[Name substringToIndex:1] lowercaseString];
        }
        
        if (![_arrSection containsObject:Letter]) {
            if (Name&&![Name isEqualToString:@"未命名"]) {
                Letter=[NSString stringWithFormat:@"%c",pinyinFirstLetter([Name characterAtIndex:0])];
            }else {
                Letter=@"#";
            }
        }
        if (Tel) {
            NSDictionary *peopleInfo =[NSDictionary dictionaryWithObjectsAndKeys:
                                       Name,  @"name",
                                       Tel,   @"tel",
                                       Letter,@"Firetletter", nil];
            [Allpeople addObject:peopleInfo];
        }
    }
    return Allpeople;
}

#pragma mark -初始化
- (id)init{
    self =[super init];
    if (self) {
        self.arrSection =[NSMutableArray arrayWithObjects:
                          @"a",@"b",@"c",@"d",@"e",@"f",
                          @"g",@"h",@"i",@"j",@"k",@"l",
                          @"m",@"n",@"o",@"p",@"q",@"r",
                          @"s",@"t",@"u",@"v",@"w",@"x",
                          @"y",@"z",@"#",nil];
          }
    return self;
}

- (void)initWithData{
    self.arrAllLink =[[NSMutableArray alloc] initWithArray:[self Allpeople]];
    
    NSMutableArray * arrRemoveObject=[[NSMutableArray alloc] init];
    for (int i = 0; i<_arrSection.count; i++) {
        NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[i]];
        NSPredicate * predicate;
        predicate = [NSPredicate predicateWithFormat:strPre];
        NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
        if (results.count==0) {
            [arrRemoveObject addObject:_arrSection[i]];
        }
    }
    [self.arrSection removeObjectsInArray:arrRemoveObject];
}

#pragma mark - 按钮实现方法
- (void)btnAddPeople{/*添加联系人*/
    [self.addressView performSegueWithIdentifier:@"MyAddressToAddPeople" sender:nil];
}

#pragma mark - 更改通讯录信息后刷新列表
- (void)updateAddressBook{
    _arrAllLink=NULL;
    _arrSection=NULL;
    self.arrSection =[NSMutableArray arrayWithObjects:
                      @"a",@"b",@"c",@"d",@"e",@"f",
                      @"g",@"h",@"i",@"j",@"k",@"l",
                      @"m",@"n",@"o",@"p",@"q",@"r",
                      @"s",@"t",@"u",@"v",@"w",@"x",
                      @"y",@"z",@"#",nil];
    [self initWithData];
    [self.addressView.tableViewAddress reloadData];
}

#pragma mark - UITableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_addressView.indexBar setIndexes:_arrSection];
    return _arrSection.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _arrSection[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
      NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
    return results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString * identifierCell=@"Cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        cell.detailTextLabel.font =[UIFont systemFontOfSize:14];
        cell.textLabel.font =[UIFont boldSystemFontOfSize:16];
    }
    
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[indexPath.section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    cell.textLabel.text=[[[_arrAllLink filteredArrayUsingPredicate: predicate] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text =[[[_arrAllLink filteredArrayUsingPredicate: predicate] objectAtIndex:indexPath.row] objectForKey:@"tel"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[indexPath.section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddressDetailsView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"AddressDetailsView"];
    [self.addressView.navigationController pushViewController:detaView animated:YES];
    detaView.dicAddressData=[results objectAtIndex:indexPath.row];
    detaView.pushAddressBook=self;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([self.addressView.tableViewAddress numberOfSections] > index && index > -1){   // for safety, should always be YES
        [self.addressView.tableViewAddress scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}
@end
