//
//  MailAddressController.m
//  zwy
//
//  Created by cqsxit on 13-10-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MailAddressController.h"
#import "PeopleDedaInfo.h"
#import "MailAddressCell.h"
#import "PeopelInfo.h"
@implementation MailAddressController{
    NSString *searchTextContext;
    NSString*peopleNotifinfo;
    int peoplePages;
    BOOL  isUpdata;
    BOOL  isSearching;
    PeopelInfo *peopleInfo;
    NSArray *arrNumber;
}
- (id)init{
    self=[super init];
    if (self) {
        peopleNotifinfo=@"peopleNotifinfo";
        isUpdata=NO;
        isSearching=NO;
        peoplePages=1;
        peopleInfo =[PeopelInfo new];
        self.allPeople =[[NSMutableArray alloc] init];
        
        arrNumber =@[@"0",@"1",@"2",@"3",@"4",
                     @"5",@"6",@"7",@"8",@"9"];
    }
    return self;
}




/*确认按钮*/
- (void)btnAffirm{
    [_mailView.MailAddressDelegate returnDidAddress:peopleInfo];
    [self.mailView.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_mailView.serchBar.text.length!=0&&isSearching)return _arrSeaPeople.count;
    return EX_arrGroupAddressBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *strCell =@"Cell";
    MailAddressCell * cell =(MailAddressCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[MailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    
    BOOL isSearchBar=_mailView.serchBar.text.length!=0&&isSearching;
    PeopelInfo *info=isSearchBar? _arrSeaPeople[indexPath.row]:EX_arrGroupAddressBooks[indexPath.row];
    
    if ([info.tel isEqualToString:peopleInfo.tel]) {
        cell.imageCheckView.image =[UIImage imageNamed:@"btn_check"];
    }else{
        cell.imageCheckView.image =[UIImage imageNamed:@"btn_uncheck"];
    }
    cell.labelText.text=info.Name;
    cell.tag=indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopelInfo *obj =EX_arrGroupAddressBooks[indexPath.row];
    for (UIView * view in tableView.visibleCells) {
        MailAddressCell *cell=(MailAddressCell *)view;
        if (view.tag ==indexPath.row) {
            peopleInfo =[PeopelInfo new];
            peopleInfo=obj;
            cell.imageCheckView.image=[UIImage imageNamed:@"btn_check"];
        }else{
           cell.imageCheckView.image =[UIImage imageNamed:@"btn_uncheck"];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate
//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
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
        self.arrSeaPeople=[EX_arrGroupAddressBooks filteredArrayUsingPredicate: predicateTemplate];
    }else {
        isSearching=NO;
    }
    [_mailView.tableViewPeople reloadData];
}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   [_mailView.serchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_mailView.serchBar textDidChange:nil];
    [_mailView.serchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_mailView.serchBar resignFirstResponder];
}

/*判断是否为数字*/
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
