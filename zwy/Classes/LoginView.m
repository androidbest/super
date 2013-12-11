//
//  LoginView.m
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "LoginView.h"
#import "LoginController.h"
#import "HomeView.h"
#import "HomeScrollView.h"
#import "BaseTabbar.h"
@interface LoginView ()

@end

@implementation LoginView

-(id)initWithCoder:(NSCoder *)aDecoder{

    self=[super initWithCoder:aDecoder];
    if(self){
        LoginController *login=[LoginController new];
        login.logView=self;
        self.controller=login;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
    if([appConfig boolForKey:@"isLogin"]){
        [self performSelector:@selector(jumpHome) withObject:nil afterDelay:0.0f];
    }
    
    
    //引导页
	[self guidePage];
    //初使化数据
    [self.controller initData:self];
    _msisdn.delegate=self.controller;
    
//        UITapGestureRecognizer *oneFingerOneTaps =
//        [[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(oneFingerOneTaps)];
//        [oneFingerOneTaps setNumberOfTouchesRequired:1];
//        [[self view] addGestureRecognizer:oneFingerOneTaps];
    

    //状态栏颜色
    [_statusbar setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
    //登录
    [_loginBtn addTarget:self.controller action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 6.0;
    _loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [_verifyBtn addTarget:self.controller action:@selector(getVerify) forControlEvents:UIControlEventTouchUpInside];
    _verifyBtn.layer.masksToBounds = YES;
    _verifyBtn.layer.cornerRadius = 6.0;
    _verifyBtn.layer.borderWidth = 1;
    _verifyBtn.layer.borderColor = [[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0] CGColor];
    
    
    if([appConfig boolForKey:@"isLogin"]){
        if(coverView){
            coverView.hidden=NO;
        }else{
            coverView=[[UIView alloc] initWithFrame:self.view.frame];
            [coverView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:coverView];
        }
    }
    
}

-(void)jumpHome{
//  [self performSegueWithIdentifier:@"logintogethome" sender:self];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
   /* HomeScrollView *homeView = [storyboard instantiateViewControllerWithIdentifier:@"HomeScrollView"];*/
    BaseTabbar *homeView =[storyboard instantiateViewControllerWithIdentifier:@"zwyhome"];
    [self presentViewController:homeView animated:NO completion:nil];
}


//点击背景取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_msisdn resignFirstResponder];
    [_verifyField resignFirstResponder];
}

-(void)getVerify{}
-(void)oneFingerOneTaps{}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
_msisdn.text=@"";
_verifyField.text=@"";
[_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
[((LoginController *)self.controller) stopTimer];
    [_verifyBtn setEnabled:YES];
}

//引导页
-(void)guidePage{
    
    //默认配置文件
    NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
    if([appConfig boolForKey:@"firstLaunch"]){
        return;
    }
    
    //创建ScrollView / Pagecontrol
    CGRect frame = CGRectMake(130, ScreenHeight-20, 60, 10);
    _pageControl = [[CustomPageControl alloc] initWithFrame:frame];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    _pageControl.numberOfPages = 3;
    frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.delegate = self.controller;
    _scrollView.autoresizesSubviews = YES;
    _scrollView.canCancelContentTouches = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize=CGSizeMake(ScreenWidth*3, 0);
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
    if(iPhone5){
        for (int i=0; i<3; i++) {
            UIImageView * leadView =[[UIImageView alloc] init];
            NSString * strPath =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide11360%d",i+1] ofType:@"png"];
            leadView.frame=CGRectMake(320*i, 0, ScreenWidth, ScreenHeight);
            leadView.image =[UIImage imageWithContentsOfFile:strPath];
            [self.scrollView addSubview:leadView];
        }
    }else{
        for (int i=0; i<3; i++) {
            UIImageView * leadView =[[UIImageView alloc] init];
            NSString * strPath =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide9600%d",i+1] ofType:@"png"];
            leadView.frame=CGRectMake(320*i, 0, ScreenWidth, ScreenHeight);
            leadView.image =[UIImage imageWithContentsOfFile:strPath];
            [self.scrollView addSubview:leadView];
        }
    }
    UIButton * btnJion=[UIButton buttonWithType:UIButtonTypeCustom];
    btnJion.frame=CGRectMake(640+80, ScreenHeight-65, 160, 40);
    [btnJion addTarget:self.controller action:@selector(dismissLeadView:) forControlEvents:UIControlEventTouchUpInside];
    [btnJion setBackgroundColor:[UIColor colorWithRed:0.34 green:0.76 blue:0.91 alpha:1.0]];
    [btnJion setTitle:@"立即体验" forState:UIControlStateNormal];
    [btnJion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnJion.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    [self.scrollView addSubview:btnJion];

   }
@end
