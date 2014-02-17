//
//  HomeView.m
//  zwy
//
//  Created by sxit on 9/27/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#define DOCUMENTS(userPath)  [NSString stringWithFormat:@"%@/%@",DocumentsDirectory,userPath]


#define Save 1
#define STRING_TEL(tel) tel


#if Save

NSString * stringTel =STRING_TEL(@"133");

#endif


#import "HomeView.h"
#import "HomeController.h"
#import "Constants.h"
#import "WorkView.h"
#import "HolidayView.h"
#import "BaseTabbar.h"
#import "SGFocusImageItem.h"
#import "SGFocusImageFrame.h"

@interface HomeView ()

@end

@implementation HomeView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
       self.tabBarItem=[self.tabBarItem initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home_out_1_6"] selectedImage:[UIImage imageNamed:@"tabbar_home_over_1_6"]];
        
        HomeController *home=[HomeController new];
        home.HomeView=self;
        self.controller=home;
        
        
        //点击通知栏的日程提醒跳转
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(jumpScheduleView:)
                                                    name:@"homeToWarningView"
                                                  object:nil];
        
        //接收即时聊天，更新未读消息状态
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(getMessage:)
                                                    name:NOTIFICATIONCHAT
                                                  object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
         self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [_information setBackgroundImage:[UIImage imageNamed:@"error_image.jpg"] forState:UIControlStateNormal];
	[_information setBackgroundColor:[UIColor colorWithRed:0.41 green:0.47 blue:0.98 alpha:1.0]];
    [_btnDate setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [_notice setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:43.0/255.0 blue:82.0/255.0 alpha:1.0]];
    [_sms setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [_office setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:152.0/255.0 blue:233.0/255.0 alpha:1.0]];
    [_mail setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:132.0/255.0 blue:45.0/255.0 alpha:1.0]];
    [_meetting setBackgroundColor:[UIColor colorWithRed:113.0/255.0 green:195.0/255.0 blue:11.0/255.0 alpha:1.0]];
    [_labelNewsTitle setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [_btnWarning setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [_Btnchat setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:220.0/255.0 blue:170.0/255.0 alpha:1.0]];
    [_btnAddressBook setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:66.0/255.0 blue:237.0/255.0 alpha:1.0]];
    
    [_information addTarget:self.controller action:@selector(information) forControlEvents:UIControlEventTouchUpInside];
    [_information setExclusiveTouch:YES];
    
    [_notice addTarget:self.controller action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
    [_notice setExclusiveTouch:YES];
    
    [_sms addTarget:self.controller action:@selector(sms) forControlEvents:UIControlEventTouchUpInside];
    [_sms setExclusiveTouch:YES];

    [_office addTarget:self.controller action:@selector(office) forControlEvents:UIControlEventTouchUpInside];
    [_office setExclusiveTouch:YES];
    
    [_mail addTarget:self.controller action:@selector(mail) forControlEvents:UIControlEventTouchUpInside];
    [_mail setExclusiveTouch:YES];
    
    [_meetting addTarget:self.controller action:@selector(meetting) forControlEvents:UIControlEventTouchUpInside];
    [_meetting setExclusiveTouch:YES];
    
    [_Btnchat addTarget:self.controller action:@selector(Btnchat) forControlEvents:UIControlEventTouchUpInside];
    [_Btnchat setExclusiveTouch:YES];
    
    [_btnWarning addTarget:self.controller action:@selector(btnWarning) forControlEvents:UIControlEventTouchUpInside];
     [_btnWarning setExclusiveTouch:YES];
    
    [_btnAddressBook addTarget:self.controller action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
    [_btnAddressBook setExclusiveTouch:YES];
    
    [_userInfo addTarget:self.controller action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    [_userInfo setExclusiveTouch:YES];
    
    UIView * view =[[UIView alloc] init];
    view.frame =CGRectMake(0, 0, ScreenWidth, 40);
    view.backgroundColor =self.navigationItem.titleView.backgroundColor;
    self.navigationItem.titleView=view;
    
    //姓名
    _homeTitle =[[UILabel alloc] initWithFrame:CGRectMake(0,0,280,20)];
    _homeTitle.text=[user.username stringByAppendingString:@",您好"];
    _homeTitle.font=[UIFont systemFontOfSize:18];
    _homeTitle.textColor=[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0];
    _homeTitle.backgroundColor=[UIColor clearColor];
    [view addSubview:_homeTitle];
    
    //“欢迎标题”
    _name =[[UILabel alloc] initWithFrame:CGRectMake(3,22,190,15)];
    _name.text=@"欢迎登录中国移动政务易";
    _name.textAlignment=NSTextAlignmentLeft;
    _name.font=[UIFont systemFontOfSize:12];
    _name.textColor=[UIColor grayColor];
    _name.backgroundColor=[UIColor clearColor];
    [view addSubview:_name];
    
    //单位名称
    _ecname =[[UILabel alloc] initWithFrame:CGRectMake(265,7,40,20)];
    _ecname.text=user.province;
    _ecname.font=[UIFont systemFontOfSize:18];
    _ecname.textAlignment=NSTextAlignmentLeft;
    _ecname.textColor=[UIColor grayColor];
    _ecname.backgroundColor=[UIColor clearColor];
    [view addSubview:_ecname];
    
    _mailsum.layer.cornerRadius = 10;
    _officesum.layer.cornerRadius=10;
     _labelChatCount.layer.cornerRadius = 10.0;
   

    //广告
    NSArray *arrImagePath =@[@"show_two.jpg",@"show_one.jpg",@"show_two.jpg",@"show_one.jpg"];
    NSMutableArray *arrItemp=[NSMutableArray new];
    for (int i = -1 ; i < 3; i++)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:[ToolUtils numToString:i]
                                                                   image:arrImagePath[i+1]
                                                                     tag:i];
        [arrItemp addObject:item];
    }
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(5, 160, ScreenWidth-10, 80)
                                                                    delegate:self.controller
                                                                  imageItems:arrItemp
                                                                      isAuto:YES
                                                                         num:3.0];
    bannerView.tag=0;
    [bannerView scrollToIndex:0];
    [_ScrollHome addSubview:bannerView];
    
    //发送Ec
    [((HomeController *)self.controller) sendEc];
//    [((HomeController *)self.controller) getCount];
    _mailsum.hidden=YES;
    _officesum.hidden=YES;
    
    [self.controller initWithData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [((HomeController *)self.controller) getCount];
     _ecname.text=user.province;
    
//显示时间
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *strTime =[dateFormatter stringFromDate:[NSDate date]];
    [_btnDate setTitle:strTime forState:UIControlStateNormal];
    _homeTitle.text=[user.username stringByAppendingString:@",您好"];
    _labelUsersAddress.text=[@"农历:" stringByAppendingString:[ToolUtils solarOrLunar:[NSDate date]]];
/*********/
    
    if([user.ecSgin isEqualToString:@"0"]){
        [((HomeController *)self.controller) sendEc];
         user.ecSgin=nil;
    }
    
    //未读即时消息刷新
    NSUserDefaults *userDeafults=[NSUserDefaults standardUserDefaults];
    int count =[userDeafults integerForKey:CHATMESSAGECOUNT(user.msisdn, user.eccode)];
    if (count<=0) {
        _labelChatCount.hidden=YES;
    }else {
        _labelChatCount.hidden=NO;
        _labelChatCount.text=[NSString stringWithFormat:@"%d",count];
    }
    //本地通知处理方法
    if (dicLocalNotificationInfo) [self performSelector:@selector(jumpScheduleView:) withObject:nil afterDelay:0.0f];
}

//首页传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"homeToIM"]) {

    }
}

/*控制首页scrollView是否可以滑动*/
- (void)viewDidAppear:(BOOL)animated{
     [self performSelector:@selector(setScrollViewContentSize) withObject:nil afterDelay:0.1f];
}

- (void)viewDidDisappear:(BOOL)animated{
}

- (void)setScrollViewContentSize{
    _ScrollHome.contentSize=CGSizeMake(0, 568-UITabBarHeight-NavigationBarHeight-20);
}
/*************************/
/*push到通讯录*/
- (void)HomeToAddressBookView{
    self.tabBarController.tabBar.hidden=YES;
    [self performSegueWithIdentifier:@"homeToAddress" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)jumpScheduleView:(NSNotification *)notification{
    
    self.tabBarController.selectedIndex=0;
    [self performSelector:@selector(homeToWarningDataView) withObject:nil afterDelay:0.3f];
}

-  (void)homeToWarningDataView{
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    NSString *Type= dicLocalNotificationInfo[@"warningType"];
    NSString *isUserHandAdd= dicLocalNotificationInfo[@"dataType"];
    if ([Type isEqualToString:@"0"]||[Type isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
        detaView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detaView animated:YES];
    }else if([Type isEqualToString:@"2"]||([Type isEqualToString:@"3"]&&![isUserHandAdd isEqualToString:@"0"])){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
        detaView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detaView animated:YES];
    }else if ([Type isEqualToString:@"2"]||([Type isEqualToString:@"3"]&&[isUserHandAdd isEqualToString:@"0"])){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
        detaView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detaView animated:YES];
    }
}

/*
 *实现回调方法
 *刷新未读条数
 */
-(void)getMessage:(NSNotification *)notification
{    
    NSString *isCheck =[[notification userInfo] objectForKey:@"isCheck"];
    if ([isCheck isEqualToString:@"1"])return;
    
    NSArray * arr=[notification object];
    int index =arr.count;
    NSUserDefaults *userDeafults=[NSUserDefaults standardUserDefaults];
    int count =[userDeafults integerForKey:CHATMESSAGECOUNT(user.msisdn,user.eccode)];
    [userDeafults setInteger:count+index forKey:CHATMESSAGECOUNT(user.msisdn,user.eccode)];
    [userDeafults synchronize];
    
    self.labelChatCount.hidden=NO;
    self.labelChatCount.text=[NSString stringWithFormat:@"%d",count+index];
}

- (void)address{}
@end
