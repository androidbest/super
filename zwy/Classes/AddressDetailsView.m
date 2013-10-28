//
//  AddressDetailsView.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "AddressDetailsView.h"
#import "AddressDetailsController.h"
@interface AddressDetailsView ()

@end

@implementation AddressDetailsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-  (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        AddressDetailsController *contro =[AddressDetailsController new];
        contro.detailsView=self;
        self.controller=contro;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0, 0.0, 20, 20.0);
        [backButton setImage:[UIImage imageNamed:@"navigation_Edit_over"] forState:UIControlStateNormal];
        backButton.titleLabel.font=[UIFont systemFontOfSize:14];
        backButton.tag=0;
        [backButton addTarget:self.controller action:@selector(RightDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem=temporaryBarButtonItem;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textName.text=_dicAddressData[@"name"];
    self.textTel.text=_dicAddressData[@"tel"];
    _textName.enabled=NO;
    _textTel.enabled=NO;
    self.title=self.textName.text;
    
    [_btnSendSMS addTarget:self.controller action:@selector(SendSMS) forControlEvents:UIControlEventTouchUpInside];
    _btnSendSMS.layer.masksToBounds = YES;
    _btnSendSMS.layer.cornerRadius = 5.0;
    
    
    [_btnCallTel  addTarget:self.controller action:@selector(CallTel) forControlEvents:UIControlEventTouchUpInside];
    _btnCallTel.layer.masksToBounds = YES;
    _btnCallTel.layer.cornerRadius = 5.0;
	// Do any additional setup after loading the view.
}

/*编辑信息*/
- (void)RightDown:(UIButton *)sender{
}

/*刷新上级列表*/
- (void)updateAddressBook{
}

/*发送短信*/
- (void)SendSMS{
}

/*拨打电话*/
- (void)CallTel{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
