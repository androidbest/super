//
//  MeettingController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MeettingController.h"
#import "GroupInfo.h"
#import "PeopelInfo.h"
#import "optionInfo.h"
#import "optionAddress.h"


@implementation MeettingController{
 NSMutableArray * arrAllNumber;
    long long KTime;
    NSInteger timeType;
    NSString * strAllPeopleName;
    NSString * strAllPeoleTel;
    NSString * strAllGroupID;
    
    
    NSString *voicestrAllPeopleName;
    NSString *voiicestrAllPeoleTel;
    NSString *voicestrAllGroupID;
    
    NSMutableArray *voiceAllNumber;
    NSMutableArray *voiceDidAllPeople;
    
    
    
}

#pragma mark - 初始化
- (id)init{
    self =[super init];
    if (self) {
        _MeetType=@"0";
        strAllGroupID=@"";
        strAllPeoleTel=@"";
        strAllPeopleName=@"";
        
        voicestrAllPeopleName=@"";
        voiicestrAllPeoleTel=@"";
        voicestrAllGroupID=@"";
        
        voiceAllNumber=[NSMutableArray new];
        voiceDidAllPeople=[NSMutableArray new];
        
        self.arrDidAllPeople =[[NSMutableArray alloc] init];
        arrAllNumber =[[NSMutableArray alloc] init];
        
        //返回消息通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}


- (void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    UIImageView *imageView;
    UIImage *image;
    
    RespInfo * info =[AnalysisData ReTurnInfo:dic];
    if ([info.respCode isEqualToString:@"0"]) {
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"发送成功";
    }else{
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"发送失败";
    }
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
    [self.HUD hide:YES afterDelay:1];
}

#pragma mark -接受选择通讯录传回来的数据
- (void)returnDidAddress:(NSArray *)arr{
    
    if([_MeetType isEqualToString:@"0"]){
        NSObject *obj;
        if (arr.count!=0) {
            for (int i =0; i<arr.count; i++) {
                obj=arr[i];
                if ([obj isKindOfClass:[PeopelInfo class]]) {
                    if (![arrAllNumber containsObject:[(PeopelInfo *)obj tel]]){
                        [arrAllNumber addObject:[(PeopelInfo *)obj tel]];
                        [_arrDidAllPeople addObject:obj];
                    }
                }else if([obj isKindOfClass:[GroupInfo class]]){
                    if (![arrAllNumber containsObject:[(GroupInfo *)obj groupID]]){
                        [arrAllNumber addObject:[(PeopelInfo *)obj groupID]];
                        [_arrDidAllPeople addObject:obj];
                    }
                }
                
            }
        }
    }else{
        NSObject *obj;
        if (arr.count!=0) {
            for (int i =0; i<arr.count; i++) {
                obj=arr[i];
                if ([obj isKindOfClass:[PeopelInfo class]]) {
                    if (![voiceAllNumber containsObject:[(PeopelInfo *)obj tel]]){
                        [voiceAllNumber addObject:[(PeopelInfo *)obj tel]];
                        [voiceDidAllPeople addObject:obj];
                    }
                }else if([obj isKindOfClass:[GroupInfo class]]){
                    if (![voiceAllNumber containsObject:[(GroupInfo *)obj groupID]]){
                        [voiceAllNumber addObject:[(PeopelInfo *)obj groupID]];
                        [voiceDidAllPeople addObject:obj];
                    }
                }
                
            }
        }
    
    
    }
    [self.meettingView.tableViewPeople reloadData];
}

#pragma mark - 按钮实现方法
//发送
-(void)btnCheck{
    
    
    
    if([_MeetType isEqualToString:@"0"]){
        strAllPeopleName =@"";
        strAllPeoleTel =@"";
        strAllGroupID =@"";
        
        for (int i=0; i<_arrDidAllPeople.count; i++) {
            NSObject * obj =_arrDidAllPeople[i];
            if ([obj isKindOfClass:[PeopelInfo class]]) {
                
                /*所有人员号码*/
                if ([strAllPeopleName isEqualToString:@""])strAllPeopleName=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj Name]];
                else  strAllPeopleName =[NSString stringWithFormat:@"%@%@,",strAllPeopleName,[(PeopelInfo *)obj Name]];
                
                /*所有人员电话*/
                if ([strAllPeoleTel isEqualToString:@""])strAllPeoleTel=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj tel]];
                else strAllPeoleTel =[NSString stringWithFormat:@"%@%@,",strAllPeoleTel,[(PeopelInfo *)obj tel]];
                
            }else if([obj isKindOfClass:[GroupInfo class]]){
                
                /*所有部门id*/
                if ([strAllGroupID isEqualToString:@""])strAllGroupID = [NSString stringWithFormat:@"%@,",[(GroupInfo *)obj groupID]];
                else strAllGroupID =[NSString stringWithFormat:@"%@%@,",strAllGroupID,[(GroupInfo *)obj groupID]];
            }
        }
        NSLog(@"%@\n%@\n%@",strAllGroupID,strAllPeoleTel,strAllPeopleName);
        /**/
        if ([strAllGroupID isEqualToString:@""]&&[strAllPeoleTel isEqualToString:@""]){
            [ToolUtils alertInfo:@"请选择联系人"];
            return;
        }
        
        /*提交等待*/
//        self.HUD =[[MBProgressHUD alloc] initWithView:self.meettingView.navigationController.view];
//        self.HUD.labelText=@"正在发送..";
//        [self.meettingView.view addSubview:self.HUD];
//        [self.HUD show:YES];
        
//        [packageData scheduleConf:self receiverTel:strAllPeoleTel receiverName:strAllPeopleName groupID:strAllGroupID time:@"0"];
        
    
    }else{
        voicestrAllPeopleName=@"";
        voiicestrAllPeoleTel=@"";
        voicestrAllGroupID=@"";
        
        for (int i=0; i<voiceDidAllPeople.count; i++) {
            NSObject * obj =voiceDidAllPeople[i];
            if ([obj isKindOfClass:[PeopelInfo class]]) {
                
                /*所有人员号码*/
                if ([voicestrAllPeopleName isEqualToString:@""])voicestrAllPeopleName=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj Name]];
                else  voicestrAllPeopleName =[NSString stringWithFormat:@"%@%@,",voicestrAllPeopleName,[(PeopelInfo *)obj Name]];
                
                /*所有人员电话*/
                if ([voiicestrAllPeoleTel isEqualToString:@""])voiicestrAllPeoleTel=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj tel]];
                else voiicestrAllPeoleTel =[NSString stringWithFormat:@"%@%@,",voiicestrAllPeoleTel,[(PeopelInfo *)obj tel]];
                
            }else if([obj isKindOfClass:[GroupInfo class]]){
                
                /*所有部门id*/
                if ([voicestrAllGroupID isEqualToString:@""])voicestrAllGroupID = [NSString stringWithFormat:@"%@,",[(GroupInfo *)obj groupID]];
                else voicestrAllGroupID =[NSString stringWithFormat:@"%@%@,",voicestrAllGroupID,[(GroupInfo *)obj groupID]];
            }
        }
        NSLog(@"%@\n%@\n%@",voicestrAllGroupID,voiicestrAllPeoleTel,voicestrAllPeopleName);
        /**/
        if ([voicestrAllGroupID isEqualToString:@""]&&[voiicestrAllPeoleTel isEqualToString:@""]){
            [ToolUtils alertInfo:@"请选择联系人"];
            return;
        }

        
    
        //预约时间
        NSString * dateAndTime = [NSString stringWithFormat:@"%@ %@",_meettingView.btnDate.titleLabel.text,_meettingView.btnTime.titleLabel.text];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *date =[dateFormatter dateFromString:dateAndTime];
        NSTimeInterval time_=[date timeIntervalSince1970];
        KTime =time_*1000;
        
        /*判断时间是否过了十分钟*/
        long long intNum= (long long)[[NSDate date] timeIntervalSince1970];
        long long num = time_ - intNum;
        if (num<600){
            [ToolUtils alertInfo:@"预约时间必须十分钟之后"];
            return;
        }
        
        if(time_<intNum){
            [ToolUtils alertInfo:@"预约时间必须十分钟之后"];
            return;
        }
        
        /*提交等待*/
//        self.HUD =[[MBProgressHUD alloc] initWithView:self.meettingView.navigationController.view];
//        self.HUD.labelText=@"正在发送..";
//        [self.meettingView.view addSubview:self.HUD];
//        [self.HUD show:YES];
        
//        [packageData scheduleConf:self receiverTel:voiicestrAllPeoleTel receiverName:voicestrAllPeopleName groupID:voicestrAllGroupID time:[NSString stringWithFormat:@"%lld",KTime]];
    }

}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)btnDate{
    timeType=0;
    ActionSheetView * sheet =[[ActionSheetView alloc] initWithViewdelegate:self WithSheetTitle:@"预约时间" sheetMode:timeType];
    [sheet showInView:self.meettingView.navigationController.view];
}

- (void)btnTime{
    timeType=1;
    ActionSheetView * sheet =[[ActionSheetView alloc] initWithViewdelegate:self WithSheetTitle:@"预约时间" sheetMode:timeType];
    [sheet showInView:self.meettingView.navigationController.view];
}

/*选择发送方式*/
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    _MeetType=[NSString stringWithFormat:@"%@",[ToolUtils numToString:Index]];
    if (Index==0) {
        _meettingView.btnDate.hidden=YES;
        _meettingView.btnTime.hidden=YES;
        
        self.meettingView.meetting_date.hidden=YES;
        self.meettingView.meetting_time.hidden=YES;
        self.meettingView.btnTime.hidden=YES;
        self.meettingView.btnDate.hidden=YES;
        self.meettingView.atonce_time.hidden=NO;
        self.meettingView.statusLabel.hidden=YES;
        
        [self.meettingView.tableViewPeople reloadData];
        
//        [self.meettingView.nsTimer setFireDate:[NSDate distantPast]];
        CGRect revicer=self.meettingView.reciver.frame;
        revicer.origin.y-=47;
        self.meettingView.reciver.frame=revicer;
        
        CGRect btnAddpeople=self.meettingView.btnAddpeople.frame;
        btnAddpeople.origin.y-=47;
        self.meettingView.btnAddpeople.frame=btnAddpeople;
        
        CGRect tableview=self.meettingView.tableViewPeople.frame;
        tableview.origin.y-=40;
        tableview.size.height+=30;

        self.meettingView.tableViewPeople.frame=tableview;
        
        
       
    }else{
//        [self.meettingView.nsTimer setFireDate:[NSDate distantFuture]];
        _meettingView.btnDate.hidden=NO;
        _meettingView.btnTime.hidden=NO;
        self.meettingView.meetting_date.hidden=NO;
        self.meettingView.meetting_time.hidden=NO;
        self.meettingView.btnTime.hidden=NO;
        self.meettingView.btnDate.hidden=NO;
        self.meettingView.atonce_time.hidden=YES;
        self.meettingView.statusLabel.hidden=NO;
        self.meettingView.statusLabel.text=@"预约时间";
        [self.meettingView.tableViewPeople reloadData];
        
        CGRect revicer=self.meettingView.reciver.frame;
        revicer.origin.y+=47;
        self.meettingView.reciver.frame=revicer;
        
        CGRect btnAddpeople=self.meettingView.btnAddpeople.frame;
        btnAddpeople.origin.y+=47;
        self.meettingView.btnAddpeople.frame=btnAddpeople;
        
        CGRect tableview=self.meettingView.tableViewPeople.frame;
        tableview.origin.y+=40;
        tableview.size.height-=30;
        self.meettingView.tableViewPeople.frame=tableview;
    }
}

//选择联系人
- (void)btnAddpeople{
    self.meettingView.tabBarController.tabBar.hidden=YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    optionAddress *optionView = [storyboard instantiateViewControllerWithIdentifier:@"optionAddress"];
    [self.meettingView.navigationController pushViewController:optionView animated:YES];
    optionView.optionDelegate=self;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheetTimeText:(NSString *)Text{
    if (timeType==0) [_meettingView.btnDate setTitle:Text forState:UIControlStateNormal];
    else [_meettingView.btnTime setTitle:Text forState:UIControlStateNormal];

}


#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    if([_MeetType isEqualToString:@"0"]){
        
        if (_arrDidAllPeople.count==0)tableView.separatorStyle=NO;
        else tableView.separatorStyle=YES;
        return _arrDidAllPeople.count;
    }else{
        
        if (voiceDidAllPeople.count==0)tableView.separatorStyle=NO;
        else tableView.separatorStyle=YES;
        return voiceDidAllPeople.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell=@"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
        cell.detailTextLabel.textColor =[UIColor grayColor];
    }
    
    if([_MeetType isEqualToString:@"0"]){
        NSObject * obj =_arrDidAllPeople[indexPath.row];
        if ([obj isKindOfClass:[PeopelInfo class]]) {
            cell.textLabel.text=[(PeopelInfo *)obj Name];
            cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
        }else if([obj isKindOfClass:[GroupInfo class]]){
            cell.textLabel.text=[(GroupInfo *)obj Name];
            NSString *strDeta=[[(GroupInfo *)obj Count] stringByAppendingString:@"  位联系人"];
            strDeta=[strDeta stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            cell.detailTextLabel.text=strDeta;
        }
    }else{
    
        NSObject * obj =voiceDidAllPeople[indexPath.row];
        if ([obj isKindOfClass:[PeopelInfo class]]) {
            cell.textLabel.text=[(PeopelInfo *)obj Name];
            cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
        }else if([obj isKindOfClass:[GroupInfo class]]){
            cell.textLabel.text=[(GroupInfo *)obj Name];
            NSString *strDeta=[[(GroupInfo *)obj Count] stringByAppendingString:@"  位联系人"];
            strDeta=[strDeta stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            cell.detailTextLabel.text=strDeta;
        }

    
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if([_MeetType isEqualToString:@"0"]){
            [_arrDidAllPeople removeObjectAtIndex:indexPath.row];
            [arrAllNumber removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        
        }else{
            [voiceDidAllPeople removeObjectAtIndex:indexPath.row];
            [voiceAllNumber removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
