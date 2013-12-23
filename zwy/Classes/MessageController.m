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

@implementation MessageController{

}

-(id)init{
    self=[super init];
    if(self){
        NSString *strSelfID =[NSString stringWithFormat:@"%@%@",user.msisdn,user.eccode];
        _arrSession= [[NSMutableArray alloc]initWithArray:[[CoreDataManageContext new] getSessionListWithSelfID:strSelfID]];
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    SessionEntity * sessionInfo=_arrSession[indexPath.row];
    cell.title.text=sessionInfo.session_receivername;
    cell.content.text=sessionInfo.session_content;
    cell.time.text=[dateFormatter stringFromDate:sessionInfo.session_times];
    [HTTPRequest imageWithURL:sessionInfo.session_receiveravatar imageView:cell.imageMark placeholderImage:[UIImage  imageNamed:@"default_avatar"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UISearchDisplayDelegate
- (void)filteredListContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{

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
@end
