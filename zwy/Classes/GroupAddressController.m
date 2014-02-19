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
    //已经更新的
    BOOL isReloadData;
}

//获取URL
+ (NSString *)urlByConfigFile{
    NSString * strPath =[[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
    NSString *strUrl =dic[@"httpurl"];
    return strUrl;
}

- (void)timerFired:(id)sender{
}

- (id)init{
    self =[super init];
    if (self) {
        groupA=Nil;
        isFirstPages=YES;
        isReloadData=NO;
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

#pragma mark - 初始化
- (void)initWithData{
    [ConfigFile pathECGroups];
    
    NSString * str =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    
    //1.为空 或者 2.不为空已经更新 有新的包更新，删除旧包
    if (!strGroup||isReloadData) {
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        NSString *strECpath =[NSString stringWithFormat:@"%@/%@.zip",user.msisdn,user.eccode];
        NSString * strPath =[DocumentsDirectory stringByAppendingPathComponent:strECpath];
        [zipFile UnzipOpenFile:strPath];
        
        //压缩包释放到的位置，需要一个完整路径
        NSString * strSavePath =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:strSavePath];
        if (isReloadData&&blHave)[[NSFileManager defaultManager] removeItemAtPath:strSavePath error:nil];
        [zipFile UnzipFileTo:strSavePath overWrite:YES];
        [zipFile UnzipCloseFile];
        isReloadData=NO;
    }
    
 
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:str];
    if(_grougView.arrAllPeople.count==0&&!blHave){
        [ToolUtils alertInfo:@"请同步单位通讯录" delegate:self otherBtn:@"确认"];
        return;
    }
    
    /*获取所有人员信息*/
    if (!_HUD_Group) {
        _HUD_Group = [MBProgressHUD showHUDAddedTo:self.grougView.navigationController.view animated:YES];
        _HUD_Group.labelText =@"加载中...";
        _HUD_Group.margin = 10.f;
        _HUD_Group.removeFromSuperViewOnHide = YES;
        [_HUD_Group show:YES];
    }
    
    //扫描文件，通讯录信息放入数组
    __block NSArray *blockArr;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             blockArr= [ConfigFile setAllPeopleInfo:str isECMember:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _grougView.arrAllPeople =[[NSMutableArray alloc] initWithArray:blockArr];
            NSString * strSearchbar;
            strSearchbar =[NSString stringWithFormat:@"SELF.superID == '%@'",@"0"];
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
            self.arrFirstGroup=[_grougView.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
            [_grougView.tableViewGroup reloadData];
            [_HUD_Group hide:YES];
        });
        
    });
}

//更新下载包数据
- (void)updateDownLoad{
    NSString * str =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    if (!strGroup||isReloadData) {
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        NSString *strECpath =[NSString stringWithFormat:@"%@/%@.zip",user.msisdn,user.eccode];
        NSString * strPath =[DocumentsDirectory stringByAppendingPathComponent:strECpath];
        [zipFile UnzipOpenFile:strPath];
        
        //压缩包释放到的位置，需要一个完整路径
        NSString * strSavePath =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:strSavePath];
        if (isReloadData&&blHave)[[NSFileManager defaultManager] removeItemAtPath:strSavePath error:nil];
        [zipFile UnzipFileTo:strSavePath overWrite:YES];
        [zipFile UnzipCloseFile];
        isReloadData=NO;
    }
    
    _grougView.arrAllPeople =[ConfigFile setAllPeopleInfo:str isECMember:NO];
    NSString * strSearchbar;
    strSearchbar =[NSString stringWithFormat:@"SELF.superID == '%@'",@"0"];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
    self.arrFirstGroup=[_grougView.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
    [_grougView.tableViewGroup reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        [self reloadGroupAddress];
    }
}

#pragma mark - 数据借口回调
/*检查是否需要更新*/
- (void)rightDown{
    isReloadData=YES;
    [self reloadGroupAddress];
}

- (void)reloadGroupAddress{
     [_grougView.searchBar resignFirstResponder];
    _HUD_Group = [MBProgressHUD showHUDAddedTo:self.grougView.navigationController.view animated:YES];
	[self.grougView.navigationController.view addSubview:_HUD_Group];
    _HUD_Group.removeFromSuperViewOnHide = YES;
	_HUD_Group.labelText = @"检查更新";
	// Set determinate bar mode
	_HUD_Group.delegate = self;
    [_HUD_Group show:YES];
    
    /*检查 是否有更新过*/
    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
    NSString * UserDate =[NSString stringWithFormat:@"%@%@date",user.msisdn,user.eccode];
    NSString *histroyDate=(NSString *)[userDefaults objectForKey:UserDate];
    if (!histroyDate) histroyDate=@"0";
    
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
    _HUD_Group.customView=imageView;
    _HUD_Group.mode = MBProgressHUDModeCustomView;
    /**/
    
    if ([info.respCode isEqualToString:@"1"]) {
        [self DownLoadAddress:info.respMsg];
        /*保存最后更新时间*/
        NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
        NSString * UserDate =[NSString stringWithFormat:@"%@%@date",user.msisdn,user.eccode];
        [userDefaults setObject:info.updatetime forKey:UserDate];
        [userDefaults synchronize];
        
    }else if ([info.respCode isEqualToString:@"-1"]){
        _HUD_Group.labelText = @"无需同步";
        [_HUD_Group hide:YES afterDelay:1];
    }else{
        _HUD_Group.labelText = @"网络错误";
        [_HUD_Group hide:YES afterDelay:1];
    }
    
}

//开始下载
- (void)DownLoadAddress:(NSString *)strPath{
    
    _HUD_Group.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _HUD_Group.labelText = @"同步中...";
    NSString *strFileName =[NSString stringWithFormat:@"%@/%@.zip",user.msisdn,user.eccode];
    NSString * filePath =[DocumentsDirectory stringByAppendingPathComponent:strFileName];
    NSString *str=[GroupAddressController urlByConfigFile];
    NSString * strUrl =[NSString stringWithFormat:@"%@tmp/%@.zip?eccode=%@",str,user.eccode,user.eccode];
    [HTTPRequest LoadDownFile:self URL:strUrl filePath:filePath HUD:_HUD_Group];
}


//更新完毕回调
- (void)DownLoadAddressReturn:(NSNotification *)notification{
    NSDictionary*dic =[notification userInfo];
    UIImageView *imageView;
    if([dic[@"respCode"]  isEqualToString:@"0"]){
        _HUD_Group.labelText = @"更新完毕";
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
 
        /*刷新数据*/
        [self updateDownLoad];
        _grougView.searchBar.text=nil;
        groupA=nil;
        isFirstPages=YES;
        
        //开启接受定时器,设置全局通讯录
        [self StartChatMessageController];
      
    }
    else {
        _HUD_Group.labelText = @"更新失败";
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    _HUD_Group.customView=imageView;
    _HUD_Group.mode = MBProgressHUDModeCustomView;
    [_HUD_Group hide:YES afterDelay:1];
}

//开启接受定时器,设置全局通讯录(设置全局内容)
- (void)StartChatMessageController{
    if (!EX_arrGroupAddressBooks||EX_arrGroupAddressBooks.count==0) {
        EX_arrGroupAddressBooks=[ConfigFile setEcNumberInfo];
        
        EX_arrSection=[NSMutableArray arrayWithObjects:
                       @"a",@"b",@"c",@"d",@"e",@"f",
                       @"g",@"h",@"i",@"j",@"k",@"l",
                       @"m",@"n",@"o",@"p",@"q",@"r",
                       @"s",@"t",@"u",@"v",@"w",@"x",
                       @"y",@"z",@"#",nil];
        NSMutableArray * arrRemoveObject=[[NSMutableArray alloc] init];
        for (int i = 0; i<EX_arrSection.count; i++) {
            NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter == '%@'",EX_arrSection[i]];
            NSPredicate * predicate;
            predicate = [NSPredicate predicateWithFormat:strPre];
            NSArray * results = [EX_arrGroupAddressBooks filteredArrayUsingPredicate: predicate];
            if (results.count==0) {
                [arrRemoveObject addObject:EX_arrSection[i]];
            }
        }
        [EX_arrSection removeObjectsInArray:arrRemoveObject];
    }
    /*****************************/
    /*更新完通讯录后开始接受消息*/
    //开启扫描信息定时器
    if (EX_timerUpdateMessage)[EX_timerUpdateMessage setFireDate:[NSDate distantPast]];
    else   EX_timerUpdateMessage = [NSTimer scheduledTimerWithTimeInterval:3.0 target:[[UIApplication sharedApplication] delegate] selector:@selector(timerFired:) userInfo:nil repeats:YES];
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
        arr=[NSMutableArray arrayWithArray:[_grougView.arrAllPeople filteredArrayUsingPredicate: predicateTemplate]];
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
        _grougView.arrAllPeople=nil;
        _arrFirstGroup=nil;
        _arrSeaPeople=nil;
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
        self.arrSeaPeople=[_grougView.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
        

        for (GroupInfo * info in _grougView.arrAllPeople) {
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
           arr=[NSMutableArray arrayWithArray:[_grougView.arrAllPeople filteredArrayUsingPredicate:predicate]];
            self.arrSeaPeople =[arr filteredArrayUsingPredicate: predicateTemplate];
            if (self.arrSeaPeople.count==0&&searchText.length==0){
                [arr removeObject:groupA];
                self.arrSeaPeople=arr;
            }
        }else{
            self.arrSeaPeople=[_grougView.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
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
