//
//  MoreController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MoreController.h"
#import "ToolUtils.h"
#import "PopBottomWindow.h"
#import "AAActivity.h"
#import  "AAActivityAction.h"
#import "WXApi.h"
#import "WXApiObject.h"
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
        NSString *url=@"http://itunes.apple.com/lookup?id=647204141";
        
        switch (indexPath.row) {
            case 0:{
//                AAImageSize imageSize = [self iconSizeSetting].selectedSegmentIndex == 0 ? AAImageSizeSmall : AAImageSizeNormal;
                NSMutableArray *array = [NSMutableArray array];
                NSArray *title=@[@"短信",@"邮箱",@"微信",@"新浪"];
                NSArray *image=@[[UIImage imageNamed:@"Safari"],[UIImage imageNamed:@"Safari"],[UIImage imageNamed:@"Safari"],[UIImage imageNamed:@"Safari"]];
                NSArray *arrUrl=@[[NSString stringWithFormat:@"sms://%@",url],[NSString stringWithFormat:@"mailto://%@",url],url];
                
                for (int i=0; i<4; i++) {
                    AAActivity *activity = [[AAActivity alloc] initWithTitle:title[i]
                                                                       image:image[i]
                                                                 actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                                     NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                                     NSString *str=activityItems[i];
                                                                     if(i==2){
//                                                                         SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//                                                                         req.text = str;
//                                                                         req.bText = YES;
//                                                                         req.scene = WXSceneSession;
//                                                                         [WXApi sendReq:req];
                                                                     }else{
                                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                                                     }
                                                                 }];
                    [array addObject:activity];
                }
                AAActivityAction *aa = [[AAActivityAction alloc] initWithActivityItems:arrUrl
                                                                 applicationActivities:array
                                                                             imageSize:AAImageSizeNormal];
                aa.title = nil;
                [aa show];
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
