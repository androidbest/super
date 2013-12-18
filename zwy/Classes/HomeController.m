//
//  HomeController.m
//  zwy
//
//  Created by wangshuang on 10/11/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//
#define NOTIFICATIONFIRSTNEWS @"notificationFirstNews"
#import "HomeController.h"
#import "Constants.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "SumEmailOrDocInfo.h"
#import "InformationInfo.h"
@implementation HomeController{
    NSString *sign;

}

-(id)init{
    self=[super init];
    if(self){
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveCount:)
                                                    name:@"getCount"
                                                  object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationFirstNews:)
                                                    name:NOTIFICATIONFIRSTNEWS
                                                  object:self];
        
    }
    return self;
}

- (void)initWithData{
    [packageData reqHotNewsInfoXml:self start:@"1" end:@"2" SELType:NOTIFICATIONFIRSTNEWS];
}

-(void)receiveCount:(NSNotification *)notification{
         NSDictionary *dic=[notification userInfo];
            if(dic){
                 SumEmailOrDocInfo *sum=[AnalysisData getSum:dic];
                    if(sum.sumEmail==nil||[sum.sumEmail isEqualToString:@"0"]){
                        self.homeView.mailsum.hidden=YES;
    
                    }else{
                        self.homeView.mailsum.hidden=NO;
    
                        self.homeView.mailsum.text=sum.sumEmail;
    
                   }
    
                    if(sum.sumDoc==nil||[sum.sumDoc isEqualToString:@"0"]){
                        self.homeView.officesum.hidden=YES;
                    }else{
                        self.homeView.officesum.hidden=NO;
                        self.homeView.officesum.text=sum.sumDoc;
                    }
//                [self sendEc];
            }else{
//                [ToolUtils alertInfo:requestError];
            }

}

//首页头条新闻展示
- (void)notificationFirstNews:(NSNotification *)notification{
     NSDictionary *dic=[notification userInfo];
    if(dic){
        RespList *list=[AnalysisData newsInfo:dic];
        if(list.resplist.count>0){
            InformationInfo*info =[list.resplist firstObject];
            _homeView.labelNewsTitle.text=info.title;
            [HTTPRequest setImageWithURL:info.imagePath ImageBolck:^(UIImage *image) {
                [_homeView.information setBackgroundImage:image forState:UIControlStateNormal];
            }];
        }
    }

}



//处理网络数据
-(void)handleData:(NSNotification *)notification{
//    NSDictionary *dic=[notification userInfo];
//    if(![sign isEqualToString:@"1"]){
//        if(dic){
//            if([sign isEqualToString:@"2"]){
//             SumEmailOrDocInfo *sum=[AnalysisData getSum:dic];
//                if(sum.sumEmail==nil||[sum.sumEmail isEqualToString:@"0"]){
//                    self.homeView.mailsum.hidden=YES;
//                    
//                }else{
//                    self.homeView.mailsum.hidden=NO;
//                    
//                    self.homeView.mailsum.text=sum.sumEmail;
//                    
//                }
//                
//                if(sum.sumDoc==nil||[sum.sumDoc isEqualToString:@"0"]){
//                    self.homeView.officesum.hidden=YES;
//                }else{
//                    self.homeView.officesum.hidden=NO;
//                    self.homeView.officesum.text=sum.sumDoc;
//                }
//                
//            }
//            
//            [self sendEc];
//        }else{
//            [ToolUtils alertInfo:requestError];
//        }
//    }
}
//资讯
-(void)information{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"hometoinformation" sender:self.homeView];
}

//公告
-(void)notice{
    [self initBackBarButtonItem:self.homeView];
    [self.homeView performSegueWithIdentifier:@"hometoNotice" sender:self.homeView];
}

//信息发布
-(void)sms{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"hometosms" sender:self.homeView];
}

//通讯录
-(void)address{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"homeToAddress" sender:self.homeView];
    
}

//政务办公
-(void)office{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"hometooffice" sender:self.homeView];
    
    
}

//群众信箱
-(void)mail{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"hometomail" sender:self.homeView];
}
//会议电话
-(void)meetting{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"hometomeetting" sender:self.homeView];
}


//即时聊天
- (void)Btnchat{
   [self initBackBarButtonItem:self.homeView];
   [self.homeView performSegueWithIdentifier:@"homeToIM" sender:self.homeView];
}


//日程提醒
- (void)btnWarning{
    [self initBackBarButtonItem:self.homeView];
    self.homeView.tabBarController.tabBar.hidden=YES;
    [self.homeView performSegueWithIdentifier:@"HomeToScheduleView" sender:self.homeView];
}

//传输最后选择单位
-(void)sendEc{
    [packageData sendEc:self Type:xmlNotifInfo];
}

//获取总数
-(void)getCount{
    [packageData getSum:self Type:@"getCount"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(NSInteger)index{

}
@end
