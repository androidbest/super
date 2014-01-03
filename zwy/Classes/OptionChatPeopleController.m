//
//  OptionChatPeopleController.m
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "OptionChatPeopleController.h"
#import "AddChatPeoplesCell.h"
#import "PeopelInfo.h"

@implementation OptionChatPeopleController{
    NSArray  *arrNumber;
    BOOL isSearching;
}

-(id)init{
    self=[super init];
    if(self){
        self.arrOption =[[NSMutableArray alloc] init];
        
        arrNumber =@[@"0",@"1",@"2",@"3",@"4",
                     @"5",@"6",@"7",@"8",@"9"];
        isSearching=NO;
    }
    return self;
}

- (void)initWithData{
[self initPeople];
}

-(void)initPeople{
    if (EX_arrGroupAddressBooks) _arrAllLink=[[NSMutableArray alloc] initWithArray:EX_arrGroupAddressBooks];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"member.txt"]];
    if(_arrAllLink.count==0&&!blHave){
        [self showHUDText:@"请先同步通讯录" showTime:1.0];
    }else if (_optionView.arrReqeatePeoples) {
        for (int i=0;i<_optionView.arrReqeatePeoples.count-2; i++) {
            PeopelInfo *info =_optionView.arrReqeatePeoples[i];
            NSString * strPre=[NSString stringWithFormat:@"SELF.userID == '%@'",info.userID];
            NSPredicate * predicate;
            predicate = [NSPredicate predicateWithFormat:strPre];
            NSArray *arr=[self.arrAllLink filteredArrayUsingPredicate: predicate];
            [self.arrAllLink removeObjectsInArray:arr];
        }
       
    }
    
    NSString * strPre=[NSString stringWithFormat:@"SELF.tel == '%@'",user.msisdn];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    NSArray *arr=[self.arrAllLink filteredArrayUsingPredicate: predicate];
    [self.arrAllLink removeObjectsInArray:arr];
    
}



//返回按钮
- (void)LeftDown{
    [self.optionView dismissViewControllerAnimated:YES completion:nil];
}

//确定添加按钮
- (void)rightDown{
    if (_arrOption.count<2&&_optionView.arrReqeatePeoples.count<3){
        [ToolUtils alertInfo:@"群聊人数必须大于3人"];
        return;
    }
    
    if (![_arrOption containsObject:[self getPeopleInfoFromUserInfo]]) {
       [_arrOption addObject:[self getPeopleInfoFromUserInfo]];//将自己加入群组
    }
    
    [self.optionView dismissViewControllerAnimated:_optionView.ismodeAnimation completion:nil];
    [self.optionView.OptionChatPeopleDelegate MessageViewToChatMessageView:_arrOption];
}

- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}



#pragma mark - UITableViewDateSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_optionView.searchBar.text.length!=0&&isSearching) return 1;
    
//    [_optionView.indexBar setIndexes:_arrSection];
    return EX_arrSection.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_optionView.searchBar.text.length!=0&&isSearching) return nil;
    return EX_arrSection[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_optionView.searchBar.text.length!=0&&isSearching)return _arrSeaPeople.count;
    
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",EX_arrSection[section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * contacts =@"contactsChatCell";
    AddChatPeoplesCell * cell =[tableView dequeueReusableCellWithIdentifier:contacts];
    if (!cell) {
        cell = [[AddChatPeoplesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:contacts];
    }
    
    
    PeopelInfo *info=nil;
    if (_optionView.searchBar.text.length!=0&&isSearching){
        info =_arrSeaPeople[indexPath.row];
    }
    else{
        NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",EX_arrSection[indexPath.section]];
        NSPredicate * predicate;
        predicate = [NSPredicate predicateWithFormat:strPre];
        info=[[_arrAllLink filteredArrayUsingPredicate: predicate] objectAtIndex:indexPath.row];
    }
    
    cell.labelTitle.text=info.Name;
    [HTTPRequest imageWithURL:info.headPath imageView:cell.imageHead placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    /**/
    if ([_arrOption containsObject:info]) {
        [cell.imageViewAdd setImage:[UIImage imageNamed:@"btn_check"]];
    }
    else{
        [cell.imageViewAdd setImage:[UIImage imageNamed:@"btn_uncheck"]];
    }
    /**/
    cell.tag=(indexPath.section+1)*10000+indexPath.row;
    return cell;
}


#pragma mark - UISearchDisplayDelegate
- (void)filteredListContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if (searchText) {
        isSearching=YES;
        if (_arrSeaPeople.count!=0||_arrSeaPeople){
            _arrSeaPeople=NULL;
            _arrSeaPeople=[[NSArray alloc] init];
        }else{
            _arrSeaPeople=[[NSArray alloc] init];
        }
        
        NSString * strSearchbar;
        NSString* strFirstLetter=@"";
        if (searchText.length!=0)strFirstLetter=[[searchText substringToIndex:1] lowercaseString];
        
        //设置搜索条件
        if ([EX_arrSection containsObject: strFirstLetter])
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
    [_optionView.tableViewPeople reloadData];
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter IN '%@'",EX_arrSection[indexPath.section]];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:strPre];
    NSArray * results = [_arrAllLink filteredArrayUsingPredicate: predicate];
    
    NSObject * obj;
    if (_optionView.searchBar.text.length!=0&&isSearching) {
        obj =_arrSeaPeople[indexPath.row];
    }else{
        obj =[results objectAtIndex:indexPath.row];
    }
    
    /*********/
    for (UIView * view in tableView.visibleCells) {
        if (view.tag ==(indexPath.section+1)*10000+indexPath.row) {
            AddChatPeoplesCell *cell =(AddChatPeoplesCell *)view;
            if ([_arrOption containsObject:obj]) {
                [_arrOption removeObject:obj];
                [cell.imageViewAdd setImage:[UIImage imageNamed:@"btn_uncheck"]];
            }
            else{
                [_arrOption addObject:obj];
                [cell.imageViewAdd setImage:[UIImage imageNamed:@"btn_check"]];
            }
        }
    }
    /********/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//当点击搜索的时候,按钮改变为确定
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    UISearchBar *searchBar = controller.searchBar;
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        for(UIView *sub in subView.subviews){
            if([sub isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]){
                UIButton *b=(UIButton *)sub;
                [b setTitle:@"确定" forState:UIControlStateNormal];
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    [self filteredListContentForSearchText:searchString scope:
     [[self.optionView.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:[self.optionView.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //一旦Scope Button有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    [self filteredListContentForSearchText:[self.optionView.searchDisplayController.searchBar text] scope:
     [[self.optionView.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:searchOption]];
    return YES;
}


//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBar:_optionView.searchBar textDidChange:nil];
    [_optionView.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_optionView.searchBar textDidChange:nil];
    isSearching=NO;
    [_optionView.tableViewPeople reloadData];
    [_optionView.searchBar resignFirstResponder];
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([self.optionView.tableViewPeople numberOfSections] > index && index > -1){   // for safety, should always be YES
        [self.optionView.tableViewPeople scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                                             atScrollPosition:UITableViewScrollPositionTop
                                                     animated:YES];
    }
}

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.optionView.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}




- (PeopelInfo *)getPeopleInfoFromUserInfo{
    PeopelInfo *Info =[PeopelInfo new];
    Info.userID =user.userid;
    Info.Name=user.username;
    Info.tel =user.msisdn;
    Info.letter=user.msisdn;
    Info.headPath=user.headurl;
    Info.eccode=user.eccode;
    return Info;
}

@end
