//
//  SMSModeDetaView.m
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "SMSModeDetaView.h"
#import "SMSModeDetaController.h"
@interface SMSModeDetaView ()

@end

@implementation SMSModeDetaView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        SMSModeDetaController *contro =[SMSModeDetaController new];
        contro.smsView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initData:self];
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    _naviBar.topItem.title=_info.SmsName;
    [_tableViewModeInfo setDataSource:self.controller];
    [_tableViewModeInfo setDelegate:self.controller];
	// Do any additional setup after loading the view.
    [self.controller initWithData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)returnSMSModeDetaInfo:(NSString *)SMSContent{

}
@end
