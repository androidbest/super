//
//  MailDetail.m
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MailDetail.h"
#import "MailDetailController.h"
@interface MailDetail ()

@end

@implementation MailDetail

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        MailDetailController *mail=[MailDetailController new];
        mail.mailDetailView =self;
        self.controller=mail;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initData:self];
    
    
    if([_data isKindOfClass:[MailView class]]){
        _info=((MailView *)_data).info;
    }else if([_data isKindOfClass:[MailView class]]){
        _info=((DaiBanView *)_data).pubilcMailDetaInfo;
    }
    
    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  
    
//    _delegete=_info.mailController;
    
    //初始化状态
    [((MailDetailController *)self.controller) initStatus];
    
    if([_info.type isEqualToString:@"0"]){
        self.title=@"意 见 办 理";
        [_selecthandle setTitle:@"自办" forState:UIControlStateNormal];
        _contentHint.text=@"办理意见:";
        [_brnOptionPeople setEnabled:NO];
    }else{
        [_selecthandle setTitle:@"直接审核" forState:UIControlStateNormal];
        self.title=@"意 见 审 核";
        _contentHint.text=@"审核意见:";
        [_brnOptionPeople setEnabled:YES];
        [_brnOptionPeople setTitle:@"请选择联系人" forState:UIControlStateNormal];
    }
    
//    UITapGestureRecognizer *oneFingerOneTaps =
//    [[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(oneFingerOneTaps)];
//    [oneFingerOneTaps setNumberOfTouchesRequired:1];
//    [[self view] addGestureRecognizer:oneFingerOneTaps];
    
    _content.text=_info.content;
    _content.font =[UIFont systemFontOfSize:16];
    UIView * view =[[UIView alloc] init];
    view.frame =CGRectMake(0, 0, ScreenWidth, 44);
    view.backgroundColor =self.navigationItem.titleView.backgroundColor;
    _secondMenu.topItem.titleView=view;
    
    //来人电话
    _phoneLab =[[UILabel alloc] initWithFrame:CGRectMake(20,15,150,15)];
    _phoneLab.text=[NSString stringWithFormat:@"来自(%@)",_info.msisdn];
    _phoneLab.font=[UIFont boldSystemFontOfSize:13];
    _phoneLab.textColor=[UIColor grayColor];
    _phoneLab.backgroundColor=[UIColor clearColor];
    _phoneLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:_phoneLab];
    
    //时间
    _time =[[UILabel alloc] initWithFrame:CGRectMake(150,16,130,15)];
    _time.text=[NSString stringWithFormat:@"时间:%@",_info.senddate];
    _time.textAlignment=NSTextAlignmentCenter;
    _time.font=[UIFont systemFontOfSize:12];
    _time.textColor=[UIColor grayColor];
    _time.backgroundColor=[UIColor clearColor];
    [view addSubview:_time];
    
    //输入内容
    _inputContent.delegate=self.controller;
    [_inputContent setText:@"请输入内容"];
    [_inputContent setTextColor:[UIColor grayColor]];
    
    [_selecthandle addTarget:self.controller action:@selector(selectHandle) forControlEvents:UIControlEventTouchUpInside];
    
    [_okbtn addTarget:self.controller action:@selector(okbtn) forControlEvents:UIControlEventTouchUpInside];
    [_okbtn setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _okbtn.layer.masksToBounds = YES;
    _okbtn.layer.cornerRadius = 6.0;
//    _okbtn.layer.borderWidth = 0.5;
    _okbtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [_brnOptionPeople addTarget:self.controller action:@selector(brnOptionPeople) forControlEvents:UIControlEventTouchUpInside];
}

//点击背景取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_inputContent resignFirstResponder];
}

-(void)selectHandle{}

-(void)oneFingerOneTaps{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okbtn:(UIButton *)sender {
}
@end
