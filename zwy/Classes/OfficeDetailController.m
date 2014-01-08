//
//  OfficeDetailController.m
//  zwy
//
//  Created by wangshuang on 10/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "OfficeDetailController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "AnalysisData.h"
#import "PackageData.h"
#import "DocContentInfo.h"
#import "officeDetaInfo.h"
#import "OfficeInfo.h"
#import "OfficeAddressView.h"
#import "optionInfo.h"
#import "GroupDetaInfo.h"
#import "PeopleDedaInfo.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "peopleDeleteView.h"


@implementation OfficeDetailController{
    NSString *officeID;
    NSString *officeListNotifinfo;
    NSMutableArray *allDidPeopleID;
    OfficeInfo * offInfo;
    int fileNum;
    NSString * status;
    DocContentInfo *docContentInfo;
    NSString *isWord;
    NSString *filePath_;
    NSString *anditStatus;
    
    NSString *strAllGroupID;
    NSString *strAllGroupName;
    NSString *strAllPeopleID;
    NSString *strAllpeopleName;
    
    NSString *strAllInfo;
    
    NSString *sign;
}
-(id)init{
    self=[super init];
    if(self){
        strAllInfo=@"";
        status=@"0";
        strAllGroupID=@"";
        strAllGroupName=@"";
        strAllPeopleID=@"";
        strAllpeopleName=@"";
        anditStatus=@"1";
        officeListNotifinfo =@"officeListNotifinfo";
        self.arrDidAllPeople =[[NSMutableArray alloc] init];
        allDidPeopleID =[[NSMutableArray alloc] init];
        
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(officeListData:)
                                                    name:officeListNotifinfo
                                                  object:self];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    [self.HUD hide:YES];
    if(dic){
        if([sign isEqualToString:@"1"]){
            docContentInfo=[AnalysisData getDocContentInfo:dic];
            self.officedetailView.detailInfo=docContentInfo;
            officeID=docContentInfo.ID;
            self.officedetailView.sender.text=[NSString stringWithFormat:@"发送者:%@",docContentInfo.name];
        }else{
            DocContentInfo *info=self.officedetailView.info;
            if([info.type isEqualToString:@"0"]){
                RespInfo *info=[AnalysisData ReTurnInfo:dic];
                if([info.respCode isEqualToString:@"0"]){
                    [self.officedetailView.info.arr removeObjectAtIndex:self.officedetailView.info.row];
                    [self.officedetailView.info.listview reloadData];
                    [self.officedetailView.navigationController popViewControllerAnimated:YES];
                }else{
                    [ToolUtils alertInfo:@"办理失败"];
                }
            }else if([info.type isEqualToString:@"2"]){
                RespInfo *info=[AnalysisData ReTurnInfo:dic];
                if([info.respCode isEqualToString:@"0"]){
                    [self.officedetailView.info.arr removeObjectAtIndex:self.officedetailView.info.row];
                    [self.officedetailView.info.listview reloadData];
                    [self.officedetailView.navigationController popViewControllerAnimated:YES];
                }else{
                    [ToolUtils alertInfo:@"审核失败"];
                }
            }
        }
        }else{
        [ToolUtils alertInfo:requestError];
    }
}

//选择通讯录回调
- (void)returnDidAddress:(NSArray *)arr{
    NSObject * obj;
    for (int i=0; i<arr.count; i++) {
        obj=arr[i];
        if ([obj isKindOfClass:[GroupDetaInfo class]]) {
            
            /******************/
            if(![allDidPeopleID containsObject:[(GroupDetaInfo *)obj groupId]]){
                [allDidPeopleID addObject:[(GroupDetaInfo *)obj groupId]];
                [_arrDidAllPeople addObject:obj];
                
                if ([strAllInfo isEqualToString:@""]) strAllInfo=[(GroupDetaInfo *)obj groupName];
                else strAllInfo=[NSString stringWithFormat:@"%@,%@",strAllInfo,[(GroupDetaInfo *)obj groupName]];
                
//                if ([strAllGroupID isEqualToString:@""])strAllGroupID=[(GroupDetaInfo *)obj groupId];
//                else strAllGroupID =[NSString stringWithFormat:@"%@,%@",strAllGroupID,[(GroupDetaInfo *)obj groupId]];
            }
            /******************/
            
        }else{
            
            /******************/
            if(![allDidPeopleID containsObject:[(PeopleDedaInfo *)obj userTel]]){
                [allDidPeopleID addObject:[(PeopleDedaInfo *)obj userTel]];
                [_arrDidAllPeople addObject:obj];
                
                if ([strAllInfo isEqualToString:@""])strAllInfo=[(PeopleDedaInfo *)obj userName];
                else strAllInfo=[NSString stringWithFormat:@"%@,%@",strAllInfo,[(PeopleDedaInfo *)obj userName]];
                
//                if ([strAllPeopleID isEqualToString:@""])strAllPeopleID =[(PeopleDedaInfo *)obj userTel];
//                else strAllPeopleID =[NSString stringWithFormat:@"%@,%@",strAllPeopleID,[(PeopleDedaInfo *)obj userTel]];
//                
//                if ([strAllpeopleName isEqualToString:@""])strAllpeopleName =[(PeopleDedaInfo *)obj userName];
//                else strAllpeopleName =[NSString stringWithFormat:@"%@,%@",strAllpeopleName,[(PeopleDedaInfo *)obj userName]];
                
            }
            /******************/
            
        }
    }
    [self.officedetailView.selecter setTitle:strAllInfo forState:UIControlStateNormal];
}


//编辑联系人回调
- (void)returnPeoPleEditInfo:(NSMutableArray *)array{
    strAllInfo=@"";
    _arrDidAllPeople =NULL;
    _arrDidAllPeople=[[NSMutableArray alloc] init];
    allDidPeopleID=NULL;
    allDidPeopleID=[[NSMutableArray alloc] init];

    [self returnDidAddress:array];
}


//
- (void)selecter{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    peopleDeleteView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"peopleDeleteView"];
    [self.officedetailView.navigationController pushViewController:detaView animated:YES];
    detaView.arrAllInfo=_arrDidAllPeople;
    detaView.peopleDeleteDelegate=self;
}

//查看正文
-(void)docText{
    [self initBackBarButtonItem:self.officedetailView];
    [self.officedetailView performSegueWithIdentifier:@"detailtodoccontent" sender:self.officedetailView];
}

//下一步骤
-(void)selectHandle{
   
    if ([user.ecsystem isEqualToString:@"countrywide"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"办理结束", @"交办他人",@"上报领导",nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:self.officedetailView.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"办理结束", @"下一步办理人",@"报领导审批",nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:self.officedetailView.view];
    }
    

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *type=self.officedetailView.info.type;
    if (buttonIndex==0) {
       status=@"0";
        [self.officedetailView.selectHandle setTitle:@"办理结束" forState:UIControlStateNormal];
        [self.officedetailView.addPerson setEnabled:NO];
        [self.officedetailView.selecter setEnabled:NO];
        [self.officedetailView.selecter setTitle:@"" forState:UIControlStateNormal];
        strAllGroupID=@"";
        strAllGroupName=@"";
        strAllPeopleID=@"";
        strAllpeopleName=@"";
        [_arrDidAllPeople removeAllObjects];
        self.officedetailView.addPerson.hidden=YES;
        self.officedetailView.lable2.hidden=YES;
        if([type isEqualToString:@"0"]){
            CGRect banli=self.officedetailView.banli.frame;
            banli.origin.y=180;
            self.officedetailView.banli.frame=banli;
            CGRect text=self.officedetailView.textContent.frame;
            text.origin.y=202;
            self.officedetailView.textContent.frame=text;
        }else if([type isEqualToString:@"2"]){
            
            self.officedetailView.lable1.hidden=YES;
            
            CGRect banli=self.officedetailView.banli.frame;
            banli.origin.y=209;
            self.officedetailView.banli.frame=banli;
            CGRect text=self.officedetailView.textContent.frame;
            text.origin.y=230;
            self.officedetailView.textContent.frame=text;
            
            
            CGRect argBtn=self.officedetailView.agree.frame;
            argBtn.origin.y=170;
            self.officedetailView.agree.frame=argBtn;
            CGRect noagreeBtn=self.officedetailView.noagree.frame;
            noagreeBtn.origin.y=170;
            self.officedetailView.noagree.frame=noagreeBtn;
            CGRect _agreelabel=self.officedetailView.agreelabel.frame;
            _agreelabel.origin.y=170;
            self.officedetailView.agreelabel.frame=_agreelabel;
            CGRect _noargreelable=self.officedetailView.noargreelable.frame;
            _noargreelable.origin.y=170;
            self.officedetailView.noargreelable.frame=_noargreelable;
            CGRect _lable1=self.officedetailView.lable1.frame;
            _lable1.origin.y=205;
            self.officedetailView.lable1.frame=_lable1;
        }
    }
    else if (buttonIndex==1) {
       status=@"1";
        [self.officedetailView.selectHandle setTitle:@"下一步办理人" forState:UIControlStateNormal];
        [self.officedetailView.addPerson setEnabled:YES];
        [self.officedetailView.selecter setEnabled:YES];
        
        
        self.officedetailView.addPerson.hidden=NO;
        self.officedetailView.lable2.hidden=NO;
        
        if([type isEqualToString:@"0"]){
            CGRect banli=self.officedetailView.banli.frame;
            banli.origin.y=220;
            self.officedetailView.banli.frame=banli;
            CGRect text=self.officedetailView.textContent.frame;
            text.origin.y=242;
            self.officedetailView.textContent.frame=text;
            
        }else if([type isEqualToString:@"2"]){
            self.officedetailView.lable1.hidden=NO;
            CGRect banli=self.officedetailView.banli.frame;
            banli.origin.y=249;
            self.officedetailView.banli.frame=banli;
            CGRect text=self.officedetailView.textContent.frame;
            text.origin.y=270;
            self.officedetailView.textContent.frame=text;
            
            
            CGRect argBtn=self.officedetailView.agree.frame;
            argBtn.origin.y=210;
            self.officedetailView.agree.frame=argBtn;
            CGRect noagreeBtn=self.officedetailView.noagree.frame;
            noagreeBtn.origin.y=210;
            self.officedetailView.noagree.frame=noagreeBtn;
            CGRect _agreelabel=self.officedetailView.agreelabel.frame;
            _agreelabel.origin.y=210;
            self.officedetailView.agreelabel.frame=_agreelabel;
            CGRect _noargreelable=self.officedetailView.noargreelable.frame;
            _noargreelable.origin.y=210;
            self.officedetailView.noargreelable.frame=_noargreelable;
            CGRect _lable1=self.officedetailView.lable1.frame;
            _lable1.origin.y=240;
            self.officedetailView.lable1.frame=_lable1;
            
        }
        
    }
    else if (buttonIndex==2) {
       status=@"2";
        [self.officedetailView.selectHandle setTitle:@"报领导审批" forState:UIControlStateNormal];
        [self.officedetailView.addPerson setEnabled:YES];
        [self.officedetailView.selecter setEnabled:YES];
        self.officedetailView.addPerson.hidden=NO;
        self.officedetailView.lable2.hidden=NO;
        
        if([type isEqualToString:@"0"]){
            CGRect banli=self.officedetailView.banli.frame;
            banli.origin.y=220;
            self.officedetailView.banli.frame=banli;
            CGRect text=self.officedetailView.textContent.frame;
            text.origin.y=242;
            self.officedetailView.textContent.frame=text;
            
        }else if([type isEqualToString:@"2"]){
            self.officedetailView.lable1.hidden=NO;
            CGRect banli=self.officedetailView.banli.frame;
            banli.origin.y=249;
            self.officedetailView.banli.frame=banli;
            CGRect text=self.officedetailView.textContent.frame;
            text.origin.y=270;
            self.officedetailView.textContent.frame=text;
            
            
            CGRect argBtn=self.officedetailView.agree.frame;
            argBtn.origin.y=210;
            self.officedetailView.agree.frame=argBtn;
            CGRect noagreeBtn=self.officedetailView.noagree.frame;
            noagreeBtn.origin.y=210;
            self.officedetailView.noagree.frame=noagreeBtn;
            CGRect _agreelabel=self.officedetailView.agreelabel.frame;
            _agreelabel.origin.y=210;
            self.officedetailView.agreelabel.frame=_agreelabel;
            CGRect _noargreelable=self.officedetailView.noargreelable.frame;
            _noargreelable.origin.y=210;
            self.officedetailView.noargreelable.frame=_noargreelable;
            CGRect _lable1=self.officedetailView.lable1.frame;
            _lable1.origin.y=240;
            self.officedetailView.lable1.frame=_lable1;
            
        }
    }
}


#pragma mark -弹出键盘通知
-(void)inputKeyboardWillShow:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect rect=self.officedetailView.view.frame;
        rect.origin.y=-keyBoardFrame.size.height;
        self.officedetailView.view.frame=rect;
    }];
}

#pragma mark -取消键盘通知
-(void)inputKeyboardWillHide:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect rect=self.officedetailView.view.frame;
        rect.origin.y=0;
        self.officedetailView.view.frame=rect;
    }];
}

//展示公文附件
-(void)officeListData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    [self.HUD hide:YES];
    OfficeInfo * info =[AnalysisData getDocAccessory:dic];
    offInfo=info;
    if(offInfo.AllOfficeInfo.count==0){
        [self.officedetailView.accessory setTitle:@"暂无附件" forState:UIControlStateNormal];
        [self.officedetailView.accessory setEnabled:NO];
    }else{
    [self showOfficeList];
    }
}

//添加联系人或部门
-(void)addPerson{
[self.officedetailView performSegueWithIdentifier:@"officeDetaToaddress" sender:nil];
}

//组装
- (void)editInfo{
    strAllpeopleName=@"";
    strAllPeopleID=@"";
    strAllGroupID=@"";
    for (int i=0; i<_arrDidAllPeople.count; i++) {
        NSObject * obj=_arrDidAllPeople[i];
        if ([obj isKindOfClass:[GroupDetaInfo class]]) {
            if ([strAllGroupID isEqualToString:@""])strAllGroupID=[NSString stringWithFormat:@"%@,",[(GroupDetaInfo *)obj groupId]];
            else strAllGroupID =[NSString stringWithFormat:@"%@%@,",strAllGroupID,[(GroupDetaInfo *)obj groupId]];
            
        }else if([obj isKindOfClass:[PeopleDedaInfo class]]){
            
            if ([strAllPeopleID isEqualToString:@""])strAllPeopleID =[NSString stringWithFormat:@"%@,",[(PeopleDedaInfo *)obj userTel]];
            else strAllPeopleID =[NSString stringWithFormat:@"%@%@,",strAllPeopleID,[(PeopleDedaInfo *)obj userTel]];
            
            if ([strAllpeopleName isEqualToString:@""])strAllpeopleName =[NSString stringWithFormat:@"%@,",[(PeopleDedaInfo *)obj userName]];
            else strAllpeopleName =[NSString stringWithFormat:@"%@%@,",strAllpeopleName,[(PeopleDedaInfo *)obj userName]];
            
        }
        
    }
}


//确定
-(void)okbtn{
    sign=@"2";
    [self editInfo];
    if([status isEqualToString:@"0"]){
        if((self.officedetailView.textContent.text.length>0)&&([self.officedetailView.textContent.text isEqualToString:@"请输入内容"])){
            [ToolUtils alertInfo:@"请输入内容"];
            return;
        }
    }else{
        if (strAllPeopleID.length<1&&strAllGroupID.length<1) {
            [ToolUtils alertInfo:@"联系人不能为空"];
            return;
        }else{
            if((self.officedetailView.textContent.text.length>0)&&([self.officedetailView.textContent.text isEqualToString:@"请输入内容"])){
                [ToolUtils alertInfo:@"请输入内容"];
                return;
            }
        }
    }
    
//    if(![strAllPeopleID isEqualToString:@""]){
//        strAllPeopleID=[NSString stringWithFormat:@"%@,",strAllPeopleID];
//    }
//    
//    if(![strAllGroupID isEqualToString:@""]){
//        strAllGroupID=[NSString stringWithFormat:@"%@,",strAllGroupID];
//    }
    
    NSString *type=self.officedetailView.info.type;
    self.HUD.labelText = @"正在处理中..";
    [self.HUD show:YES];
//    self.HUD.dimBackground = YES;
    if([type isEqualToString:@"0"]){
        [packageData handleDoc:self ID:docContentInfo.ID Type:@"1" OperType:status tempTel:strAllPeopleID Status:@"1" context:self.officedetailView.textContent.text groupid:strAllGroupID];
    }else if([type isEqualToString:@"2"]){
        [packageData handleDoc:self ID:docContentInfo.ID Type:@"2" OperType:status tempTel:strAllPeopleID Status:anditStatus context:self.officedetailView.textContent.text groupid:strAllGroupID];
    }
    
}

-(void)selectAudit:(UIButton *)btn{
    if(btn.tag==1){
    anditStatus=@"1";
        [self.officedetailView.agree setBackgroundImage:[UIImage imageNamed:@"docselected"] forState:UIControlStateNormal];
        [self.officedetailView.noagree setBackgroundImage:[UIImage imageNamed:@"docunselect"] forState:UIControlStateNormal];
    }else if(btn.tag==2){
    anditStatus=@"2";
        [self.officedetailView.agree setBackgroundImage:[UIImage imageNamed:@"docunselect"] forState:UIControlStateNormal];
        [self.officedetailView.noagree setBackgroundImage:[UIImage imageNamed:@"docselected"] forState:UIControlStateNormal];
    }
}

//内容
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.officedetailView.textContent])
    {
        if ([textView.text isEqualToString:@"请输入内容"])
        {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.officedetailView.textContent])
    {
        if (textView.text.length==0)
        {
            textView.text = @"请输入内容";
            textView.textColor = [UIColor lightGrayColor];
        }
    }
    return YES;
}


//请求数据
-(void)reqData{
    sign=@"1";
    [packageData getDocInfo:self ID:self.officedetailView.info.ID];
    self.HUD.labelText = @"正在获取公文信息..";
    [self.HUD show:YES];
//    self.HUD.dimBackground = YES;
}

//公文流程
-(void)jumpDocFlow{
//    [packageData docFlow:self ID:self.officedetailView.info.ID];
//    self.officedetailView.tabBarController.tabBar.hidden=YES;
    [self.officedetailView performSegueWithIdentifier:@"docdetailtodocflow" sender:self.officedetailView];
    [self initBackBarButtonItem:self.officedetailView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
[self.officedetailView.textContent resignFirstResponder];
}

/*查看附件*/
-(void)optionAccessory{
    if (!offInfo) {
        self.HUD.labelText = @"正在获取附件信息..";
        [self.HUD show:YES];
//        self.HUD.dimBackground = YES;
        [packageData queryDocumentAttachment:self ID:officeID SELType:officeListNotifinfo];
        
    }else{
        [self showOfficeList];
    }
   
}
-(void)showOfficeList{
    if ([offInfo.AllOfficeInfo count]!=0) {
        NSMutableArray * arr=[[NSMutableArray alloc] init];
        for (int i=0;i<[offInfo.AllOfficeInfo count];i++) {
            officeDetaInfo *deta=offInfo.AllOfficeInfo[i];
            NSString * str =deta.filename;
            [arr addObject:[KxMenuItem menuItem:str
                                          image:nil
                                         target:nil
                                         action:NULL]];
        }
        
        [KxMenu showMenuInView:self.officedetailView.scrollerContent
                      fromRect:_officedetailView.accessory.frame
                     menuItems:arr
              initWithdelegate:self
         ];
    }
    
}

//KxMenuView的回调函数/下载附件回调/
-(void)pathIndexpath:(NSInteger)index{
    MBProgressHUD *hud =[[MBProgressHUD alloc] initWithView:self.officedetailView.view];
    hud.labelText=@"正在下载";
    [self.officedetailView.view addSubview:hud];
    [hud show:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downAccessory"
                                                        object:offInfo.AllOfficeInfo[index]];

}
/******************/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
