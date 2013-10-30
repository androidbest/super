//
//  GroupAddressController.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-9.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "GroupAddressController.h"
#import "ZipArchive.h"
#import "PeopelInfo.h"
#import "GroupInfo.h"
#import "InfoDetailsView.h"
#import "Constants.h"
#import "ConfigFile.h"

@implementation GroupAddressController{
    NSArray * arrLetter;
    NSArray * arrNumber;
    GroupInfo *groupA;
    BOOL isFirstPages;
}

//获取URL
+ (NSString *)urlByConfigFile{
    NSString * strPath =[[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
    NSString *strUrl =dic[@"httpurl"];
    return strUrl;
}

#pragma mark - 初始化
- (void)initWithData{
    [ConfigFile pathECGroups];
    
    NSString * str =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.eccode,@"group.txt"];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    if (!strGroup) {
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        NSString *strECpath =[NSString stringWithFormat:@"%@.zip",user.eccode];
        NSString * strPath =[DocumentsDirectory stringByAppendingPathComponent:strECpath];
        [zipFile UnzipOpenFile:strPath];
        
        //压缩包释放到的位置，需要一个完整路径
        [zipFile UnzipFileTo:[DocumentsDirectory stringByAppendingPathComponent:user.eccode]overWrite:YES];
        [zipFile UnzipCloseFile];
    }
    
    
    /*获取所有人员信息*/
    _arrAllPeople = [ConfigFile setAllPeopleInfo:str];
    
    if(_arrAllPeople.count==0){
        [ToolUtils alertInfo:@"请同步通讯录"];
    }
    
    NSString * strSearchbar;
    strSearchbar =[NSString stringWithFormat:@"SELF.superID == '%@'",@"0"];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
    self.arrFirstGroup=[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
}

- (id)init{
    self =[super init];
    if (self) {
        groupA=Nil;
        isFirstPages=YES;
        self.arrAllPeople =[[NSMutableArray alloc] init];
        self.arrSeaPeople =[[NSArray alloc] init];
        self.arrFirstGroup =[[NSArray alloc] init];
        arrLetter =@[@"a",@"b",@"c",@"d",@"e",@"f",
                     @"g",@"h",@"i",@"j",@"k",@"l",
                     @"m",@"n",@"o",@"p",@"q",@"r",
                     @"s",@"t",@"u",@"v",@"w",@"x",
                     @"y",@"z"];
        
        arrNumber =@[@"0",@"1",@"2",@"3",@"4",
                     @"5",@"6",@"7",@"8",@"9"];
        
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
        //更新通讯录列表
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(DownLoadAddressReturn:)
                                                    name:wnLoadAddress
                                                  object:self];
          }
    
    return self;
}


#pragma mark - 数据借口回调
/*检查是否需要更新*/
- (void)rightDown{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.grougView.navigationController.view];
	[self.grougView.navigationController.view addSubview:self.HUD];
	self.HUD.labelText = @"检查更新";
	// Set determinate bar mode
	self.HUD.delegate = self;
    [self.HUD show:YES];
    
    /*检查 是否有更新过*/
    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
    NSString *histroyDate=(NSString *)[userDefaults objectForKey:@"date"];
    if (!histroyDate) {
        NSTimeInterval time_=[[NSDate date] timeIntervalSince1970]/1000;
        NSString *strTime =[NSString  stringWithFormat:@"%f",time_];
        strTime =[[strTime componentsSeparatedByString:@"."] firstObject];
        [userDefaults setObject:strTime forKey:@"date"];
        [userDefaults synchronize];
        histroyDate=@"0";
    }
    [packageData updateAddressBook:self updatetime:histroyDate];
}

//检查回调
- (void)handleData:(NSNotification *)notification{
    NSDictionary * dic=[notification userInfo];
    RespInfo *info =[AnalysisData addressUpdataInfo:dic];
    /**/
    UIImageView *imageView;
    UIImage *image;
    image= [UIImage imageNamed:@"37x-Checkmark.png"];
    imageView = [[UIImageView alloc] initWithImage:image];
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
    /**/
    
    if ([info.respCode isEqualToString:@"1"]) {
        [self DownLoadAddress:info.respMsg];
    }else if ([info.respCode isEqualToString:@"-1"]){
        self.HUD.labelText = @"无需同步";
        [self.HUD hide:YES afterDelay:1];
    }else{
        self.HUD.labelText = @"无需同步";
        [self.HUD hide:YES afterDelay:1];
    }
    
}

//开始下载
- (void)DownLoadAddress:(NSString *)strPath{
    
    self.HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.HUD.labelText = @"同步中...";
    NSString *strFileName =[NSString stringWithFormat:@"%@.zip",user.eccode];
    NSString * filePath =[DocumentsDirectory stringByAppendingPathComponent:strFileName];
    NSString *str=[GroupAddressController urlByConfigFile];
    NSString * strUrl =[NSString stringWithFormat:@"%@tmp/%@.zip?eccode=%@",str,user.eccode,user.eccode];
    [HTTPRequest LoadDownFile:self URL:strUrl filePath:filePath HUD:self.HUD];
}


//更新完毕回调
- (void)DownLoadAddressReturn:(NSNotification *)notification{
    NSDictionary*dic =[notification userInfo];
    UIImageView *imageView;
    UIImage *image ;
    if([dic[@"respCode"]  isEqualToString:@"0"]){
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"更新完毕";
    }
    else {
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
         self.HUD.labelText = @"更新失败";
    }
        imageView = [[UIImageView alloc] initWithImage:image];
    
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
	
    [self.HUD hide:YES afterDelay:1];
    
    /*刷新数据*/
    [self initWithData];
    [self.grougView.tableViewGroup reloadData];
}

#pragma mark - stroyboard传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

#pragma mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFirstPages&&_grougView.searchBar.text.length==0) {
        return _arrFirstGroup.count;
    }else{
        return _arrSeaPeople.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellINdenfer =@"Cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:CellINdenfer];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellINdenfer];
    }
    
    NSObject * obj;
    if (isFirstPages&&_grougView.searchBar.text.length==0) {
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
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject * obj;
    if (isFirstPages&&_grougView.searchBar.text.length==0) {
        obj =[_arrFirstGroup objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
    
    
    if ([obj  isKindOfClass:[GroupInfo class]]) {
        /*跳到下一级*/
        [self pushSubView:(GroupInfo *)obj];
        groupA=(GroupInfo *)obj;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        InfoDetailsView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"InfoDetailsView"];
        [self.grougView.navigationController pushViewController:detaView animated:YES];
        detaView.infoDeta=(PeopelInfo *)obj;
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
    [ToolUtils TableViewPullDownAnimation:self.grougView.tableViewGroup PathAnimationType:1];
    [_grougView.tableViewGroup reloadData];
    _grougView.tableViewGroup.contentOffset=CGPointMake(0, 0);
}

//返回上一级
- (void)LeftDown{
    if (!groupA) {
        [self.grougView.tabBarController.navigationController popViewControllerAnimated:YES];
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
    [ToolUtils TableViewPullDownAnimation:self.grougView.tableViewGroup PathAnimationType:0];
    [self searchBar:_grougView.searchBar textDidChange:nil];
    self.grougView.searchBar.text=nil;
    [_grougView.searchBar resignFirstResponder];
    [_grougView.tableViewGroup reloadData];
    
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
        [_grougView.tableViewGroup reloadData];
}

//点击搜索按钮
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBar:_grougView.searchBar textDidChange:nil];
    [_grougView.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:_grougView.searchBar textDidChange:nil];
    [_grougView.searchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [_grougView.searchBar resignFirstResponder];
}

@end
