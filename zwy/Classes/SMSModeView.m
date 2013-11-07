//
//  SMSModeView.m
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "SMSModeView.h"
#import "SMSModeController.h"
#import "SMSModeDetaView.h"
@interface SMSModeView ()

@end

@implementation SMSModeView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        SMSModeController *contro =[SMSModeController new];
        contro.smsView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initData:self];
    _tableViewSMSMode.delegate=self.controller;
    _tableViewSMSMode.dataSource=self.controller;
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view.
    
    [((SMSModeController*)self.controller) initReqData];
    
}

-(void)initReqData{}
- (void)returnSMSModeInfo:(NSString *)SMSContent{}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 //   UIViewController *send=segue.destinationViewController;
//    if ([segue.identifier isEqualToString:@"massToAddress"]) {
//        SMSModeDetaView * viewController =(SMSModeDetaView *)send;
//    
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
