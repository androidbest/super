//
//  SmsController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//
//NSObject *obj;
//if (arr.count!=0) {
//    for (int i =0; i<arr.count; i++) {
//        optionInfo * info =[optionInfo new];
//        obj=arr[i];
//        
//        /*判断对象类型*/
//        if ([obj isKindOfClass:[PeopelInfo class]]) {
//            info.number =[(PeopelInfo *)obj tel];
//            info.name =[(PeopelInfo *)obj Name];
//        }else if([obj isKindOfClass:[GroupInfo class]]){
//            info.number =[(GroupInfo *)obj groupID];
//            info.name =[(GroupInfo *)obj Name];
//        }
//        
//        if (![arrAllNumber containsObject:info.number]){
//            [arrAllNumber addObject:info.number];
//            [_arrDidAllPeople addObject:info];
//        }
//        
//    }
//}
//
//[self.smsView.tableViewPeople reloadData];


#import "SmsController.h"
#import "GroupInfo.h"
#import "PeopelInfo.h"
#import "optionInfo.h"
#import "optionAddress.h"

@implementation SmsController{
    NSMutableArray * arrAllNumber;
    NSString *  ECType;
    NSString * SMSType;
    NSString * signStr;
    NSString * strAllPeopleName;
    NSString * strAllPeoleTel;
    NSString * strAllGroupID;
}

#pragma mark -  初始化
- (id)init{
    self =[super init];
    if (self) {
        signStr=user.ecname;
         self.arrDidAllPeople=[[NSMutableArray alloc] init];
         arrAllNumber =[[NSMutableArray alloc] init];
        strAllPeoleTel=@"";
        strAllGroupID=@"";
        ECType=@"0";
        SMSType=@"0";
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        //返回消息通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];

    }
    return self;
}

- (void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    UIImageView *imageView;
    UIImage *image;
//    self.HUD =[[MBProgressHUD alloc] initWithView:self.smsView.view];
    RespInfo * info =[AnalysisData ReTurnInfo:dic];
    if ([info.respCode isEqualToString:@"0"]) {
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = @"发送成功";
        _smsView.textSMSContent.text=@"";
        
    }else{
        image= [UIImage imageNamed:@"37x-Checkmark.png"];
        self.HUD.labelText = info.respMsg;
    }
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
	
    [self.HUD hide:YES afterDelay:1];
}

#pragma mark -接受选择通讯录传回来的数据
- (void)returnDidAddress:(NSArray *)arr{
    NSObject *obj;
    if (arr.count!=0) {
        for (int i =0; i<arr.count; i++) {
            obj=arr[i];
            if ([obj isKindOfClass:[PeopelInfo class]]) {
                if (![arrAllNumber containsObject:[(PeopelInfo *)obj tel]]){
                    [arrAllNumber addObject:[(PeopelInfo *)obj tel]];
                    [_arrDidAllPeople addObject:obj];
                }
            }else if([obj isKindOfClass:[GroupInfo class]]){
                if (![arrAllNumber containsObject:[(GroupInfo *)obj groupID]]){
                    [arrAllNumber addObject:[(PeopelInfo *)obj groupID]];
                    [_arrDidAllPeople addObject:obj];
                }
            }
            
        }
    }
    
    [self.smsView.tableViewPeople reloadData];
}

#pragma mark - 按钮实现方法
//发送
-(void)btnSendSMS:(id)sender{
    strAllPeopleName =@"";
    strAllPeoleTel =@"";
    strAllGroupID =@"";
    
    
    for (int i=0; i<_arrDidAllPeople.count; i++) {
        NSObject * obj =_arrDidAllPeople[i];
        if ([obj isKindOfClass:[PeopelInfo class]]) {
            
            /*所有人员号码*/
            if ([strAllPeopleName isEqualToString:@""])strAllPeopleName=[(PeopelInfo *)obj Name];
            else  strAllPeopleName =[NSString stringWithFormat:@"%@,%@",strAllPeopleName,[(PeopelInfo *)obj Name]];
            
            /*所有人员电话*/
            if ([strAllPeoleTel isEqualToString:@""])strAllPeoleTel=[(PeopelInfo *)obj tel];
            else strAllPeoleTel =[NSString stringWithFormat:@"%@,%@",strAllPeoleTel,[(PeopelInfo *)obj tel]];
            
        }else if([obj isKindOfClass:[GroupInfo class]]){
            
            /*所有部门id*/
            if ([strAllGroupID isEqualToString:@""])strAllGroupID = [(GroupInfo *)obj groupID];
            else strAllGroupID =[NSString stringWithFormat:@"%@,%@",strAllGroupID,[(GroupInfo *)obj groupID]];
        }
    }
    NSLog(@"%@\n%@\n%@",strAllGroupID,strAllPeoleTel,strAllPeopleName);
    
    
    if ([strAllGroupID isEqualToString:@""]&&[strAllPeoleTel isEqualToString:@""]){
        [ToolUtils alertInfo:@"请选择联系人或部门"];
        return;
    }
    if (_smsView.textSMSContent.text.length==0||[_smsView.textSMSContent.text isEqualToString:@"请输入内容"]) {
        [ToolUtils alertInfo:@"请输入内容"];
        return;
    }
    
    NSString *content=[NSString stringWithFormat:@"%@%@",_smsView.textSMSContent.text,signStr];
    
    if(content.length>350){
        [ToolUtils alertInfo:@"内容长度不能大于350个字"];
        return;
    }
    
//    NSDate *date =[NSDate date];
//    NSTimeInterval timeInter=[date timeIntervalSince1970];
//    long long time =timeInter*1000;
    
    /*提交等待*/
    self.HUD =[[MBProgressHUD alloc] initWithView:self.smsView.navigationController.view];
    self.HUD.labelText=@"正在发送..";
    [self.smsView.navigationController.view addSubview:self.HUD];
    [self.HUD show:YES];

    if(![strAllPeoleTel isEqualToString:@""]){
        strAllPeoleTel=[NSString stringWithFormat:@"%@,",strAllPeoleTel];
    }
    
    if(![strAllGroupID isEqualToString:@""]){
        strAllGroupID=[NSString stringWithFormat:@"%@,",strAllGroupID];
    }
    
    if ([SMSType isEqualToString:@"0"]) {
        [packageData SendSMS:self receiverTel:strAllPeoleTel receiverName:strAllPeopleName content:content sendTime:@"0" groupId:strAllGroupID];
    }else{
        [packageData SendVoice:self receiverTel:strAllPeoleTel receiverName:strAllPeopleName content:content sendTime:@"0" groupId:strAllGroupID];
    }
   
}


//选择短信模板
- (void)templates{
    [self initBackBarButtonItem:self.smsView];
    [self.smsView performSegueWithIdentifier:@"SMSToSMSMode" sender:nil];
}

//选择联系人
- (void)btnAddPeople:(id)sender{
    self.smsView.tabBarController.tabBar.hidden=YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    optionAddress *optionView = [storyboard instantiateViewControllerWithIdentifier:@"optionAddress"];
    [self.smsView.navigationController pushViewController:optionView animated:YES];
    optionView.optionDelegate=self;
}


//选择签名
- (void)btnECCode:(id)sender{
    NSString *strECCoder  =[NSString stringWithFormat:@"%@(%@)",user.ecname,user.username];
    UIActionSheet *sheet  =[[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:user.ecname, strECCoder,nil];
    sheet.actionSheetStyle = UIBarStyleBlackOpaque;
    [sheet showInView:self.smsView.navigationController.view];
}

#pragma mark - 短信模版回调
- (void)returnSMSModeInfo:(NSString *)SMSContent{
    self.smsView.textSMSContent.textColor=[UIColor blackColor];
    self.smsView.textSMSContent.text=SMSContent;
}

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    ECType=[ToolUtils numToString:buttonIndex];
    if (buttonIndex==1) {
        signStr =[NSString stringWithFormat:@"%@(%@)",user.ecname,user.username];
    }else if (buttonIndex==0){
        signStr=user.ecname;
    }
    [_smsView.btnECCode setTitle:signStr forState:UIControlStateNormal];
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    SMSType=[ToolUtils numToString:Index];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrDidAllPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell=@"SMSCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
        
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
    }
    
    
    NSObject * obj =_arrDidAllPeople[indexPath.row];
    if ([obj isKindOfClass:[PeopelInfo class]]) {
        cell.textLabel.text=[(PeopelInfo *)obj Name];
        cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
        
    }else if([obj isKindOfClass:[GroupInfo class]]){
        cell.textLabel.text=[(GroupInfo *)obj Name];
        NSString *strDeta=[[(GroupInfo *)obj Count] stringByAppendingString:@"  位联系人"];
        strDeta=[strDeta stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        cell.detailTextLabel.text=strDeta;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_arrDidAllPeople removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
 return @"删除";
}

#pragma mark -弹出键盘通知
-(void)inputKeyboardWillShow:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect rect=self.smsView.view.frame;
        rect.origin.y=-keyBoardFrame.size.height;
        self.smsView.view.frame=rect;
    }];
}

#pragma mark -取消键盘通知
-(void)inputKeyboardWillHide:(NSNotification *)notificationKeyboar{
        CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:animationTime animations:^{
            CGRect rect=self.smsView.view.frame;
            rect.origin.y=0;
            self.smsView.view.frame=rect;
        }];
}

//- (void)endTextEditing{
//    [self.smsView.view endEditing:YES];
//}

#pragma mark -  textiew提示语
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.smsView.textSMSContent])
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
    if ([textView isEqual:self.smsView.textSMSContent])
    {
        if (textView.text.length==0)
        {
            textView.text = @"请输入内容";
            textView.textColor = [UIColor lightGrayColor];
        }
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  NSString * textStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    _smsView.zishu.text=[NSString stringWithFormat:@"%@/350",[ToolUtils numToString:textStr.length]];
    if (textStr.length>=350)
    {
        textView.text = [textStr substringToIndex:350];
        return NO;
    }
    return YES;
}



@end
