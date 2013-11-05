//
//  AddPeopleBookController.m
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AddPeopleBookController.h"
#import <AddressBook/AddressBook.h>

@implementation AddPeopleBookController


- (void)btnSave{
    /*提交等待*/
    if (_addView.textName.text.length==0) {
        [ToolUtils alertInfo:@"请输入姓名"];
        return;
    }
    
    if (_addView.textTel.text.length==0) {
        [ToolUtils alertInfo:@"请输入号码"];
        return;
    }
    
    ABHelperCheckExistResultType type= [SJABHelper existPhone:_addView.textTel.text];
    if (type ==ABHelperExistSpecificContact) {
        [ToolUtils alertInfo:@"号码已存在是否继续添加" delegate:self otherBtn:@"取消"];
        return;
    }
    
    self.HUD =[[MBProgressHUD alloc] initWithView:self.addView.navigationController.view];
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.labelText=@"保存中";
    [self.addView.navigationController.view addSubview:self.HUD];
    [self.HUD show:YES];
    BOOL blSave =[SJABHelper addContactName:_addView.textName.text phoneNum:_addView.textTel.text withLabel:@"办公"];
    if (blSave) {
        self.HUD.labelText=@"保存成功";
        [self.HUD hide:YES afterDelay:1.0];
        [self.addView.addressView.controller updateAddressBook];
        [_addView.navigationController popViewControllerAnimated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.HUD =[[MBProgressHUD alloc] initWithView:self.addView.navigationController.view];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText=@"保存中";
        [self.addView.navigationController.view addSubview:self.HUD];
        [self.HUD show:YES];
        BOOL blSave =[SJABHelper addContactName:_addView.textName.text phoneNum:_addView.textTel.text withLabel:@"办公"];
        if (blSave) {
            self.HUD.labelText=@"保存成功";
            [self.HUD hide:YES afterDelay:1.0];
            [self.addView.addressView.controller updateAddressBook];
            [_addView.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length<14) {
        return YES;
    }else{
        return NO;
    }
}
@end
