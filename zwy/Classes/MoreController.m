//
//  MoreController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MoreController.h"
#import "ToolUtils.h"
@implementation MoreController{
    NSArray *allsec;
    NSArray *firstsec;
    NSArray *second;
    NSArray *third;
    NSArray *allimage;
    NSArray *image1;
    NSArray *image2;
    NSArray *image3;
}


-(id)init{
    self=[super init];
    if(self){
        firstsec=@[@"账号管理"];
//        firstsec=@[@"账号管理",@"密码修改"];
        second=@[@"检查更新"];
//        third=@[@"帮助",@"关于"];
        third=@[@"下载分享",@"帮助",@"关于"];
        allsec=@[firstsec,second,third];
        
//        image1=@[[UIImage imageNamed:@"more_accounts_image"],[UIImage imageNamed:@"more_update_pwd_img"]];
        image1=@[[UIImage imageNamed:@"more_accounts_image"]];
        image2=@[[UIImage imageNamed:@"check_update_img"]];
        image3=@[[UIImage imageNamed:@"more_download_image"],[UIImage imageNamed:@"more_help_img"],[UIImage imageNamed:@"more_about_img"]];
        allimage=@[image1,image2,image3];
    }
    return self;
}


//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//对应的section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr =[allsec objectAtIndex:section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        UIView* header =[UIView new];
        header.alpha=0;
        return header;
    }
        
        else
        {
            return nil;
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0){
        switch (indexPath.row) {
            case 0:{
                [self initBackBarButtonItem:self.moreView];
                self.moreView.tabBarController.tabBar.hidden=YES;
               [self.moreView performSegueWithIdentifier:@"moretoaccount" sender:self.moreView];
            }
                break;
        }
    }else if(indexPath.section==1){
        switch (indexPath.row) {
            case 0:{
                [ToolUtils alertInfo:@"已是最新版本"];
            }
                break;
            case 1:{
            }
                break;
    }
    }else if(indexPath.section==2){
        switch (indexPath.row) {
            case 0:{
//                [self initBackBarButtonItem:self.moreView];
//                self.moreView.tabBarController.tabBar.hidden=YES;
//                [self.moreView performSegueWithIdentifier:@"moretohelp" sender:self.moreView];
            }
                break;
            case 1:{
                [self initBackBarButtonItem:self.moreView];
                self.moreView.tabBarController.tabBar.hidden=YES;
                [self.moreView performSegueWithIdentifier:@"moretohelp" sender:self.moreView];
            }
                break;
            case 2:{
                [self initBackBarButtonItem:self.moreView];
                self.moreView.tabBarController.tabBar.hidden=YES;
                [self.moreView performSegueWithIdentifier:@"moretoabout" sender:self.moreView];
            }
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//操作每一行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strcell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:strcell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text= [[allsec objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.imageView.image=[[allimage objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
