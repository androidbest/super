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
@implementation MailAddressController{
    NSString *searchTextContext;
    NSString*peopleNotifinfo;
    NSMutableArray *arrSuperPeople;
    int peoplePages;
    BOOL  isUpdata;
    PeopleDedaInfo *peopleInfo;
}
- (id)init{
    self=[super init];
    if (self) {
        peopleNotifinfo=@"peopleNotifinfo";
        isUpdata=NO;
        peoplePages=1;
        peopleInfo =[PeopleDedaInfo new];
        self.allPeople =[[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePeopleData:)
                                                    name:peopleNotifinfo
                                                  object:self];
    }
    return self;
}

/*人员*/
- (void)handlePeopleData:(NSNotification *)notification{
    if (isUpdata) {
        [_allPeople removeAllObjects];
        isUpdata=NO;
    }
    if (!_mailView.tableViewPeople.separatorStyle) _mailView.tableViewPeople.separatorStyle=YES;
    NSDictionary*dic =[notification userInfo];
    GroupsInfo *info =[AnalysisData getGroupmember:dic];
    if (info.AllGroupmembers.count!=0&&_allPeople.count<info.rowCount) {
        [_allPeople addObjectsFromArray:info.AllGroupmembers];
    }
    if (_allPeople.count>=info.rowCount) {
        _mailView.tableViewPeople.reachedTheEnd=NO;
    }else{
    _mailView.tableViewPeople.reachedTheEnd=YES;
    }
    [_mailView.tableViewPeople reloadDataPull];
}

/*确认按钮*/
- (void)btnAffirm{
    [_mailView.MailAddressDelegate returnDidAddress:peopleInfo];
    [self.mailView.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *strCell =@"Cell";
    MailAddressCell * cell =(MailAddressCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[MailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    PeopleDedaInfo *info =_allPeople[indexPath.row];
    if ([info.userTel isEqualToString:peopleInfo.userTel]) {
        cell.imageCheckView.image =[UIImage imageNamed:@"btn_check"];
    }else{
        cell.imageCheckView.image =[UIImage imageNamed:@"btn_uncheck"];
    }
    cell.labelText.text=info.userName;
    cell.tag=indexPath.row;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleDedaInfo *obj =_allPeople[indexPath.row];
    for (UIView * view in tableView.visibleCells) {
        MailAddressCell *cell=(MailAddressCell *)view;
        if (view.tag ==indexPath.row) {
            peopleInfo =[PeopleDedaInfo new];
            peopleInfo=obj;
            cell.imageCheckView.image=[UIImage imageNamed:@"btn_check"];
        }else{
           cell.imageCheckView.image =[UIImage imageNamed:@"btn_uncheck"];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PullRefreshDelegate
/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    peoplePages=1;
    isUpdata=YES;
    [packageData getGroupmember:self groupID:@"0" pages:[NSString stringWithFormat:@"%d",peoplePages] Type:@"1" condition:@"" SELType:peopleNotifinfo];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    peoplePages++;
    [packageData getGroupmember:self groupID:@"0" pages:[NSString stringWithFormat:@"%d",peoplePages] Type:@"1" condition:@"" SELType:peopleNotifinfo];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mailView.tableViewPeople scrollViewDidPullScroll:scrollView];
}

#pragma mark - UISearchBarDelegate
//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText) {
        searchTextContext=searchText;
    }
    if (searchText.length==0&&arrSuperPeople) {
        [_allPeople removeAllObjects];
        _allPeople=NULL;
        _allPeople =[[NSMutableArray alloc] initWithArray:arrSuperPeople];
        arrSuperPeople=NULL;
        _mailView.tableViewPeople.reachedTheEnd=YES;
        [_mailView.tableViewPeople reloadDataPull];
    }
}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    arrSuperPeople=[NSMutableArray arrayWithArray:_allPeople];
    isUpdata=YES;
    BOOL isInt=[self isPureInt:searchTextContext];
    if (isInt) {
    [packageData getGroupmember:self groupID:searchTextContext pages:@"1" Type:@"1" condition:@"" SELType:peopleNotifinfo];
    }else{
    [packageData getGroupmember:self groupID:@"0" pages:@"1" Type:@"1" condition:searchTextContext SELType:peopleNotifinfo];
    }
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
