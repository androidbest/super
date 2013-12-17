//
//  SmsView.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "SmsView.h"
#import "SmsController.h"
#import "optionAddress.h"
#import "SMSModeView.h"
@interface SmsView ()

@end

@implementation SmsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        SmsController *sms=[SmsController new];
        sms.smsView=self;
        self.controller=sms;
    }
    return self;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SMSToSMSMode"]) {
        SMSModeView * view =(SMSModeView *)send;
        view.SMSModeViewDelegate=self.controller;
       
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [_btnSend addTarget:self.controller action:@selector(btnSendSMS:) forControlEvents:UIControlEventTouchUpInside];
    _btnSend.layer.masksToBounds = YES;
    _btnSend.layer.cornerRadius = 6.0;
    
    [_textSMSContent setText:@"请输入内容"];
    [_textSMSContent setTextColor:[UIColor grayColor]];
    
    [_btnAddPeople addTarget:self.controller action:@selector(btnAddPeople:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnECCode addTarget:self.controller action:@selector(btnECCode:) forControlEvents:UIControlEventTouchUpInside];
    [_btnECCode setTitle:user.ecname forState:UIControlStateNormal];

    [_templates addTarget:self.controller action:@selector(templates) forControlEvents:UIControlEventTouchUpInside];
    
    [_segControl addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    

    
    _tableViewPeople.delegate=self.controller;
    _tableViewPeople.dataSource=self.controller;
    
    _textSMSContent.delegate=self.controller;
	// Do any additional setup after loading the view.
}


//点击背景取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textSMSContent resignFirstResponder];
}

- (void)endTextEditing{

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   if (self.navigationController.navigationBarHidden) self.navigationController.navigationBarHidden=NO;
}

- (void)segmentAction:(id)sender{

}

-(void)btnSendSMS:(id)sender{

}

- (void)btnAddPeople:(id)sender{
    
}

- (void)btnECCode:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dissmissFromHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
