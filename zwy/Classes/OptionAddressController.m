//
//  OptionAddressController.m
//  zwy
//
//  Created by cqsxit on 13-10-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "OptionAddressController.h"
#import "GroupInfo.h"
#import "PeopelInfo.h"
#import "optionCell.h"
#import "MassTextingController.h"

@implementation OptionAddressController
{
    NSArray * arrLetter;
    NSArray * arrNumber;
    GroupInfo *groupA;
    BOOL isFirstPages;
}

- (id)init{
    self =[super init];
    if (self) {
        arrLetter =@[@"a",@"b",@"c",@"d",@"e",@"f",
                     @"g",@"h",@"i",@"j",@"k",@"l",
                     @"m",@"n",@"o",@"p",@"q",@"r",
                     @"s",@"t",@"u",@"v",@"w",@"x",
                     @"y",@"z"];
        
        arrNumber = @[@"0",@"1",@"2",@"3",@"4",
                      @"5",@"6",@"7",@"8",@"9"];
        
      
    }
    return self;
}

- (void)initWithData{
    groupA=Nil;
    isFirstPages=YES;
    self.arrAllPeople =[[NSMutableArray alloc] init];
    _arrSeaPeople =[[NSArray alloc] init];
    _arrFirstGroup =[[NSArray alloc] init];
    self.arrOption=[[NSMutableArray alloc] init];
    
    /*通讯录所有信息*/
    NSString * strPath;
    if (_OptionView.isECMember)strPath =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"ecgroup.txt"];
    else  strPath = [NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    if ((_arrAllPeople.count==0||!_arrAllPeople)&&!blHave) {
        [self showHUDText:@"请同步通讯录" showTime:1.0];
        return;
    } 
    
    _HUD_Group = [MBProgressHUD showHUDAddedTo:self.OptionView.view animated:YES];
    _HUD_Group.labelText =@"加载中...";
    _HUD_Group.margin = 10.f;
    _HUD_Group.removeFromSuperViewOnHide = YES;
    [_HUD_Group show:YES];
    /*获取所有人员信息*/
    __block NSArray *blockArr;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blockArr= [ConfigFile setAllPeopleInfo:strPath isECMember:_OptionView.isECMember];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _arrAllPeople =[[NSMutableArray alloc] initWithArray:blockArr];
            NSString * strSearchbar;
            strSearchbar =[NSString stringWithFormat:@"SELF.superID == '%@'",@"0"];
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
            self.arrFirstGroup=[_arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
            [_OptionView.tableViewAddress reloadData];
            [_HUD_Group hide:YES];
        });
        
    });
}

#pragma mark - 按钮实现方法
/*全选*/
- (void)btnAll:(id)sender{
    for (UIView * view in self.OptionView.tableViewAddress.visibleCells) {
            optionCell *cell =(optionCell *)view;
            [cell.btnOption setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    }
    
     NSObject * obj;
    if (isFirstPages&&_OptionView.searchBar.text.length==0){
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
    for (UIView * view in self.OptionView.tableViewAddress.visibleCells) {
        optionCell *cell =(optionCell *)view;
        [cell.btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    [_arrOption removeAllObjects];
}

/*确认*/
- (void)btnConfirm:(id)sender{
    [self.OptionView.navigationController popViewControllerAnimated:YES];
    [self.OptionView.optionDelegate returnDidAddress:_arrOption];
}

/*返回*/
- (void)btnReturn:(id)sender{
     [self.OptionView.navigationController popViewControllerAnimated:YES];
}

/*选择人员*/
- (void)btnOption:(id)sender{
    NSObject * obj;
    UIButton * btn =(UIButton *)sender;
    if (isFirstPages&&_OptionView.searchBar.text.length==0) {
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
    if (isFirstPages&&_OptionView.searchBar.text.length==0) {
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
        cell.textLabel.font =[UIFont boldSystemFontOfSize:16];
        cell.detailTextLabel.font =[UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor =[UIColor grayColor];
    }
    NSObject * obj;
    if (isFirstPages&&_OptionView.searchBar.text.length==0) {
        obj =[_arrFirstGroup objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
    
   
    if ([obj isKindOfClass:[PeopelInfo class]]) {
        cell.textLabel.text=[(PeopelInfo *)obj Name];
        cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
        cell.btnOption.hidden=NO;
    }else if([obj isKindOfClass:[GroupInfo class]]){
        cell.textLabel.text=[(GroupInfo *)obj Name];
        NSString *strDeta=[[(GroupInfo *)obj Count] stringByAppendingString:@"  位联系人"];
        strDeta=[strDeta stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        cell.detailTextLabel.text=strDeta;
        if([_OptionView.optionDelegate isKindOfClass:[MassTextingController class]])cell.btnOption.hidden=YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject * obj;
    
    if (isFirstPages&&_OptionView.searchBar.text.length==0) {
        obj =[_arrFirstGroup objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
    
    
    if ([obj  isKindOfClass:[GroupInfo class]]) {
        /*跳到下一级*/
        [self pushSubView:(GroupInfo *)obj];
        groupA=(GroupInfo *)obj;
    }else{
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
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 跳到下一级
- (void)pushSubView:(GroupInfo *)Group{
    NSString * strSearchbar;
    NSMutableArray * arr;
    strSearchbar =[NSString stringWithFormat:@"SELF.superID == '%@'",Group.groupID];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
    arr=[NSMutableArray arrayWithArray:[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate]];
    [arr removeObject:Group];
    self.arrSeaPeople=arr;
    isFirstPages=NO;
    /*刷新动画*/
    [ToolUtils TableViewPullDownAnimation:self.OptionView.tableViewAddress PathAnimationType:1];
    [_OptionView.tableViewAddress reloadData];
    _OptionView.tableViewAddress.contentOffset=CGPointMake(0, 0);
}

//返回上一级
- (void)LeftDown{
    if (!groupA) {
        if ([_OptionView.searchBar resignFirstResponder]){
            [self  performSelector:@selector(BackView) withObject:self afterDelay:0.3f];
            return;
        }
           [self  performSelector:@selector(BackView) withObject:self afterDelay:0.0f];
           return;
    }
    if ([groupA.superID isEqualToString:@"0"]||isFirstPages) {
        isFirstPages=YES;
        groupA=NULL;
        _arrSeaPeople=NULL;
        _arrSeaPeople=[[NSArray alloc] init];
    }else{
        NSString * strSearchbar;
        strSearchbar =[NSString stringWithFormat:@"SELF.superID == '%@'",groupA.superID];
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
        self.arrSeaPeople=[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
        
        
        for (GroupInfo * info in _arrAllPeople) {
            if ([info.groupID isEqualToString:groupA.superID])groupA=info;
        }
    }
    
    /*刷新动画*/
    [ToolUtils TableViewPullDownAnimation:self.OptionView.tableViewAddress PathAnimationType:0];
    [self searchBar:_OptionView.searchBar textDidChange:nil];
    self.OptionView.searchBar.text=nil;
    [_OptionView.searchBar resignFirstResponder];
    [_OptionView.tableViewAddress reloadData];
    
}

-(void)BackView{
    _arrAllPeople=nil;
    _arrSeaPeople=nil;
    _arrFirstGroup=nil;
    _arrOption=nil;
  [self.OptionView.navigationController popViewControllerAnimated:YES];
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
        if (groupA) {
            NSMutableArray *arr;
            strSearchbar =[NSString stringWithFormat:@"SELF.groupID CONTAINS '%@'",groupA.groupID];
            NSPredicate *predicate = [NSPredicate predicateWithFormat: strSearchbar];
            arr=[NSMutableArray arrayWithArray:[self.arrAllPeople filteredArrayUsingPredicate:predicate]];
            self.arrSeaPeople =[arr filteredArrayUsingPredicate: predicateTemplate];
            if (self.arrSeaPeople.count==0&&searchText.length==0){
                [arr removeObject:groupA];
                self.arrSeaPeople=arr;
            }
        }else{
            self.arrSeaPeople=[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
        }
        
    }
    [_OptionView.tableViewAddress reloadData];
}
//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBar:_OptionView.searchBar textDidChange:nil];
    [_OptionView.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_OptionView.searchBar textDidChange:nil];
    [_OptionView.searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_OptionView.searchBar resignFirstResponder];
}

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.OptionView.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}
@end
