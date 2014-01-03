//
//  MessageController.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MessageController.h"
#import "MesaageIMCell.h"
#import "CoreDataManageContext.h"
#import "SessionEntity.h"
#import "PeopelInfo.h"
#import "OptionChatPeopleView.h"
#import "ChatMessageView.h"
#import "CoreDataManageContext.h"
@implementation MessageController{
    NSArray *arrLetter;
    NSArray *arrNumber;
    BOOL  isSearching;
}

-(id)init{
    self=[super init];
    if(self){
        arrLetter =[NSMutableArray arrayWithObjects:
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

#pragma mark -接收聊天新消息，更新表单
/*
 *通告中心为"HomeController"
 */
- (void)getMessage:(NSNotification *)notification{
    NSString *strSelfID =[NSString stringWithFormat:@"%@%@",user.msisdn,user.eccode];
    _arrSession = [[NSMutableArray alloc]initWithArray:[[CoreDataManageContext newInstance] getSessionListWithSelfID:strSelfID]];
    [_messageView.uitableview reloadData];
}
//添加聊天
- (void)btnAddPeople
{
    [self.messageView performSegueWithIdentifier:@"MessageViewToOptionChatView" sender:self.messageView];
}

- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MessageViewToOptionChatView"]) {
        UINavigationController *navigation =segue.destinationViewController;
        OptionChatPeopleView *optionView=(OptionChatPeopleView*)navigation.topViewController;
        optionView.OptionChatPeopleDelegate=self;
    }else if ([segue.identifier isEqualToString:@"msgtochat"]){
        ChatMessageView *viewComtroller =segue.destinationViewController;
        if ([sender isKindOfClass:[NSArray class]]) {
           [viewComtroller.arrPeoples addObjectsFromArray:(NSArray *)sender];
        }
    }
}
#pragma mark -OptionChatPeopleDelegate
- (void)MessageViewToChatMessageView:(NSArray *)peoples{
 self.messageView.tabBarController.navigationItem.title=@"";
 [self.messageView performSegueWithIdentifier:@"msgtochat" sender:peoples];
}

#pragma mark - UITableViewDateSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_messageView.searchBar.text.length!=0&&isSearching)return _arrSeaPeople.count;
    return _arrSession.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * messageIMCell =@"messageIMCell";
    MesaageIMCell * cell =[tableView dequeueReusableCellWithIdentifier:messageIMCell];
    if (!cell) {
        cell = [[MesaageIMCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:messageIMCell];
   
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy/MM/dd HH:mm"];
    
    SessionEntity * sessionInfo=nil;
    if (_messageView.searchBar.text.length!=0&&isSearching)sessionInfo=_arrSeaPeople[indexPath.row];
    else sessionInfo=_arrSession[indexPath.row];
    
    cell.title.text=sessionInfo.session_receivername;
    if(sessionInfo.session_voicetimes&&![sessionInfo.session_voicetimes isEqualToString:@"(null)"]&&![sessionInfo.session_voicetimes isEqualToString:@"null"]&&![sessionInfo.session_voicetimes isEqualToString:@""]&&![sessionInfo.session_voicetimes isEqualToString:@"0"]){
    cell.content.text=[NSString stringWithFormat:@"%@''",sessionInfo.session_voicetimes];
    }else{
    cell.content.text=sessionInfo.session_content;
    }
    cell.time.text=[dateFormatter stringFromDate:sessionInfo.session_times];
    if ([sessionInfo.session_unreadcount isEqualToString:@"0"]) {
        cell.labelCount.hidden=YES;
    }else{
        cell.labelCount.hidden=NO;
        cell.labelCount.text=sessionInfo.session_unreadcount;
    }
//    cell.username.text=sessionInfo.session_receivername;
    NSString *url=@"";
    if(sessionInfo.session_groupuuid&&![sessionInfo.session_groupuuid isEqualToString:@"null"]&&![sessionInfo.session_groupuuid isEqualToString:@""]&&![sessionInfo.session_groupuuid isEqualToString:@"(null)"]){
        url=[sessionInfo.session_receiveravatar componentsSeparatedByString:@","][0];
    }else{
        url=sessionInfo.session_receiveravatar;
    }
    [HTTPRequest imageWithURL:url imageView:cell.imageMark placeholderImage:[UIImage  imageNamed:@"default_avatar"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SessionEntity * sessionInfo=nil;
    if (_messageView.searchBar.text.length!=0&&isSearching){
     sessionInfo=_arrSeaPeople[indexPath.row];
    }
    else{
    sessionInfo=_arrSession[indexPath.row];
    }
   
    [[CoreDataManageContext newInstance] updateWithSessionEntity:sessionInfo];
    
    PeopelInfo *info=[PeopelInfo new];
//    if(sessionInfo.session_groupuuid&&![sessionInfo.session_groupuuid isEqualToString:@"null"]&&![sessionInfo.session_groupuuid isEqualToString:@""]){
//        info.tel=sessionInfo.session_groupuuid;
//    }else{
//        info.tel=sessionInfo.session_receivermsisdn;
//    }
    info.tel=sessionInfo.session_receivermsisdn;
    info.eccode=user.eccode;
    info.headPath=sessionInfo.session_receiveravatar;
    info.imGroupid=sessionInfo.session_groupuuid;
    info.Name=sessionInfo.session_receivername;
    self.messageView.info=info;
    self.messageView.tabBarController.navigationItem.title=@"";
    [self.messageView performSegueWithIdentifier:@"msgtochat" sender:sessionInfo];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_messageView.searchBar.text.length!=0&&isSearching){
        return NO;
    }
    else{
        return YES;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionEntity * sessionInfo=nil;
    if (_messageView.searchBar.text.length!=0&&isSearching){
        sessionInfo=_arrSeaPeople[indexPath.row];
    }
    else{
        sessionInfo=_arrSession[indexPath.row];
    }
    
    CoreDataManageContext *coreText=[CoreDataManageContext newInstance];
    [coreText deleteChatInfoWithChatMessageID:sessionInfo.session_chatMessageID];
    
    [_arrSession removeObject:_arrSession[indexPath.row]];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
        if ([arrLetter containsObject: strFirstLetter])
        {
            searchText =[searchText lowercaseString];
            strSearchbar =[NSString stringWithFormat:@"SELF.session_pinyinName CONTAINS '%@'",searchText];
        }else if([arrNumber containsObject:strFirstLetter]){
            strSearchbar =[NSString stringWithFormat:@"SELF.session_receivermsisdn CONTAINS '%@'",searchText];
        }
        else{
            strSearchbar =[NSString stringWithFormat:@"SELF.session_receivername CONTAINS '%@'",searchText];
        }
        
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
        self.arrSeaPeople=[self.arrSession filteredArrayUsingPredicate: predicateTemplate];
    }else {
        isSearching=NO;
    }
    [_messageView.uitableview reloadData];

}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    [self filteredListContentForSearchText:searchString scope:
     [[self.messageView.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:[self.messageView.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //一旦Scope Button有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    [self filteredListContentForSearchText:[self.messageView.searchDisplayController.searchBar text] scope:
     [[self.messageView.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:searchOption]];
    return YES;
}

//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBar:_messageView.searchBar textDidChange:nil];
    [_messageView.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_messageView.searchBar textDidChange:nil];
    isSearching=NO;
    [_messageView.uitableview reloadData];
    [_messageView.searchBar resignFirstResponder];
}

@end
