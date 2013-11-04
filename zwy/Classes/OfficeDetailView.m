//
//  OfficeDetailView.m
//  zwy
//
//  Created by wangshuang on 10/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "OfficeDetailView.h"
#import "OfficeDetailController.h"
#import "OfficeAddressView.h"

@interface OfficeDetailView ()

@end

@implementation OfficeDetailView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        OfficeDetailController *office=[OfficeDetailController new];
        office.officedetailView=self;
        self.controller=office;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.controller initData:self];
    if([_data isKindOfClass:[OfficeView class]]){
        _info=((OfficeView *)_data).docContentInfo;
    }else if([_data isKindOfClass:[DaiBanView class]]){
        _info=((DaiBanView *)_data).docContentInfo;
    }
    
    if([_info.type isEqualToString:@"0"]){
    self.title=@"待 办 公 文";
        _banli.text=@"办理意见:";
        _noagree.hidden=YES;
        _agree.hidden=YES;
        _noargreelable.hidden=YES;
        _agreelabel.hidden=YES;
        _lable1.hidden=YES;
        [_textContent setText:@"请输入内容"];
        [_textContent setTextColor:[UIColor grayColor]];
        
        
    }else if([_info.type isEqualToString:@"1"]){
        _banli.hidden=YES;
        _nextstep.hidden=YES;
        _content.hidden=YES;
        _selectHandle.hidden=YES;
        _banliLine.hidden=YES;
        _noagree.hidden=YES;
        _agree.hidden=YES;
        _noargreelable.hidden=YES;
        _agreelabel.hidden=YES;
        _lable1.hidden=YES;
        _okbtn.hidden=YES;
        _addPerson.hidden=YES;
        _lable1.hidden=YES;
        _lable2.hidden=YES;
    self.title=@"已 办 公 文";
    }else if([_info.type isEqualToString:@"2"]){
    self.title=@"待 审 公 文";
        _banli.text=@"审核意见:";
        [_textContent setText:@"请输入内容"];
        [_textContent setTextColor:[UIColor grayColor]];
    }else{
    self.title=@"已 审 公 文";
        _banli.hidden=YES;
        _nextstep.hidden=YES;
        _content.hidden=YES;
        _selectHandle.hidden=YES;
        _banliLine.hidden=YES;
        _noagree.hidden=YES;
        _agree.hidden=YES;
        _noargreelable.hidden=YES;
        _agreelabel.hidden=YES;
        _lable1.hidden=YES;
        _okbtn.hidden=YES;
        _addPerson.hidden=YES;
        _lable1.hidden=YES;
        _lable2.hidden=YES;
    }
    
    UIView * view =[[UIView alloc] init];
    view.frame =CGRectMake(0, 0, ScreenWidth, 44);
    view.backgroundColor =self.navigationItem.titleView.backgroundColor;
    _navigationBar.topItem.titleView=view;
    
    //标题
    _titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0,5,300,15)];
    _titleLab.text=_info.title;
    _titleLab.font=[UIFont boldSystemFontOfSize:13];
    _titleLab.textColor=[UIColor blackColor];
    _titleLab.backgroundColor=[UIColor clearColor];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:_titleLab];
    
    
    //发送者
    _sender =[[UILabel alloc] initWithFrame:CGRectMake(0,25,135,15)];
    _sender.textAlignment=NSTextAlignmentRight;
    _sender.font=[UIFont systemFontOfSize:12];
    _sender.textColor=[UIColor grayColor];
    _sender.backgroundColor=[UIColor clearColor];
    [view addSubview:_sender];
    
    //时间
    _time =[[UILabel alloc] initWithFrame:CGRectMake(120,25,150,15)];
    _time.text=[NSString stringWithFormat:@"时间:%@",_info.time];
    _time.textAlignment=NSTextAlignmentCenter;
    _time.font=[UIFont systemFontOfSize:12];
    _time.textColor=[UIColor grayColor];
    _time.backgroundColor=[UIColor clearColor];
    [view addSubview:_time];
    
    [_okbtn setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _okbtn.layer.masksToBounds = YES;
    _okbtn.layer.cornerRadius = 6.0;
//    _okbtn.layer.borderWidth = 0.5;
    _okbtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //请求数据
    [((OfficeDetailController *)self.controller) reqData];
    
    //添加人员或部门
    [_addPerson addTarget:self.controller action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    
    //点击正文
    [_docText addTarget:self.controller action:@selector(docText) forControlEvents:UIControlEventTouchUpInside];
    
    //公文流程
    [_docFlow addTarget:self.controller action:@selector(jumpDocFlow) forControlEvents:UIControlEventTouchUpInside];
    
    //附件下载
    [_accessory addTarget:self.controller action:@selector(optionAccessory) forControlEvents:UIControlEventTouchUpInside];
    
    //下一步办理人
    [_selectHandle addTarget:self.controller action:@selector(selectHandle) forControlEvents:UIControlEventTouchUpInside];
    
    //确定
    [_okbtn addTarget:self.controller action:@selector(okbtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_agree addTarget:self.controller action:@selector(selectAudit:) forControlEvents:UIControlEventTouchUpInside];
    _agree.tag=1;
    
    [_noagree addTarget:self.controller action:@selector(selectAudit:) forControlEvents:UIControlEventTouchUpInside];
    _noagree.tag=2;
    
    //编辑联系人
    [_selecter addTarget:self.controller action:@selector(selecter) forControlEvents:UIControlEventTouchUpInside];
    
    //内容长度
    _textContent.delegate=self.controller;

    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeybord)];
    [_scrollerContent addGestureRecognizer:tap];
}

-(void)selectAudit:(UIButton*)btn{}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"officeDetaToaddress"]) {
        OfficeAddressView * view  =(OfficeAddressView *)send;
        view.officeDelegate=self.controller;
    }else if([segue.identifier isEqualToString:@"docdetailtodocflow"]){
        UIViewController *send=segue.destinationViewController;
        [send setValue:self.info forKey:@"data"];
    }else if([segue.identifier isEqualToString:@"detailtodoccontent"]){
        UIViewController *send=segue.destinationViewController;
        [send setValue:self.detailInfo forKey:@"detailInfo"];
}
}

//点击背景取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textContent resignFirstResponder];
}

- (void)hiddenKeybord{
  [_textContent resignFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated{
    [self performSelector:@selector(scrollerViewScrollingSize) withObject:self afterDelay:0.1];
    
}

- (void)scrollerViewScrollingSize{
_scrollerContent.contentSize =CGSizeMake(320, 460);
}

-(void)jumpDocFlow{}

-(void)optionAccessory{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
