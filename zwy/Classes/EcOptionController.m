//
//  EcOptionController.m
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "EcOptionController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "GetEcCell.h"
#import "EcOptionView.h"
#import "LoginView.h"
#import "HomeView.h"
#import "HomeScrollView.h"
#import "BaseTabbar.h"
@implementation EcOptionController{
    NSMutableArray *arr;
    NSString *sgin;
    EcinfoDetas *ec;
    int actionIndex;
}
-(id)init{
    self=[super init];
    if(self){
        //注册通知
        actionIndex=10000;
        arr=[NSMutableArray new];
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
        if([sgin isEqualToString:@"0"]){
            RespList *list=[AnalysisData AllECinterface:dic];
            if(list.resplist.count>0){
                [arr addObjectsFromArray:list.resplist];
                [self.ecOptionView.EcList reloadData];
            }else{
              [ToolUtils alertInfo:@"该号码无单位信息"];
              [self.ecOptionView.view removeFromSuperview];
              [self.ecOptionView removeFromParentViewController];
            }
        }else{
            Tuser *autoUser=[AnalysisData autoLoginData:dic];
            if([autoUser.respcode isEqualToString:@"0"]){
                user.ecsignname=autoUser.ecsignname;
                user.username=autoUser.username;
                user.headurl=autoUser.headurl;
                user.job=autoUser.job;
                user.userid=autoUser.userid;
                NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
                [appConfig setValue:user.msisdn forKey:@"msisdn"];
                [appConfig setValue:user.ecname forKey:@"ecname"];
                [appConfig setValue:user.username forKey:@"username"];
                [appConfig setValue:user.eccode forKey:@"eccode"];
                [appConfig setValue:user.headurl forKey:@"headurl"];
                [appConfig setValue:user.job forKey:@"job"];
                [appConfig setValue:user.userid forKey:@"userid"];
                [appConfig setBool:YES forKey:@"isLogin"];
                [appConfig synchronize];
                
                
                //发送上线状态(不处理返回数据)
                [packageData iosLoginIn:self];
                
                
                LoginView *login=(LoginView *)self.ecOptionView.parentViewController;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                /*
                HomeScrollView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HomeScrollView"];
                 */
                BaseTabbar *detaView =[storyboard instantiateViewControllerWithIdentifier:@"zwyhome"];
                //                detaView.view.layer.position=CGPointMake(ScreenWidth+ScreenWidth/2, ScreenHeight/2);
                CGRect rect=detaView.view.frame;
                rect.origin.x=ScreenWidth+ScreenWidth/2;
                detaView.view.frame=rect;
                [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
                [UIView setAnimationDuration:0.3f];//动画时间
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];//开始与结束快慢
                //                [login performSegueWithIdentifier:@"logintogethome" sender:login];
                [login presentViewController:detaView animated:NO completion:nil];
                rect.origin.x=0;
                detaView.view.frame=rect;
                //                detaView.view.layer.position=CGPointMake(ScreenWidth/2, ScreenHeight/2);
                [UIView commitAnimations]; //启动动画
                
                [self.ecOptionView.view removeFromSuperview];
                [self.ecOptionView willMoveToParentViewController:nil];
                [self.ecOptionView removeFromParentViewController];
                
            }else{
            [ToolUtils alertInfo:@"无法获取个人信息"];
            }
        }
    
    }else{
        [ToolUtils alertInfo:requestError];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"getEcCell";
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
        ec=ecinfo;
    }else{
        [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    
        if (actionIndex!=10000) {
            if (indexPath.row==actionIndex) {
                [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
            }else{
              [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
            }
        }
    
    cell.ecname.text=ecinfo.ECName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    actionIndex=indexPath.row;
    for(int i=0;i<[tableView visibleCells].count;i++){
        GetEcCell *cell = [[tableView visibleCells] objectAtIndex:i];
        [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    
    ec=arr[indexPath.row];
    GetEcCell *cell = (GetEcCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getEc{
    sgin=@"0";
    self.HUD.labelText = @"正在获取单位信息..";
    [self.HUD show:YES];
//    self.HUD.dimBackground = YES;
    [packageData getECinterface:self msisdn:user.msisdn];
}

-(void)selectOk{
    if(arr.count==0){
        [ToolUtils alertInfo:@"暂无单位信息"];
        return;
    }
    user.eccode=ec.ECID;
    user.ecname=ec.ECName;
    sgin=@"1";
    self.HUD.labelText = @"正在获取个人信息..";
    [self.HUD show:YES];
    [packageData autoLoginvalidation:self Count:@"1" msisdn:user.msisdn eccode:user.eccode];
    
}
@end
