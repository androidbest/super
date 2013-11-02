//
//  InfoDetailsView.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "InfoDetailsView.h"
#import "InfoDetailsController.h"
@interface InfoDetailsView ()

@end

@implementation InfoDetailsView

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
        InfoDetailsController *contro =[InfoDetailsController new];
        contro.infoView=self;
        self.controller=contro;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=_infoDeta.Name;
    _labelName.text =_infoDeta.Name;
    _labelTel.text=_infoDeta.tel;
    
    
    if ([_infoDeta.area isEqualToString:@"null"]) {
        _labelGroup.text=_infoDeta.area;
    }else{
    _labelGroup.text=@"";
    }
    
 
    
    if ([_infoDeta.job isEqualToString:@"null"]) {
        _labelJob.text=_infoDeta.job;
    }else{
        _labelJob.text=@"";
    }
    
    
    [_btnSendSMS addTarget:self.controller action:@selector(SendSMS:) forControlEvents:UIControlEventTouchUpInside];
    _btnSendSMS.layer.masksToBounds = YES;
    _btnSendSMS.layer.cornerRadius = 5.0;
    
    [_btnCall addTarget:self.controller action:@selector(CallPhone:) forControlEvents:UIControlEventTouchUpInside];
    _btnCall.layer.masksToBounds = YES;
    _btnCall.layer.cornerRadius = 5.0;
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    // here&apos;s where you can customize the font size
//    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
//    [titleLabel setTextColor:[UIColor redColor]];
//    [titleLabel setText:self.title];
//    [titleLabel sizeToFit];
//    CGPoint center =[self.navigationItem.titleView center];
//    [titleLabel setCenter:center];
//    [self.navigationItem setTitleView:titleLabel];
	// Do any additional setup after loading the view.
}

- (void)SendSMS:(id)sender{

}

- (void)CallPhone:(id)sender{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
