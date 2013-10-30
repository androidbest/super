//
//  CallTelController.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-11.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "CallTelController.h"
#import "PeopelInfo.h"

@implementation CallTelController

//获取通讯录所有信息
+ (NSMutableArray *)setAllPeopleInfo:(NSString *)str{
    NSMutableArray* AllPeople =[[NSMutableArray alloc] init];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    NSArray *arrGroup=[strGroup componentsSeparatedByString:@"\n"];
    if (arrGroup.count==0&&!arrGroup) return AllPeople;
    NSString * strData =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    NSArray * arr = [strData componentsSeparatedByString:@"\n"];
    if (arr.count==0&&!arr) return AllPeople;
    for (int i =0; i<arr.count-1; i++) {
        NSArray * arrData =[[arr objectAtIndex:i] componentsSeparatedByString:@","];
        PeopelInfo *info=[PeopelInfo new];
        info.userID =[arrData objectAtIndex:0];
        info.Name=[arrData objectAtIndex:1];
        info.job=[arrData objectAtIndex:2];
        info.area =[arrData objectAtIndex:3];
        info.tel=[arrData objectAtIndex:4];
        info.groupID =[arrData objectAtIndex:5];
        info.letter =[arrData objectAtIndex:6];
        [AllPeople addObject:info];
    }
    return AllPeople;
}

#pragma mark - 初始化
- (id)init{
    self=[super init];
    if (self) {
        _strTel=[[NSString alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(showKeyboard:)
                                                    name:@"showAddressCallKeyboard"
                                                  object:nil];
        self.arrAllPeople =[[NSMutableArray alloc] init];
        self.arrSeaPeople =[[NSArray alloc] init];
    }
    return self;
}

- (void)initWithData{
    if (_arrAllPeople.count==0) {
        NSString * str =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.eccode,@"member.txt"];
        _arrAllPeople  =[CallTelController setAllPeopleInfo:str];
    }
}

#pragma mark - 弹出拨号键盘
- (void)showKeyboard:(NSNotification *)obj{
    UITabBarItem * item =[obj object];
    if (item.tag==0&&_callView.keyboradView.frame.origin.y>400) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect =_callView.keyboradView.frame;
            rect.origin.y=_callView.tabBarController.tabBar.frame.origin.y-rect.size.height-64;
            _callView.keyboradView.frame=rect;
        }];
    }
}

//隐藏键盘
- (void)btnHidden{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect =_callView.keyboradView.frame;
        rect.origin.y=ScreenHeight-49;
        _callView.keyboradView.frame=rect;
    }];
}

#pragma mark - 按钮实现方法
//输入号码
-(void)inputNumber:(UIButton *)sender{
    NSString * strNumber =[NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (sender.tag==100)strNumber=@"*";
    if (sender.tag==1000)strNumber=@"#";
    _strTel=[_strTel stringByAppendingString:strNumber];
    _callView.labelCall.text=_strTel;
    _callView.labelCall.textColor=[UIColor blackColor];
    
    if (_arrSeaPeople.count!=0) {
        _arrSeaPeople=NULL;
        _arrSeaPeople=[[NSArray alloc] init];
    }
    NSString * strSearchbar;
    strSearchbar =[NSString stringWithFormat:@"SELF.tel CONTAINS '%@'",_strTel];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
    _arrSeaPeople=[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
     [_callView.tableViewPeople reloadData];
}

//删除号码
- (void)btncancel{
    if (_strTel.length>0) {
        _strTel =[_strTel substringToIndex:_strTel.length-1];
        _callView.labelCall.text=_strTel;
    }
    if (_strTel.length==0) {
        _callView.labelCall.text=@"点击拨打电话";
        _callView.labelCall.textColor=[UIColor grayColor];
    }
    
    if (_arrSeaPeople.count!=0) {
        _arrSeaPeople=NULL;
        _arrSeaPeople=[[NSArray alloc] init];
    }
    NSString * strSearchbar;
    strSearchbar =[NSString stringWithFormat:@"SELF.tel CONTAINS '%@'",_strTel];
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat: strSearchbar];
    _arrSeaPeople=[self.arrAllPeople filteredArrayUsingPredicate: predicateTemplate];
    [_callView.tableViewPeople reloadData];
    
}


//拨打电话
- (void)btnBigImageView:(UITapGestureRecognizer *)tap{
    if (![_callView.labelCall.text isEqualToString:@"点击拨打电话"]&&_callView.labelCall.text.length!=0) {
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSString * strTel =[NSString stringWithFormat:@"tel:%@",_callView.labelCall.text];
        NSURL *telURL =[NSURL URLWithString:strTel];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.callView.view addSubview:callWebview];
    }
}


#pragma mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arrSeaPeople.count==0&&![_callView.labelCall.text isEqualToString:@"点击拨打电话"]&&_callView.labelCall.text.length==0) {
        return _arrAllPeople.count;
    }else{
        return _arrSeaPeople.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellINdenfer =@"Cell";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:CellINdenfer];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellINdenfer];
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    NSObject * obj;
    if (_arrSeaPeople.count==0&&![_callView.labelCall.text isEqualToString:@"点击拨打电话"]&& _callView.labelCall.text.length==0) {
        obj =[_arrAllPeople objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
        cell.textLabel.text=[(PeopelInfo *)obj Name];
        cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject * obj;
    if (_arrSeaPeople.count==0&&![_callView.labelCall.text isEqualToString:@"点击拨打电话"]&& _callView.labelCall.text.length==0) {
        obj =[_arrAllPeople objectAtIndex:indexPath.row];
    }else{
        obj =[_arrSeaPeople objectAtIndex:indexPath.row];
    }
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString * strTel =[NSString stringWithFormat:@"tel:%@",[(PeopelInfo *)obj tel]];
    NSURL *telURL =[NSURL URLWithString:strTel];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.callView.view addSubview:callWebview];

}

@end
