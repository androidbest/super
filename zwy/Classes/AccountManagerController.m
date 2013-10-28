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
@implementation AccountManagerController{
NSMutableArray *arr;
}


-(void)startCell{
    self.HUD.labelText = @"正在获取单位信息..";
    [self.HUD show:YES];
    self.HUD.dimBackground = YES;
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
    for(int i=0;i<[tableView visibleCells].count;i++){
        GetEcCell *cell = [[tableView visibleCells] objectAtIndex:i];
        [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
    EcinfoDetas *ecinfo=arr[indexPath.row];
    user.eccode=ecinfo.ECID;
    user.ecname=ecinfo.ECName;
    user.ecSgin=@"0";
    NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
    [appConfig setValue:user.eccode forKey:@"eccode"];
    [appConfig setValue:user.ecname forKey:@"ecname"];
    [appConfig synchronize];
    GetEcCell *cell = (GetEcCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.selectEc setBackgroundImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
//    [self.account.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.account.tabBarController.selectedIndex=0;
}
-(void)loginout{
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
-(void)dissView{
 [self.account dismissViewControllerAnimated:NO completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
