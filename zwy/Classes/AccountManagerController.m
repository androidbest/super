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
    int alertViewType;/*0、切换帐号 1、取消下载进程*/
}


-(void)startCell{
    self.HUD.labelText = @"正在获取单位信息..";
    [self.HUD show:YES];
    [packageData getECinterface:self msisdn:user.msisdn];
}

-(id)init{
    self=[super init];
    if(self){
        alertViewType=0;
        arr=[NSMutableArray new];
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
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    //    TemplateCell *cell = [storyboard instantiateViewControllerWithIdentifier:@"templateCell"];
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
    
//    for(int i=0;i<[tableView visibleCells].count;i++){
//        GetEcCell *cell = [[tableView visibleCells] objectAtIndex:i];
//        [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
//    }
//    user.eccode=ecinfo.ECID;
//    user.ecname=ecinfo.ECName;
//    user.ecSgin=@"0";
//    NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
//    [appConfig setValue:user.eccode forKey:@"eccode"];
//    [appConfig setValue:user.ecname forKey:@"ecname"];
//    [appConfig synchronize];
//    GetEcCell *cell = (GetEcCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
//    [self.account.navigationController popViewControllerAnimated:YES];
    
    EcinfoDetas *ecinfo=arr[indexPath.row];
    if ([ecinfo.ECID isEqualToString:user.eccode])
        return;
    
    if ([ecinfo.isLocked isEqualToString:@"1"]) {
        [ToolUtils alertInfo:@"该单位已被锁定,请联系您的客户经理"];
        return;
    }
    
    tempIndexPath=indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    alertViewType=0;
    [ToolUtils alertInfo:@"确定需要切换单位" delegate:self otherBtn:@"确认"];
    
}
-(void)loginout{
    
    NSString * strIngPath =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"IngDown.plist"];
    NSArray * IngDown =[NSArray arrayWithContentsOfFile:strIngPath];
    if (IngDown.count>0) {
        [ToolUtils alertInfo:@"您有未下载完的任务，退出后将取消下载任务" delegate:self otherBtn:@"确认"];
        alertViewType =2;
    }else{
        /*清理所有下载线程*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllThread"
                                                            object:nil];
        
        /*清除所有本地通知*/
        NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
        for(UILocalNotification*localNotification in allLocalNotification){
            [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
        }
        
        /*
         *关闭扫描聊天消息定时器
         */
        [EX_timerUpdateMessage setFireDate:[NSDate distantFuture]];
        [EX_timerUpdateMessage invalidate];
         EX_timerUpdateMessage=nil;
        
        /*回传服务器“已注销"*/
        [packageData iosLoginOut:self];
        
        
        /*清除全局通讯录人员组信息*/
        EX_arrGroupAddressBooks=nil;
        EX_arrSection=nil;
        
        NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
        [appConfig setBool:NO forKey:@"isLogin"];
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
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     NSString * strIngPath =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"IngDown.plist"];
    switch (alertViewType) {
        case 0://切换单位alert
            if(buttonIndex==1){
                NSArray * IngDown =[NSArray arrayWithContentsOfFile:strIngPath];
                if (IngDown.count>0) {
                    [ToolUtils alertInfo:@"您有未下载完的任务，退出后将取消下载任务" delegate:self otherBtn:@"确认"];
                    alertViewType =1;
                }else{
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
                    
                    /*清理所有下载线程*/
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllThread"
                                                                        object:nil];

                }
            }
            break;
            
            
        case 1://是否真正确认退出或者切换单位alert
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
                
                /*清理所有下载线程*/
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllThread"
                                                                    object:nil];
                BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:strIngPath];
                if (blHave) [[NSFileManager defaultManager] removeItemAtPath:strIngPath error:nil];
            }
            
            break;
            
            case 2://退出帐号alert
            if(buttonIndex==1){
                /*清理所有下载线程*/
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllThread"
                                                                    object:nil];
                
                BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:strIngPath];
                if (blHave) [[NSFileManager defaultManager] removeItemAtPath:strIngPath error:nil];
                
                NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
                [appConfig setBool:NO forKey:@"isLogin"];
                [appConfig synchronize];
                if(coverView){
                    coverView.hidden=YES;
                }
                
                /*
                 *关闭扫描聊天消息定时器
                 */
                [EX_timerUpdateMessage setFireDate:[NSDate distantFuture]];
                [EX_timerUpdateMessage invalidate];
                EX_timerUpdateMessage=nil;
                
                /*回传服务器“已注销"*/
                [packageData iosLoginOut:self];
                
                /*清除全局通讯录人员组信息*/
                EX_arrGroupAddressBooks=nil;
                EX_arrSection=nil;
                
                CGRect rect=self.account.view.frame;
                [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
                [UIView setAnimationDuration:0.6f];//动画时间
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];//开始与结束快慢
                
                rect.origin.x=ScreenWidth+ScreenWidth/2;
                self.account.view.frame=rect;
                
                [UIView commitAnimations];
                [self performSelector:@selector(dissView) withObject:nil afterDelay:0.3];
        
            }
            
            break;
        default:
            break;
    }
   }

//开始下载
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
