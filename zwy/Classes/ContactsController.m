//
//  ContactsController.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ContactsController.h"
#import "MesaageIMCell.h"
#import "ConfigFile.h"
#import "HTTPRequest.h"
#import "PeopelInfo.h"
@implementation ContactsController{
    NSArray  *arrNumber;
    BOOL isSearching;
}

-(id)init{
    self=[super init];
    if(self){
        self.arrSection =[NSMutableArray arrayWithObjects:
                          @"a",@"b",@"c",@"d",@"e",@"f",
                          @"g",@"h",@"i",@"j",@"k",@"l",
                          @"m",@"n",@"o",@"p",@"q",@"r",
                          @"s",@"t",@"u",@"v",@"w",@"x",
                          @"y",@"z",@"#",nil];
        
        arrNumber =@[@"0",@"1",@"2",@"3",@"4",
                     @"5",@"6",@"7",@"8",@"9"];
        isSearching=NO;
    }
    return self;
}

-(void)initECnumerData{
    _arrAllLink = [ConfigFile setEcNumberInfo];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"member.txt"]];
    if(_arrAllLink.count==0&&!blHave){
        self.HUD.labelText = @"请同步单位通讯录";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD show:YES];
        [self.HUD  hide:YES afterDelay:2];
    }
    
    NSMutableArray * arrRemoveObject=[[NSMutableArray alloc] init];
    for (int i = 0; i<_arrSection.count; i++) {
        NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter == '%@'",_arrSection[i]];
        NSPredicate * predicate;
        predicate = [NSPredicate predicateWithFormat:strPre];
        NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
        if (results.count==0) {
            [arrRemoveObject addObject:_arrSection[i]];
        }
    }
    [self.arrSection removeObjectsInArray:arrRemoveObject];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

#pragma mark - UITableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_contactsView.searchBar.text.length!=0&&isSearching) return 1;
    
    [_contactsView.indexBar setIndexes:_arrSection];
    return _arrSection.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_contactsView.searchBar.text.length!=0&&isSearching) return nil;
    return _arrSection[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_contactsView.searchBar.text.length!=0&&isSearching)return _arrSeaPeople.count;
    
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * contacts =@"contactsChatCell";
    MesaageIMCell * cell =[tableView dequeueReusableCellWithIdentifier:contacts];
    if (!cell) {
        cell = [[MesaageIMCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:contacts];
    }
    

    PeopelInfo *info=nil;
    if (_contactsView.searchBar.text.length!=0&&isSearching){
        info =_arrSeaPeople[indexPath.row];
    }
    else{
        NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[indexPath.section]];
        NSPredicate * predicate;
        predicate = [NSPredicate predicateWithFormat:strPre];
        info=[[_arrAllLink filteredArrayUsingPredicate: predicate] objectAtIndex:indexPath.row];
    }
    
    cell.username.text=info.Name;
    [HTTPRequest imageWithURL:info.headPath imageView:cell.imageMark placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",_arrSection[indexPath.section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
    
    if (_contactsView.searchBar.text.length!=0&&isSearching)self.contactsView.info=_arrSeaPeople[indexPath.row];
    else  self.contactsView.info=[results objectAtIndex:indexPath.row];
    
    self.contactsView.tabBarController.navigationItem.title=@"";
    [self.contactsView performSegueWithIdentifier:@"contactstodetail" sender:self.contactsView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchDisplayDelegate
- (void)filteredListContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if (searchText) {
        isSearching=YES;
        if (_arrSeaPeople.count!=0||_arrSeaPeople) {
            _arrSeaPeople=NULL;
            _arrSeaPeople=[[NSArray alloc] init];
        }else{
            _arrSeaPeople=[[NSArray alloc] init];
        }
        
        NSString * strSearchbar;
        NSString* strFirstLetter=@"";
        if (searchText.length!=0)strFirstLetter=[[searchText substringToIndex:1] lowercaseString];
        
        //设置搜索条件
        if ([_arrSection containsObject: strFirstLetter])
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
        self.arrSeaPeople=[self.arrAllLink filteredArrayUsingPredicate: predicateTemplate];
    }else {
        isSearching=NO;
    }
    [_contactsView.uitableview reloadData];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    [self filteredListContentForSearchText:searchString scope:
     [[self.contactsView.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:[self.contactsView.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //一旦Scope Button有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    [self filteredListContentForSearchText:[self.contactsView.searchDisplayController.searchBar text] scope:
     [[self.contactsView.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:searchOption]];
    return YES;
}


//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBar:_contactsView.searchBar textDidChange:nil];
    [_contactsView.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_contactsView.searchBar textDidChange:nil];
    isSearching=NO;
    [_contactsView.uitableview reloadData];
    [_contactsView.searchBar resignFirstResponder];
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([self.contactsView.uitableview numberOfSections] > index && index > -1){   // for safety, should always be YES
        [self.contactsView.uitableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                                                 atScrollPosition:UITableViewScrollPositionTop
                                                         animated:YES];
    }
}

@end
