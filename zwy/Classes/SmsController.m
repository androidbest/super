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
    NSString * voicesignStr;
    NSString * strAllPeopleName;
    NSString * strAllPeoleTel;
    NSString * strAllGroupID;
    int MAX_Content;
    
    NSString *voicestrAllPeopleName;
    NSString *voiicestrAllPeoleTel;
    NSString *voicestrAllGroupID;
    
    NSMutableArray *voiceAllNumber;
    NSMutableArray *voiceDidAllPeople;
    
    NSString *voiceECCoder;
    NSString *voiceContent;
    
    NSString *smsContent;
    
    NSString *smsCount;
    NSString *voiceCount;
    
    
}

#pragma mark -  初始化
- (id)init{
    self =[super init];
    if (self) {
        signStr=user.ecname;
        voicesignStr=user.ecname;
         self.arrDidAllPeople=[[NSMutableArray alloc] init];
         arrAllNumber =[[NSMutableArray alloc] init];
        
        
        voiceAllNumber=[NSMutableArray new];
        voiceDidAllPeople=[NSMutableArray new];
        voiceECCoder=@"";
        
        smsCount=@"0";
        voiceCount=@"0";
        
        strAllPeoleTel=@"";
        strAllGroupID=@"";
        ECType=@"0";
        SMSType=@"0";
        voicestrAllPeopleName=@"";
        voiicestrAllPeoleTel=@"";
        voicestrAllGroupID=@"";
        
        voiceContent=@"请输入内容";
        smsContent=@"请输入内容";
        
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
//    UIImage *image=nil;
//    self.HUD =[[MBProgressHUD alloc] initWithView:self.smsView.view];
    RespInfo * info =[AnalysisData ReTurnInfo:dic];
    if ([info.respCode isEqualToString:@"0"]) {
//        image= [UIImage imageNamed:@"37x-Checkmark"];
        self.HUD.labelText = @"发送成功";
        
        if([SMSType isEqualToString:@"0"]){
            smsContent=@"请输入内容";
            _smsView.textSMSContent.text=smsContent;
            _smsView.textSMSContent.textColor=[UIColor lightGrayColor];
            _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",@"0",350];
            [self.arrDidAllPeople removeAllObjects];
            [arrAllNumber removeAllObjects];
            [self.smsView.tableViewPeople reloadData];
        }else{
            voiceContent=@"请输入内容";
            _smsView.textSMSContent.text=voiceContent;
            _smsView.textSMSContent.textColor=[UIColor lightGrayColor];
             _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",@"0",350];
            [voiceDidAllPeople removeAllObjects];
            [voiceAllNumber removeAllObjects];
            [self.smsView.tableViewPeople reloadData];
        }
    }else{
//        image= [UIImage imageNamed:@"37x-Checkmark"];
        self.HUD.labelText = @"发送失败";
    }
    self.HUD.customView=imageView;
    self.HUD.mode = MBProgressHUDModeCustomView;
	
    [self.HUD hide:YES afterDelay:1];
}

#pragma mark -接受选择通讯录传回来的数据
- (void)returnDidAddress:(NSArray *)arr{
    
    if([SMSType isEqualToString:@"0"]){
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

    
    }else{
        NSObject *obj;
        if (arr.count!=0) {
            for (int i =0; i<arr.count; i++) {
                obj=arr[i];
                if ([obj isKindOfClass:[PeopelInfo class]]) {
                    if (![voiceAllNumber containsObject:[(PeopelInfo *)obj tel]]){
                        [voiceAllNumber addObject:[(PeopelInfo *)obj tel]];
                        [voiceDidAllPeople addObject:obj];
                    }
                }else if([obj isKindOfClass:[GroupInfo class]]){
                    if (![voiceAllNumber containsObject:[(GroupInfo *)obj groupID]]){
                        [voiceAllNumber addObject:[(PeopelInfo *)obj groupID]];
                        [voiceDidAllPeople addObject:obj];
                    }
                }
                
            }
        }

    
    }
    
    
    
    [self.smsView.tableViewPeople reloadData];
}

#pragma mark - 按钮实现方法
//发送
-(void)btnSendSMS:(id)sender{
    
    
    
    if([SMSType isEqualToString:@"0"]){
        strAllPeopleName =@"";
        strAllPeoleTel =@"";
        strAllGroupID =@"";
        for (int i=0; i<_arrDidAllPeople.count; i++) {
        NSObject * obj =_arrDidAllPeople[i];
        if ([obj isKindOfClass:[PeopelInfo class]]) {
            
            /*所有人员号码*/
            if ([strAllPeopleName isEqualToString:@""])strAllPeopleName=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj Name]];
            else  strAllPeopleName =[NSString stringWithFormat:@"%@%@,",strAllPeopleName,[(PeopelInfo *)obj Name]];
            
            /*所有人员电话*/
            if ([strAllPeoleTel isEqualToString:@""])strAllPeoleTel=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj tel]];
            else strAllPeoleTel =[NSString stringWithFormat:@"%@%@,",strAllPeoleTel,[(PeopelInfo *)obj tel]];
            
        }else if([obj isKindOfClass:[GroupInfo class]]){
            
            /*所有部门id*/
            if ([strAllGroupID isEqualToString:@""])strAllGroupID = [NSString stringWithFormat:@"%@,",[(GroupInfo *)obj groupID]];
            else strAllGroupID =[NSString stringWithFormat:@"%@%@,",strAllGroupID,[(GroupInfo *)obj groupID]];
        }
    }
    
    if ([strAllGroupID isEqualToString:@""]&&[strAllPeoleTel isEqualToString:@""]){
        [ToolUtils alertInfo:@"请选择联系人或部门"];
        return;
    }
    if (_smsView.textSMSContent.text.length==0||[_smsView.textSMSContent.text isEqualToString:@"请输入内容"]) {
        [ToolUtils alertInfo:@"请输入内容"];
        return;
    }
    
    NSString *content=[NSString stringWithFormat:@"%@%@",smsContent,signStr];
    
    if(smsContent.length>350){
        [ToolUtils alertInfo:@"内容长度不能大于350个字"];
        return;
    }
    
    /*提交等待*/
    self.HUD =[[MBProgressHUD alloc] initWithView:self.smsView.navigationController.view];
    self.HUD.labelText=@"正在发送..";
    [self.smsView.navigationController.view addSubview:self.HUD];
    [self.HUD show:YES];

    
    NSLog(@"%@\n%@\n%@",strAllGroupID,strAllPeoleTel,strAllPeopleName);
    
    [packageData SendSMS:self receiverTel:strAllPeoleTel receiverName:strAllPeopleName content:content sendTime:@"0" groupId:strAllGroupID];
    
    
    }else{
        
        voicestrAllPeopleName=@"";
        voiicestrAllPeoleTel=@"";
        voicestrAllGroupID=@"";
        
        for (int i=0; i<voiceDidAllPeople.count; i++) {
            NSObject * obj =voiceDidAllPeople[i];
            if ([obj isKindOfClass:[PeopelInfo class]]) {
                
                /*所有人员号码*/
                if ([voicestrAllPeopleName isEqualToString:@""])voicestrAllPeopleName=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj Name]];
                else  voicestrAllPeopleName =[NSString stringWithFormat:@"%@%@,",voicestrAllPeopleName,[(PeopelInfo *)obj Name]];
                
                /*所有人员电话*/
                if ([voiicestrAllPeoleTel isEqualToString:@""])voiicestrAllPeoleTel=[NSString stringWithFormat:@"%@,",[(PeopelInfo *)obj tel]];
                else voiicestrAllPeoleTel =[NSString stringWithFormat:@"%@%@,",voiicestrAllPeoleTel,[(PeopelInfo *)obj tel]];
                
            }else if([obj isKindOfClass:[GroupInfo class]]){
                
                /*所有部门id*/
                if ([voicestrAllGroupID isEqualToString:@""])voicestrAllGroupID = [NSString stringWithFormat:@"%@,",[(GroupInfo *)obj groupID]];
                else voicestrAllGroupID =[NSString stringWithFormat:@"%@%@,",voicestrAllGroupID,[(GroupInfo *)obj groupID]];
            }
        }
        
        if ([voicestrAllGroupID isEqualToString:@""]&&[voiicestrAllPeoleTel isEqualToString:@""]){
            [ToolUtils alertInfo:@"请选择联系人或部门"];
            return;
        }
        if (_smsView.textSMSContent.text.length==0||[_smsView.textSMSContent.text isEqualToString:@"请输入内容"]) {
            [ToolUtils alertInfo:@"请输入内容"];
            return;
        }
        
        NSString *content=[NSString stringWithFormat:@"%@%@",voiceContent,voicesignStr];
        
        if(voiceContent.length>70){
            [ToolUtils alertInfo:@"内容长度不能大于70个字"];
            return;
        }
        
        /*提交等待*/
        self.HUD =[[MBProgressHUD alloc] initWithView:self.smsView.navigationController.view];
        self.HUD.labelText=@"正在发送..";
        [self.smsView.navigationController.view addSubview:self.HUD];
        [self.HUD show:YES];
        
        NSLog(@"%@\n%@\n%@",voicestrAllGroupID,voiicestrAllPeoleTel,voicestrAllPeopleName);
        
        [packageData SendVoice:self receiverTel:voiicestrAllPeoleTel receiverName:voicestrAllPeopleName content:content sendTime:@"0" groupId:voicestrAllGroupID];
        
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
    if([SMSType isEqualToString:@"0"]){
        self.smsView.textSMSContent.textColor=[UIColor blackColor];
        smsContent=SMSContent;
        self.smsView.textSMSContent.text=smsContent;
        _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",[ToolUtils numToString:smsContent.length],350];
    }else{
        voiceContent=SMSContent;
        self.smsView.textSMSContent.textColor=[UIColor blackColor];
        self.smsView.textSMSContent.text=voiceContent;
        _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",[ToolUtils numToString:voiceContent.length],70];
    }
}

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    ECType=[ToolUtils numToString:buttonIndex];
    if([SMSType isEqualToString:@"0"]){
        if (buttonIndex==1) {
            signStr =[NSString stringWithFormat:@"%@(%@)",user.ecname,user.username];
        }else if (buttonIndex==0){
            signStr=user.ecname;
        }
        
        [_smsView.btnECCode setTitle:signStr forState:UIControlStateNormal];
    
    }else{
        if (buttonIndex==1) {
            voicesignStr=[NSString stringWithFormat:@"%@(%@)",user.ecname,user.username];
        }else if (buttonIndex==0){
            voicesignStr=user.ecname;
        }
    [_smsView.btnECCode setTitle:voicesignStr forState:UIControlStateNormal];
    }
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    SMSType=[ToolUtils numToString:Index];
    
    if([SMSType isEqualToString:@"0"]){
    [_smsView.btnECCode setTitle:signStr forState:UIControlStateNormal];
    [self.smsView.tableViewPeople reloadData];
    self.smsView.textSMSContent.text=smsContent;
        if([smsContent isEqualToString:@"请输入内容"]){
        self.smsView.textSMSContent.textColor = [UIColor lightGrayColor];
        _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",@"0",350];
        }else{
        self.smsView.textSMSContent.textColor = [UIColor blackColor];
        _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",[ToolUtils numToString:smsContent.length],350];
        }
    }else{
    [_smsView.btnECCode setTitle:voicesignStr forState:UIControlStateNormal];
    [self.smsView.tableViewPeople reloadData];
    self.smsView.textSMSContent.text=voiceContent;
    if([voiceContent isEqualToString:@"请输入内容"]){
        self.smsView.textSMSContent.textColor = [UIColor lightGrayColor];
        _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",@"0",70];
        
    }else{
        self.smsView.textSMSContent.textColor = [UIColor blackColor];
        _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",[ToolUtils numToString:voiceContent.length],70];
        
    }
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([SMSType isEqualToString:@"0"]){
        if (_arrDidAllPeople.count==0)tableView.separatorStyle=NO;
        else tableView.separatorStyle=YES;
    return _arrDidAllPeople.count;
    
    }else{
        if (voiceDidAllPeople.count==0)tableView.separatorStyle=NO;
        else tableView.separatorStyle=YES;
        return voiceDidAllPeople.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell=@"SMSCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
        cell.detailTextLabel.textColor= [UIColor grayColor];
    }
    
    if([SMSType isEqualToString:@"0"]){
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
    }else{
        NSObject * obj =voiceDidAllPeople[indexPath.row];
        if ([obj isKindOfClass:[PeopelInfo class]]) {
            cell.textLabel.text=[(PeopelInfo *)obj Name];
            cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
            
        }else if([obj isKindOfClass:[GroupInfo class]]){
            cell.textLabel.text=[(GroupInfo *)obj Name];
            NSString *strDeta=[[(GroupInfo *)obj Count] stringByAppendingString:@"  位联系人"];
            strDeta=[strDeta stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            cell.detailTextLabel.text=strDeta;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([SMSType isEqualToString:@"0"]){
            [_arrDidAllPeople removeObjectAtIndex:indexPath.row];
            [arrAllNumber removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        
        }else{
        
            [voiceDidAllPeople removeObjectAtIndex:indexPath.row];
            [voiceAllNumber removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
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
        rect.origin.y=-keyBoardFrame.size.height+62;
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
    if ([SMSType isEqualToString:@"0"]) MAX_Content=350;
    else MAX_Content=70;
    NSLog(@"%d",MAX_Content);
    if (textStr.length>=MAX_Content)
    {
        textView.text = [textStr substringToIndex:MAX_Content];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if([SMSType isEqualToString:@"0"]){
    smsContent=textView.text;
    _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",[ToolUtils numToString:textView.text.length],350];
    }else{
    voiceContent=textView.text;
    _smsView.zishu.text=[NSString stringWithFormat:@"%@/%d",[ToolUtils numToString:textView.text.length],70];
    }
    
}

@end
