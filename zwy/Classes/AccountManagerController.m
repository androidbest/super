//
//  AccountManagerController.m
//  zwy
//
//  Created by wangshuang on 10/20/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "AccountManagerController.h"
#import "Constants.h"
#import "GetEcCell.h"
#import "EcinfoDetas.h"
#import "ToolUtils.h"
#import "LoginView.h"
#import "GroupAddressController.h"
#import "ZipArchive.h"
#import "HomeController.h"
#import "HomeView.h"

@implementation AccountManagerController{
   NSMutableArray *arr;
   NSIndexPath *tempIndexPath;
   // int alertViewType;/*0、切换帐号 1、取消下载进程*/
}


-(void)startCell{
    self.HUD.labelText = @"正在获取单位信息..";
    [self.HUD show:YES];
    [packageData getECinterface:self msisdn:user.msisdn];
}

-(id)init{
    self=[super init];
    if(self){
        arr=[NSMutableArray new];
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];
    NSDictionary *dic=[notification userInfo];
    if(dic){
        RespList *list=[AnalysisData AllECinterface:dic];
        if(list.resplist.count>0){
            [arr addObjectsFromArray:list.resplist];
            
            
            
            
            [self.account.accountList reloadData];
        }else{
            [ToolUtils alertInfo:@"该号码无单位信息"];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"accountCell";
    GetEcCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[GetEcCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                reuseIdentifier:strCell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    EcinfoDetas *ecinfo=arr[indexPath.row];
    if([ecinfo.lastEcid isEqualToString:ecinfo.ECID]){
        [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    }else{
        [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    
    cell.ecname.text=ecinfo.ECName;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    EcinfoDetas *ecinfo=arr[indexPath.row];
    if ([ecinfo.ECID isEqualToString:user.eccode])
        return;
    
    if ([ecinfo.isLocked isEqualToString:@"1"]) {
        [ToolUtils alertInfo:@"该单位已被锁定,请联系您的客户经理"];
        return;
    }
    
    tempIndexPath=indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [ToolUtils alertInfo:@"确定需要切换单位" delegate:self otherBtn:@"确认"];
    
}

-(void)loginout{
        /*清理所有下载线程*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllThread"
                                                            object:nil];
        
        /*清除所有本地通知*/
        NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
        for(UILocalNotification*localNotification in allLocalNotification){
            [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
        }
        
        /*关闭定时器,bool为NO表示退出否则为切换单位*/
        [self invalidateOfTime:YES];
        
        /*回传服务器“已注销"*/
        [packageData iosLoginOut:self];
        
        
        /*清除全局通讯录人员组信息*/
        EX_arrGroupAddressBooks=nil;
        EX_arrSection=nil;
        
        NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
        [appConfig setBool:NO forKey:@"isLogin"];
        user.msisdn=nil;
        user.eccode=nil;
        
        
        [appConfig synchronize];
        if(coverView){
            coverView.hidden=YES;
        }
        
        CGRect rect=self.account.view.frame;
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.6f];//动画时间
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];//开始与结束快慢
        
        rect.origin.x=ScreenWidth+ScreenWidth/2;
        self.account.view.frame=rect;
        
        [UIView commitAnimations];
        [self performSelector:@selector(dissView) withObject:nil afterDelay:0.3];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        
            for(int i=0;i<[self.account.accountList visibleCells].count;i++){
                GetEcCell *cell = [[self.account.accountList visibleCells] objectAtIndex:i];
                [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
            }
        
            EcinfoDetas *ecinfo=arr[tempIndexPath.row];
            user.eccode=ecinfo.ECID;
            user.ecname=ecinfo.ECName;
            user.ecsystem=ecinfo.ECSystem;
            user.province=ecinfo.ECProvince;
            
            user.ecSgin=@"0";
            NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
            [appConfig setValue:user.eccode forKey:@"eccode"];
            [appConfig setValue:user.ecname forKey:@"ecname"];
            [appConfig setValue:user.province forKey:@"userprovince"];
            [appConfig setValue:user.ecsystem forKey:@"ecSystem"];
            [appConfig synchronize];
            GetEcCell *cell = (GetEcCell *)[self.account.accountList cellForRowAtIndexPath:tempIndexPath];
            [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
            [self DownLoadAddress];
            isZaiXian=NO;
            
            /*清除全局通讯录人员组信息*/
            EX_arrGroupAddressBooks=nil;
            EX_arrSection=nil;
            
            /*关闭定时器,bool为YES表示退出否则为切换单位*/
            [self invalidateOfTime:NO];
            
            /*清理所有下载线程*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllThread"
                                                                object:nil];
            
        }

}

//关闭定时器
- (void)invalidateOfTime:(BOOL)isOut{
    if (isOut) {
        /*
         *关闭扫描聊天消息定时器
         */
        [[TimerGetMessages sharedInstance] deleteTimer];
        return;
    }
    
   // 判断通讯录是否存在
    NSString * strSavePath =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"member.txt"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:strSavePath];
    if (blHave){
        //开启扫描信息定时器
        [[TimerGetMessages sharedInstance] onTimer];
        
    }else{
        /*
         *关闭扫描聊天消息定时器
         */
         [[TimerGetMessages sharedInstance] deleteTimer];
    }
}

-(void)timerFired:(id)s{}

//切换单位
- (void)DownLoadAddress{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.account.view];
	[self.account.navigationController.view addSubview:self.HUD];
	self.HUD.labelText = @"正在切换单位数据";
    [self.HUD show:YES];
    
    /*清除所有本地通知*/
    NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification*localNotification in allLocalNotification){
        [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
    }
        UIImageView *imageView;
        UIImage *image ;
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"切换完成";
        imageView = [[UIImageView alloc] initWithImage:image];
        self.HUD.customView=imageView;
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText =@"切换完成";
        [self.HUD hide:YES afterDelay:1];
        [self performSelector:@selector(selecter) withObject:nil afterDelay:1];
}


//获取URL
- (NSString *)urlByConfigFile{
    NSString * strPath =[[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
    NSString *strUrl =dic[@"httpurl"];
    return strUrl;
}

//更新完毕回调
- (void)DownLoadAddressReturn:(NSNotification *)notification{
    NSDictionary*dic =[notification userInfo];
    UIImageView *imageView;
    UIImage *image ;
    
    if([dic[@"respCode"]  isEqualToString:@"0"]){
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"切换完成";
    }
    else {
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"切换失败";
    }
    imageView = [[UIImageView alloc] initWithImage:image];
    
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
	
    [self.HUD hide:YES afterDelay:1];
    
    
    NSString * str =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    if (!strGroup) {
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        NSString *strECpath =[NSString stringWithFormat:@"%@/%@.zip",user.msisdn,user.eccode];
        NSString * strPath =[DocumentsDirectory stringByAppendingPathComponent:strECpath];
        [zipFile UnzipOpenFile:strPath];
        
        //压缩包释放到的位置，需要一个完整路径
        NSString * strSavePath =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode];
        [zipFile UnzipFileTo:strSavePath overWrite:YES];
        [zipFile UnzipCloseFile];
    }

    
    
    [self performSelector:@selector(selecter) withObject:nil afterDelay:1];
}

-(void)selecter{
    self.account.tabBarController.selectedIndex=0;
    [self.account.navigationController popViewControllerAnimated:YES];
}


-(void)dissView{
    
    /*清除所有本地通知*/
    NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification*localNotification in allLocalNotification){
        [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
    }
    
    for (UIViewController *viewController in self.account.navigationController.tabBarController.viewControllers) {
        UINavigationController *navigationController =(UINavigationController*)viewController;
        if ([navigationController.topViewController isKindOfClass:[HomeView class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:navigationController.topViewController];
        }
    }

   
    
 [self.account dismissViewControllerAnimated:NO completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
