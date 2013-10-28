//
//  MassAddPeopleController.m
//  zwy
//
//  Created by cqsxit on 13-10-23.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MassAddPeopleController.h"
#import "PeopelInfo.h"
@implementation MassAddPeopleController



- (void)btnBack{
    if ([_massAddView.textTel resignFirstResponder]) {
        [self performSelector:@selector(returnMassView) withObject:self afterDelay:0.3];
        return;
    }
    [_massAddView.navigationController popViewControllerAnimated:YES];
}

- (void)btnAffirm{
    PeopelInfo *info=[PeopelInfo new];
    info.Name=_massAddView.textTel.text;
    info.tel=_massAddView.textTel.text;
    [_massAddView.MassAddPeopleDelegate returnDidAddress:@[info]];
    if ([_massAddView.textTel resignFirstResponder]) {
        [self performSelector:@selector(returnMassView) withObject:self afterDelay:0.3];
        return;
    }
    [_massAddView.navigationController popViewControllerAnimated:YES];
    
}

- (void)returnMassView{
    [_massAddView.navigationController popViewControllerAnimated:YES];
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
