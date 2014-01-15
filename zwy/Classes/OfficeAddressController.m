//
//  OfficeAddressController.m
//  zwy
//
//  Created by cqsxit on 13-10-20.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "OfficeAddressController.h"
#import "GroupsInfo.h"
#import "GroupDetaInfo.h"
#import "PeopleDedaInfo.h"
#import "optionCell.h"

@implementation OfficeAddressController
{
    NSIndexPath *indexPathSheet;
    NSString* groupNotifinfo;
    NSString*peopleNotifinfo;
    NSString * searchTextContext;
    NSMutableArray *allOptionID;
    NSString * groupID;
    int groupPages;
    int peoplePages;
    BOOL isGroupUpdata;
    BOOL isPeopleUpdata;
    BOOL isFirstUpdata;
}

- (id)init{
    self =[super init];
    if (self) {
        groupNotifinfo=@"groupNotifinfo";
        peopleNotifinfo=@"peopleNotifinfo";
        self.arrOption =[[NSMutableArray alloc] init];
        self.arrAllGroup =[[NSMutableArray alloc] init];
        self.arrAllPeople=[[NSMutableArray alloc] init];
        self.arrSuperGroup =[[NSMutableArray alloc] init];
        self.arrSuperPeople =[[NSMutableArray alloc] init];
        allOptionID =[[NSMutableArray alloc] init];
        isGroupUpdata=NO;
        isPeopleUpdata=NO;
        isFirstUpdata=YES;
        groupPages=1;
        peoplePages=1;
        groupID=@"0";
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleGroupData:)
                                                    name:groupNotifinfo
                                                  object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePeopleData:)
                                                    name:peopleNotifinfo
                                                  object:self];
        
    }
    return self;
}

//处理网络数据
/*部门*/
-(void)handleGroupData:(NSNotification *)notification{
    NSDictionary*dic =[notification userInfo];
    if (isGroupUpdata) {
        _arrAllGroup =NULL;
        _arrAllGroup =[[NSMutableArray alloc] init];
        isGroupUpdata=NO;
    }
    
    GroupsInfo *info =[AnalysisData getGroups:dic];
    if (info.AllGroups.count!=0&&_arrAllGroup.count<info.rowCount)[_arrAllGroup addObjectsFromArray:info.AllGroups];
    
    if (info.AllGroups.count==0||_arrAllGroup.count>=info.rowCount) {
       _officeView.tableViewGroup.reachedTheEnd=NO;
    }else{
        _officeView.tableViewGroup.reachedTheEnd=YES;
    }
    
    if (!_officeView.tableViewGroup.separatorStyle) {
        _officeView.tableViewGroup.separatorStyle=YES;
    }
    [self.officeView.tableViewGroup reloadDataPull];
}

/*人员*/
- (void)handlePeopleData:(NSNotification *)notification{
    if (isPeopleUpdata) {
        _arrAllPeople =NULL;
        _arrAllPeople=[[NSMutableArray alloc] init];
        isPeopleUpdata=NO;
    }
    
    NSDictionary*dic =[notification userInfo];
    GroupsInfo *info =[AnalysisData getGroupmember:dic];
    if (info.AllGroupmembers.count!=0&&_arrAllPeople.count<info.rowCount)[_arrAllPeople addObjectsFromArray:info.AllGroupmembers];
    
    if (info.AllGroupmembers.count==0||_arrAllPeople.count>=info.rowCount) {
         _officeView.tableViewPeople.reachedTheEnd=NO;
    }else{
        _officeView.tableViewPeople.reachedTheEnd=YES;
    }
    
    if (!_officeView.tableViewPeople.separatorStyle) {
        _officeView.tableViewPeople.separatorStyle=YES;
    }
    
    [self.officeView.tableViewPeople reloadDataPull];
}

#pragma mark - 按钮实现方法
/*全选*/
- (void)btnAll{
    if (!_officeView.tableViewGroup.hidden) {
        for (UIView * view in self.officeView.tableViewGroup.visibleCells) {
            optionCell *cell =(optionCell *)view;
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        
        GroupDetaInfo*info;
        for (int i=0; i<_arrAllGroup.count;i++ ) {
            info=_arrAllGroup[i];
            if (![_arrOption containsObject:info])[_arrOption addObject:info];
        }
        
    }else{
        for (UIView * view in self.officeView.tableViewPeople.visibleCells) {
            optionCell *cell =(optionCell *)view;
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        
        PeopleDedaInfo *info;
        for (int i=0; i<_arrAllPeople.count; i++) {
            info=_arrAllPeople[i];
            
            if (![allOptionID containsObject:info.userTel]){
                [allOptionID addObject:info.userTel];
                [_arrOption addObject:info];
            
            }
        }
    }

}

/*清空*/
- (void)btnCencel{
    [_arrOption removeAllObjects];
    [allOptionID removeAllObjects];
    
    if (!_officeView.tableViewGroup.hidden) {
        for (UIView * view in self.officeView.tableViewGroup.visibleCells) {
            optionCell *cell =(optionCell *)view;
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        
    }else{
        for (UIView * view in self.officeView.tableViewPeople.visibleCells) {
            optionCell *cell =(optionCell *)view;
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        
    }
    [_officeView.tableViewGroup  reloadDataPull];
    [_officeView.tableViewPeople  reloadDataPull];
}

/*确认选择*/
- (void)btnConfirmation{
    [self.officeView.navigationController popViewControllerAnimated:YES];
    [self.officeView.officeDelegate returnDidAddress:_arrOption];
}

/*返回上一级*/
- (void)btnSuperior{
    if (!_officeView.tableViewGroup.hidden&&_arrSuperGroup.count!=0) {
        _arrAllGroup=NULL;
        self.arrAllGroup =[NSMutableArray arrayWithArray:_arrSuperGroup[_arrSuperGroup.count-1][@"count"]];
        groupID=_arrSuperGroup[_arrSuperGroup.count-1][@"groupID"];
        [_arrSuperGroup removeObjectAtIndex:_arrSuperGroup.count-1];
        
        if (_arrSuperGroup.count==0){
            _officeView.btnSuperior.enabled=NO;
            groupID =@"0";
        }
        _officeView.tableViewGroup.reachedTheEnd=YES;
        [_officeView.tableViewGroup reloadDataPull];
        
    }else if(!_officeView.tableViewPeople.hidden &&_arrSuperPeople.count!=0){
        _arrAllPeople=NULL;
        self.arrAllPeople =[NSMutableArray arrayWithArray:_arrSuperPeople[_arrSuperPeople.count-1][@"count"]];
        groupID=_arrSuperPeople[_arrSuperPeople.count-1][@"groupID"];
        [_arrSuperPeople removeObjectAtIndex:_arrSuperPeople.count-1];
        
        if (_arrSuperPeople.count==0){
            _officeView.btnSuperior.enabled=NO;
            groupID =@"0";
        }
        _officeView.tableViewPeople.reachedTheEnd=YES;
        [_officeView.tableViewPeople reloadDataPull];
    }
}

/*选择人员*/
- (void)btnOption:(id)sender{
    if (!_officeView.tableViewGroup.hidden) {
        GroupDetaInfo * info =_arrAllGroup[[(UIButton *)sender tag]];
        if ([allOptionID containsObject:info.groupId]) {
            [allOptionID removeObject:info.groupId];
            [_arrOption removeObject:info];
             [(UIButton *)sender setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
        }else{
            [allOptionID addObject:info.groupId];
            [_arrOption  addObject:info];
             [(UIButton *)sender setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        
        
    }else{
    PeopleDedaInfo* info =_arrAllPeople[[(UIButton *)sender tag]];
        if ([allOptionID containsObject:info.userTel]) {
            [allOptionID removeObject:info.userTel];
            [_arrOption removeObject:info];
             [(UIButton *)sender setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
        }else{
            [allOptionID addObject:info.userTel];
            [_arrOption  addObject:info];
             [(UIButton *)sender setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        
    }

}

#pragma mark -UISegmentedControl
-(void)segmentedControl:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    if (Index==0){
        _officeView.tableViewGroup.hidden=NO;
        _officeView.tableViewPeople.hidden=YES;
        
        if (_arrSuperGroup.count==0)_officeView.btnSuperior.enabled=NO;
        else  _officeView.btnSuperior.enabled=YES;
        
    }else{
        if (_arrSuperPeople.count==0)_officeView.btnSuperior.enabled=NO;
        else  _officeView.btnSuperior.enabled=YES;
        _officeView.tableViewGroup.hidden=YES;
        _officeView.tableViewPeople.hidden=NO;
    }
}

#pragma  mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==0) {
        return _arrAllGroup.count;
    }else {
        return _arrAllPeople.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        static NSString *strCell =@"groupCell";
        optionCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
        if (!cell) {
            cell =[[optionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell withDelegate:self];
            cell.textLabel.font =[UIFont boldSystemFontOfSize:16];
        }
        GroupDetaInfo * info =_arrAllGroup[indexPath.row];
        
        /**/
        if ([_arrOption containsObject:info]) {
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        else{
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
        }
        /**/
        
        cell.textLabel.text =info.groupName;
        cell.tag=indexPath.row;
        cell.btnOption.tag=indexPath.row;
        return cell;
    }else{
        static NSString *strCell =@"peopleCell";
        optionCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
        if (!cell) {
             cell =[[optionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell withDelegate:self];
        }
        PeopleDedaInfo *info =_arrAllPeople[indexPath.row];
        
        /**/
        if ([allOptionID containsObject:info.userTel]) {
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
        }
        else{
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
        }
        /**/
        
        cell.textLabel.text =info.userName;
        cell.tag=indexPath.row;
        cell.btnOption.tag=indexPath.row;
        return cell;
    }

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        indexPathSheet=indexPath;
        UIActionSheet * sheet =[[UIActionSheet alloc] initWithTitle:@"选择"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"查看部门",@"查看人员", nil];
        [sheet showInView:self.officeView.navigationController.view];
    }else{
        /*********/
        PeopleDedaInfo *obj =_arrAllPeople[indexPath.row];
        for (UIView * view in tableView.visibleCells) {
            if (view.tag ==indexPath.row) {
                optionCell *cell =(optionCell *)view;
                if ([allOptionID containsObject:obj.userTel]) {
                    [_arrOption removeObject:obj];
                    [allOptionID removeObject:obj.userTel];
                    [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
                }
                else{
                    [_arrOption addObject:obj];
                    [allOptionID addObject:obj.userTel];
                    [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
                }
            }
        }
        /********/
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    GroupDetaInfo *info =_arrAllGroup[indexPathSheet.row];
    if (buttonIndex==0) {
        NSArray * arr =[NSArray arrayWithArray:_arrAllGroup];
        NSDictionary *dic =@{@"count":arr,@"groupID":groupID};
        groupID=info.groupId;
        if (arr.count!=0) [self.arrSuperGroup addObject:dic];
        _arrAllGroup=NULL;
        self.arrAllGroup=[[NSMutableArray alloc] init];
        /**/
        
        _officeView.tableViewGroup.separatorStyle=NO;
        [packageData getGroups:self groupID:info.groupId pages:@"1" groupName:@"" SELType:groupNotifinfo];
        [_officeView.tableViewGroup reloadDataPull];
        [_officeView.tableViewGroup.centerActivity startAnimating];
        _officeView.tableViewGroup.labelUpdata.hidden=NO;
        /**/
    }else if(buttonIndex==1){
        NSArray *arr =[NSArray arrayWithArray:_arrAllPeople];
        NSDictionary *dic =@{@"count":arr,@"groupID":groupID};
        groupID=info.groupId;
        if (arr.count!=0) [self.arrSuperPeople addObject:dic];
        _arrAllPeople=NULL;
        self.arrAllPeople=[[NSMutableArray alloc] init];
        /**/
        _officeView.tableViewGroup.hidden=YES;
        _officeView.tableViewPeople.hidden=NO;
        _officeView.tableViewPeople.separatorStyle=NO;
        [packageData getGroupmember:self groupID:info.groupId pages:@"1" Type:@"1" condition:@"" SELType:peopleNotifinfo];
        [_officeView.tableViewPeople reloadDataPull];
        [_officeView.tableViewPeople.centerActivity startAnimating];
        _officeView.tableViewPeople.labelUpdata.hidden=NO;
        /**/
        _officeView.segmentedControl.selectedSegmentIndex=1;
        [self segmentedControl:_officeView.segmentedControl];
    }
    _officeView.btnSuperior.enabled=YES;
}

#pragma mark - PullRefreshDelegate
/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    if (tableView.tag==0) {
        groupPages=1;
        isGroupUpdata=YES;
        groupID=@"0";
        [_arrSuperGroup removeAllObjects];
        [packageData getGroups:self groupID:@"0" pages:@"1" groupName:@"" SELType:groupNotifinfo];
    }else{
        peoplePages=1;
        isPeopleUpdata=YES;
        groupID=@"0";
        [_arrSuperPeople removeAllObjects];
        [packageData getGroupmember:self groupID:@"0" pages:@"1" Type:@"1" condition:@"" SELType:peopleNotifinfo];
    }
   
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    if (tableView.tag==0) {
        groupPages++;
        [packageData getGroups:self groupID:groupID pages:[NSString stringWithFormat:@"%d",groupPages] groupName:@"" SELType:groupNotifinfo];
    }else{
        peoplePages++;
        [packageData getGroupmember:self groupID:groupID pages:[NSString stringWithFormat:@"%d",peoplePages] Type:@"1" condition:@"" SELType:peopleNotifinfo];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag==0) {
        [self.officeView.tableViewGroup scrollViewDidPullScroll:scrollView];
    }else{
    [self.officeView.tableViewPeople scrollViewDidPullScroll:scrollView];
    }
    
}

#pragma mark - UISearchBarDelegate
//输入搜索内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText) {
        searchTextContext=searchText;
    }
}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (!_officeView.tableViewGroup.hidden) {
        NSArray * arr =[NSArray arrayWithArray:_arrAllGroup];
        NSDictionary *dic =@{@"count":arr,@"groupID":groupID};
        groupID=@"0";
        if (arr.count!=0)[self.arrSuperGroup addObject:dic];
        _arrAllGroup=NULL;
        _arrAllGroup=[[NSMutableArray alloc] init];
        /**/
        
        _officeView.tableViewGroup.separatorStyle=NO;
         BOOL isInt=[self isPureInt:searchTextContext];
        if (isInt) {
           [packageData getGroups:self groupID:searchTextContext pages:@"1" groupName:@"" SELType:groupNotifinfo];
        }else{
        [packageData getGroups:self groupID:@"0" pages:@"1" groupName:searchTextContext SELType:groupNotifinfo];
        }
        
        [_officeView.tableViewGroup reloadDataPull];
        [_officeView.tableViewGroup.centerActivity startAnimating];
        _officeView.tableViewGroup.labelUpdata.hidden=NO;
        /**/
    }else if(_officeView.tableViewGroup.hidden){
        NSArray *arr =[NSArray arrayWithArray:_arrAllPeople];
        NSDictionary *dic =@{@"count":arr,@"groupID":groupID};
        groupID=@"0";
        if (arr.count!=0)[self.arrSuperPeople addObject:dic];
        _arrAllPeople=NULL;
        _arrAllPeople=[[NSMutableArray alloc] init];
        /**/
        _officeView.tableViewGroup.hidden=YES;
        _officeView.tableViewPeople.hidden=NO;
        _officeView.tableViewPeople.separatorStyle=NO;
        
        BOOL isInt=[self isPureInt:searchTextContext];
        if (isInt) {
           [packageData getGroupmember:self groupID:searchTextContext pages:@"1" Type:@"1" condition:@"" SELType:peopleNotifinfo];
        }else{
        [packageData getGroupmember:self groupID:@"0" pages:@"1" Type:@"1" condition:searchTextContext SELType:peopleNotifinfo];
        }
        
        [_officeView.tableViewPeople reloadDataPull];
        [_officeView.tableViewPeople.centerActivity startAnimating];
        _officeView.tableViewPeople.labelUpdata.hidden=NO;
        /**/
        _officeView.segmentedControl.selectedSegmentIndex=1;
        [self segmentedControl:_officeView.segmentedControl];
    }
    _officeView.btnSuperior.enabled=YES;
    
    
    [self searchBar:_officeView.searchBar textDidChange:nil];
    [_officeView.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_officeView.searchBar textDidChange:nil];
    [_officeView.searchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_officeView.searchBar resignFirstResponder];
}

/*判断是否为数字*/
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
@end
