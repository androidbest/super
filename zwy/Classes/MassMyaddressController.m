//
//  MassMyaddressController.m
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MassMyaddressController.h"
#import "GroupInfo.h"
#import "PeopelInfo.h"
#import "optionCell.h"
#import "pinyin.h"


@implementation MassMyaddressController
{
    NSArray * arrLetter;
    NSArray * arrNumber;
    BOOL isFirstPages;
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
        if (!LastName) {
            Name=(__bridge NSString *)firstName;
        }
        else if(!firstName&&LastName){
          Name=(__bridge NSString *)LastName;
        }
        if (LastName&&firstName) {
            Name =[(__bridge NSString *)LastName stringByAppendingString:(__bridge NSString *)firstName];
        }else if(!Tel){
            Name =@"未命名";
        }else if (Tel){
            Name=Tel;
        }
        
        //首字母
        NSString* Letter;
        if (Name.length>0) {
          Letter =[[Name substringToIndex:1] lowercaseString];
        }
        
        if (![arrLetter containsObject:Letter]) {
            if (Name&&[Name isEqualToString:@"未命名"]) {
                Letter=[NSString stringWithFormat:@"%c",pinyinFirstLetter([Name characterAtIndex:0])];
            }else {
                Letter=@"#";
            }
        }
        if (Tel) {
            PeopelInfo *info =[PeopelInfo new];
            info.Name=Name;
            info.tel=Tel;
            info.letter=Letter;
            [Allpeople addObject:info];
        }
    }
    return Allpeople;
}


- (id)init{
    self =[super init];
    if (self) {
        arrLetter =@[@"a",@"b",@"c",@"d",@"e",@"f",
                     @"g",@"h",@"i",@"j",@"k",@"l",
                     @"m",@"n",@"o",@"p",@"q",@"r",
                     @"s",@"t",@"u",@"v",@"w",@"x",
                     @"y",@"z"];
        
        arrNumber =@[@"0",@"1",@"2",@"3",@"4",
                     @"5",@"6",@"7",@"8",@"9"];
        
        
    }
    return self;
}

- (void)initWithData{
    isFirstPages=YES;
    self.arrAllPeople =[[NSMutableArray alloc] init];
    _arrSeaPeople =[[NSArray alloc] init];
    _arrFirstGroup =[[NSArray alloc] init];
    self.arrOption=[[NSMutableArray alloc] init];
    [_arrAllPeople addObjectsFromArray:[self Allpeople]];
    _arrFirstGroup=[self Allpeople];
}

#pragma mark - 按钮实现方法
/*全选*/
- (void)btnAll:(id)sender{
    for (UIView * view in self.massView.tableViewAddress.visibleCells) {
        optionCell *cell =(optionCell *)view;
        [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    }
    
    NSObject * obj;
    if (isFirstPages&&_massView.searchBar.text.length==0){
        for (int i=0; i<_arrFirstGroup.count; i++) {
            obj =[_arrFirstGroup objectAtIndex:i];
            if (![_arrOption containsObject:obj])[_arrOption addObject:obj];
        }
    }
    else{
        for (int i=0; i<_arrSeaPeople.count; i++) {
            obj =[_arrSeaPeople objectAtIndex:i];
            if (![_arrOption containsObject:obj])[_arrOption addObject:obj];
        }
    }
    
}

/*清空*/
- (void)btnCencel:(id)sender{
    for (UIView * view in self.massView.tableViewAddress.visibleCells) {
        optionCell *cell =(optionCell *)view;
        [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    [_arrOption removeAllObjects];
}

/*确认*/
- (void)btnConfirm:(id)sender{
    [self.massView.navigationController popViewControllerAnimated:YES];
    [self.massView.MassDelegate returnDidAddress:_arrOption];
}

/*返回*/
- (void)btnReturn:(id)sender{
    [self.massView.navigationController popViewControllerAnimated:YES];
}
-(void)btnBack{
    if ([_massView.searchBar resignFirstResponder]) {
        [self performSelector:@selector(LeftDown) withObject:self afterDelay:0.3f];
    }else{
        [self.massView.navigationController popViewControllerAnimated:YES];
    }
}
//返回上一级
- (void)LeftDown{
     [self.massView.navigationController popViewControllerAnimated:YES];
}

/*选择人员*/
- (void)btnOption:(id)sender{
    NSObject * obj;
    UIButton * btn =(UIButton *)sender;
    if (isFirstPages&&_massView.searchBar.text.length==0) {
        obj =[_arrFirstGroup objectAtIndex:btn.tag];
    }else{
        obj =[_arrSeaPeople objectAtIndex:btn.tag];
    }
    
    /*如果存在则删除，否则复制*/
    if ([_arrOption containsObject:obj]) {
        [_arrOption  removeObject:obj];
        [btn setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }else{
        [_arrOption  addObject:obj];
        [btn setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFirstPages&&_massView.searchBar.text.length==0) {
        return _arrFirstGroup.count;
    }else{
        return _arrSeaPeople.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellINdenfer =@"Cell";
    optionCell * cell =[tableView dequeueReusableCellWithIdentifier:CellINdenfer];
    if (!cell) {
        cell =[[optionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellINdenfer withDelegate:self];
        cell.detailTextLabel.textColor=[UIColor grayColor];
        cell.detailTextLabel.font =[UIFont systemFontOfSize:14];
        cell.textLabel.font =[UIFont boldSystemFontOfSize:16];
    }
    NSObject * obj;
    if (isFirstPages&&_massView.searchBar.text.length==0) {
        obj =[_arrFirstGroup objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
    
    
    if ([obj isKindOfClass:[PeopelInfo class]]) {
        cell.textLabel.text=[(PeopelInfo *)obj Name];
        cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
    }else if([obj isKindOfClass:[GroupInfo class]]){
        cell.textLabel.text=[(GroupInfo *)obj Name];
        NSString *strDeta=[[(GroupInfo *)obj Count] stringByAppendingString:@"  位联系人"];
        strDeta=[strDeta stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        cell.detailTextLabel.text=strDeta;
    }
    
    
    /**/
    if ([_arrOption containsObject:obj]) {
        [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    }
    else{
        [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    /**/
    
    cell.tag=indexPath.row;
    cell.btnOption.tag=indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject * obj;
    
    if (isFirstPages&&_massView.searchBar.text.length==0) {
        obj =[_arrFirstGroup objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
    
    /*********/
    for (UIView * view in tableView.visibleCells) {
        if (view.tag ==indexPath.row) {
            optionCell *cell =(optionCell *)view;
            if ([_arrOption containsObject:obj]) {
                [_arrOption removeObject:obj];
                [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
            }
            else{
                [_arrOption addObject:obj];
                [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
            }
        }
    }
    /********/
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate
//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText) {
        
        if (_arrSeaPeople.count!=0) {
            _arrSeaPeople=NULL;
            _arrSeaPeople=[[NSArray alloc] init];
        }
        
        NSString * strSearchbar;
        NSString* strFirstLetter=@"";
        if (searchText.length!=0)strFirstLetter=[[searchText substringToIndex:1] lowercaseString];
        
        //设置搜索条件
        if ([arrLetter containsObject: strFirstLetter])
        {
            searchText =[searchText lowercaseString];
            strSearchbar =[NSString stringWithFormat:@"SELF.letter CONTAINS '%@'",searchText];
        }else if([arrNumber containsObject:strFirstLetter]){
            strSearchbar =[NSString stringWithFormat:@"SELF.tel CONTAINS '%@'",searchText];
        }
        else{
            strSearchbar =[NSString stringWithFormat:@"SELF.Name CONTAINS '%@'",searchText];
        }
        
        
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
        self.arrSeaPeople=[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
        
    }
    [_massView.tableViewAddress reloadData];
}
//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBar:_massView.searchBar textDidChange:nil];
    [_massView.searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_massView.searchBar textDidChange:nil];
    [_massView.searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_massView.searchBar resignFirstResponder];
}

@end
