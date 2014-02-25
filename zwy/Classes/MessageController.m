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
        
        
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession isOtherAudioPlaying];
            //默认情况下扬声器播放
            [audioSession setActive:YES error:nil];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        
        //更新通讯录列表
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(DownLoadAddressReturn:)
                                                    name:wnLoadAddress
                                                  object:self];
        
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];

        
    }
    return self;
}


- (void)initWithData{
    _HUD_Group = [MBProgressHUD showHUDAddedTo:self.messageView.view animated:YES];
    NSString * str =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:str];
    if (!blHave) {
        [ToolUtils alertInfo:@"请同步单位通讯录" delegate:self otherBtn:@"确认"];
    }else{
        [_HUD_Group hide:YES];
        /*获取所有EC人员信息*/
        [self showSetAllAllGroupAddressBooksHUDWithText:@"加载中..."];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        [self reloadGroupAddress];
    }else{
        [_HUD_Group hide:YES];
    }
}

- (void)reloadGroupAddress{
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
    
    //    /**/
    //    UIImageView *imageView;
    //    UIImage *image;
    //    image= [UIImage imageNamed:@"37x-Checkmark.png"];
    //    imageView = [[UIImageView alloc] initWithImage:image];
    //    _HUD_Group.customView=imageView;
    //    _HUD_Group.mode = MBProgressHUDModeCustomView;
    //    /**/
    
    if ([info.respCode isEqualToString:@"1"]) {
        //下载zip包
        [ToolUtils downFileZip:_HUD_Group delegate:self];
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


//更新完毕回调
- (void)DownLoadAddressReturn:(NSNotification *)notification{
    NSDictionary*dic =[notification userInfo];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    if([dic[@"respCode"]  isEqualToString:@"0"]){
        _HUD_Group.labelText = @"更新完毕";
        //解压压缩包
        [ToolUtils unZipPackage];
        [self showSetAllAllGroupAddressBooksHUDWithText:@"加载中..."];
        [ToolUtils startChatTimer];
    }
    else {
        _HUD_Group.labelText = @"更新失败";
    }
    _HUD_Group.customView=imageView;
    _HUD_Group.mode = MBProgressHUDModeCustomView;
    [_HUD_Group hide:YES afterDelay:1];
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
- (void)MessageViewToChatMessageView:(NSMutableArray *)peoples{
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
    [dateFormatter setDateFormat:CHATDATETYPE];
    
    SessionEntity * sessionInfo=nil;
    if (_messageView.searchBar.text.length!=0&&isSearching)sessionInfo=_arrSeaPeople[indexPath.row];
    else sessionInfo=_arrSession[indexPath.row];
    
    
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
    NSString *url=nil;
    if(sessionInfo.session_groupuuid&&![sessionInfo.session_groupuuid isEqualToString:@"null"]&&![sessionInfo.session_groupuuid isEqualToString:@""]&&![sessionInfo.session_groupuuid isEqualToString:@"(null)"]){
        NSArray *urlarr=[sessionInfo.session_receiveravatar componentsSeparatedByString:@","];
        NSArray *titarr=[sessionInfo.session_receivername componentsSeparatedByString:@","];
        NSArray *msisdnarr=[sessionInfo.session_receivermsisdn componentsSeparatedByString:@","];
        if(titarr.count==2){
            for(int i=0;i<titarr.count;i++){
                if([msisdnarr[i] isEqualToString:user.msisdn])continue;
                
                url=urlarr[i];
                cell.title.text=titarr[i];
            }
        }else{
            url=urlarr[0];
            cell.title.text=sessionInfo.session_receivername;
        }
    }
//    else{
//        url=sessionInfo.session_receiveravatar;
//        cell.title.text=sessionInfo.session_receivername;
//    }
    [HTTPRequest imageWithURL:url imageView:cell.imageMark placeholderImage:[UIImage  imageNamed:@"default_avatar"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新首页即时聊天未读条数信息
    MesaageIMCell *cell =(MesaageIMCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self cancelCheckTitle:cell];
    
    SessionEntity * sessionInfo=nil;
    if (_messageView.searchBar.text.length!=0&&isSearching){
     sessionInfo=_arrSeaPeople[indexPath.row];
    }
    else{
    sessionInfo=_arrSession[indexPath.row];
    }
   
    [[CoreDataManageContext newInstance] updateWithSessionEntity:sessionInfo];
    
    PeopelInfo *info=[PeopelInfo new];
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
    //更新首页即时聊天未读条数信息
    MesaageIMCell *cell =(MesaageIMCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self cancelCheckTitle:cell];
    
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

- (void)cancelCheckTitle:(MesaageIMCell *)cell{
    int CellCount =[cell.labelCount.text integerValue];
    NSUserDefaults *userDeafults=[NSUserDefaults standardUserDefaults];
    int count =[userDeafults integerForKey:CHATMESSAGECOUNT(user.msisdn,user.eccode)];
    int deafyltsIndex=count-CellCount;
    if (deafyltsIndex<0)deafyltsIndex=0;
    [userDeafults setInteger:deafyltsIndex forKey:CHATMESSAGECOUNT(user.msisdn,user.eccode)];
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

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.messageView.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}



/*同步全局通讯录缓存指示灯*/
- (void)showSetAllAllGroupAddressBooksHUDWithText:(NSString *)text{
//    NSString * str =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
//    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:str];
//    if (!blHave)return;
    
    if (EX_arrGroupAddressBooks&&EX_arrGroupAddressBooks.count!=0){
//    [_HUD_Group hide:YES];
        return;
    }

//    _HUD_Group.labelText =text;
//    _HUD_Group.margin = 10.f;
//    _HUD_Group.removeFromSuperViewOnHide = YES;
//    [_HUD_Group show:YES];
    
    
    __block NSArray *allPeople=nil;
    __block NSMutableArray *allSection=nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //设置通讯录
        /*****************************/
        allPeople=[ConfigFile setEcNumberInfo];
        EX_arrGroupAddressBooks=allPeople;
        
        allSection=[NSMutableArray arrayWithObjects:
                       @"a",@"b",@"c",@"d",@"e",@"f",
                       @"g",@"h",@"i",@"j",@"k",@"l",
                       @"m",@"n",@"o",@"p",@"q",@"r",
                       @"s",@"t",@"u",@"v",@"w",@"x",
                       @"y",@"z",@"#",nil];
        NSMutableArray * arrRemoveObject=[[NSMutableArray alloc] init];
        for (int i = 0; i<allSection.count; i++) {
            NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter == '%@'",allSection[i]];
            NSPredicate * predicate;
            predicate = [NSPredicate predicateWithFormat:strPre];
            NSArray * results = [allPeople filteredArrayUsingPredicate: predicate];
            if (results.count==0) {
                [arrRemoveObject addObject:allSection[i]];
            }
        }
        [allSection removeObjectsInArray:arrRemoveObject];
        EX_arrSection=allSection;
        /*****************************/
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//         [_HUD_Group hide:YES afterDelay:0];
//        });
        
    });
}

@end
