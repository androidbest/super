//
//  MassTextingView.m
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MassTextingView.h"
#import "MassTextingController.h"
#import "MassMyAddressView.h"
#import "MassAddPeopleView.h"
#import "optionAddress.h"
#import "SMSModeView.h"
@interface MassTextingView ()

@end

@implementation MassTextingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        MassTextingController *contro =[MassTextingController new];
        contro.massView=self;
        self.controller=contro;
         self.tabBarItem=[self.tabBarItem initWithTitle:@"短信群发" image:[UIImage imageNamed:@"tabItem_SMS_out"] selectedImage:[UIImage imageNamed:@"tabItem_SMS_over"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(endTextEditing)];
    [self.view addGestureRecognizer:tap];
    
    [_BtnGroupAddress addTarget:self.controller action:@selector(BtnGroupAddress) forControlEvents:UIControlEventTouchUpInside];
    [_BtnGroupAddress setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 0)];
    
    [_btnMyAddress addTarget:self.controller action:@selector(btnMyAddress) forControlEvents:UIControlEventTouchUpInside];
    [_btnSMSMode addTarget:self.controller action:@selector(btnSMSMode) forControlEvents:UIControlEventTouchUpInside];
    [_btnSelfAdd addTarget:self.controller action:@selector(btnSelfAdd) forControlEvents:UIControlEventTouchUpInside];
    [_btnClear addTarget:self.controller action:@selector(btnClear) forControlEvents:UIControlEventTouchUpInside];
    [_btnSend addTarget:self.controller action:@selector(btnSend) forControlEvents:UIControlEventTouchUpInside];
    _btnSend.layer.masksToBounds = YES;
    _btnSend.layer.cornerRadius = 5.0;
    
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_btnSign addTarget:self.controller action:@selector(btnSign:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableViewPeople.dataSource=self.controller;
    _tableViewPeople.delegate=self.controller;
    
    _textSendContext.delegate=self.controller;
    _textSendContext.text=@"请编辑内容";
    _textSendContext.textColor=[UIColor grayColor];
    
    
    
    [_textsign setDelegate:self.controller];
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    _textsign.text =[defaults objectForKey:@"signContent"];
    
    [self.controller initWithData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.tabBarController.tabBar.hidden=NO;
}

-(void)endTextEditing{}


- (void)btnSign:(UIButton *)sender{
    
}

- (void)massTextInfoFromWarningViewWithGreetingID:(GreetDetaInfo *)GreetInfo{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     UIViewController *send=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"massToAddress"]) {
        MassMyAddressView * ViewController =(MassMyAddressView *)send;
        ViewController.MassDelegate=self.controller;
    }else if([segue.identifier isEqualToString:@"MassTextingToMassAdd"]){
        MassAddPeopleView *viewController =(MassAddPeopleView *)send;
        viewController.MassAddPeopleDelegate=self.controller;
    }else if ([segue.identifier isEqualToString:@"MassToOptionAddress"]){
        optionAddress *viewController =(optionAddress *)send;
        viewController.optionDelegate=self.controller;
    }else if ([segue.identifier isEqualToString:@"MassToSMSMode"]){
        SMSModeView *ViewController =(SMSModeView *)send;
        ViewController.SMSModeViewDelegate=self.controller;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
