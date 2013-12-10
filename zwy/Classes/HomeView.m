//
//  HomeView.m
//  zwy
//
//  Created by sxit on 9/27/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#define DOCUMENTS(userPath)  [NSString stringWithFormat:@"%@/%@",DocumentsDirectory,userPath];


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
@interface HomeView ()
//@property (strong ,nonatomic)AddressTabbar *addTabbar;
//@property (strong ,nonatomic)InformationView *infomasView;
//@property (strong ,nonatomic)SmsView *smssView;
//@property (strong ,nonatomic)OfficeView *officesView;
//@property (strong ,nonatomic)MeettingView *meetView;
//@property (strong ,nonatomic)MailView *mailsView;
//@property (strong ,nonatomic)scheduleView *schedulesView;
@end

@implementation HomeView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
       self.tabBarItem=[self.tabBarItem initWithTitle:@"首页" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
        
        HomeController *home=[HomeController new];
        home.HomeView=self;
        self.controller=home;
        
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(jumpScheduleView:)
                                                    name:@"homeToWarningView"
                                                  object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[_information setBackgroundColor:[UIColor colorWithRed:0.41 green:0.47 blue:0.98 alpha:1.0]];
    [_notice setBackgroundColor:[UIColor colorWithRed:0.63 green:0.31 blue:0.70 alpha:1.0]];
    [_sms setBackgroundColor:[UIColor colorWithRed:0.95 green:0.50 blue:0.12 alpha:1.0]];
    [_office setBackgroundColor:[UIColor colorWithRed:0.23 green:0.54 blue:0.79 alpha:1.0]];
    [_mail setBackgroundColor:[UIColor colorWithRed:0.25 green:0.50 blue:0.98 alpha:1.0]];
    [_meetting setBackgroundColor:[UIColor colorWithRed:0.44 green:0.67 blue:0 alpha:1.0]];
    
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
    
    UIView * view =[[UIView alloc] init];
    view.frame =CGRectMake(0, 0, ScreenWidth, 40);
    view.backgroundColor =self.navigationItem.titleView.backgroundColor;
    self.navigationItem.titleView=view;
    
    //标题
    _homeTitle =[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,25)];
    _homeTitle.text=@"政务易";
    _homeTitle.font=[UIFont systemFontOfSize:25];
    _homeTitle.textColor=[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0];
    _homeTitle.backgroundColor=[UIColor clearColor];
    [view addSubview:_homeTitle];
    
    //姓名
    _name =[[UILabel alloc] initWithFrame:CGRectMake(110,5,190,15)];
    _name.text=user.username;
    _name.textAlignment=NSTextAlignmentRight;
    _name.font=[UIFont systemFontOfSize:12];
    _name.textColor=[UIColor grayColor];
    _name.backgroundColor=[UIColor clearColor];
    [view addSubview:_name];
    
    //单位名称
    _ecname =[[UILabel alloc] initWithFrame:CGRectMake(110,22,190,15)];
    _ecname.text=user.ecname;
    _ecname.font=[UIFont systemFontOfSize:12];
    _ecname.textAlignment=NSTextAlignmentRight;
    _ecname.textColor=[UIColor grayColor];
    _ecname.backgroundColor=[UIColor clearColor];
    [view addSubview:_ecname];
    
    _mailsum.layer.cornerRadius = 10;
    _officesum.layer.cornerRadius=10;
    

    //广告
    UIImageView *imageView =[[UIImageView alloc] init];
    imageView.frame=CGRectMake(5, 5, 310, 150);
    imageView.image=[UIImage imageNamed:@"about"];
    [_ScrollHome addSubview:imageView];
    
    //发送Ec
    [((HomeController *)self.controller) sendEc];
//    [((HomeController *)self.controller) getCount];
    _mailsum.hidden=YES;
    _officesum.hidden=YES;
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    _name.text=user.username;
    _ecname.text=user.ecname;
//    [((HomeController *)self.controller) sendEc];
    [((HomeController *)self.controller) getCount];
    
    
    if([user.ecSgin isEqualToString:@"0"]){
        [((HomeController *)self.controller) sendEc];
//        [((HomeController *)self.controller) getCount];
        user.ecSgin=nil;
    }
    
    if (isLocalNotification) [self performSelector:@selector(jumpScheduleView:) withObject:nil afterDelay:0.0f];
}

//首页传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

/*控制首页scrollView是否可以滑动*/
- (void)viewDidAppear:(BOOL)animated{
    _ScrollHome.contentSize=CGSizeMake(0, 670);
     [(BaseTabbar *)self.tabBarController TabbarScrollEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [(BaseTabbar *)self.tabBarController TabbarScrollEnabled:NO];
}
/*************************/


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
@end
