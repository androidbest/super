//
//  ConfigFile.m
//  zwy
//
//  Created by wangshuang on 13-5-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//


#import "ConfigFile.h"
#import "PeopelInfo.h"
#import "GroupInfo.h"
#import "Constants.h"
static ConfigFile *configFile;
@implementation ConfigFile

+(ConfigFile *)newInstance{
    @synchronized(self){
    if(configFile==nil)
       configFile=[self new];
    }
    return configFile;
}
#pragma mark - 获取接口类型
-(void)initData{
    if(_configData==nil){
    NSString *path = [[NSBundle mainBundle] pathForResource: @"common" ofType:@"plist"];
    _configData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
}

#pragma mark - 创建缓存文件夹
- (void)paths{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    NSString * strOfficeFile =@"doc";
    NSString * strAccessoryFile=@"accessory";
    NSString * pathOfficeFile =[NSString stringWithFormat:@"%@/%@",DocumentsDirectory,strOfficeFile];
    NSString * pathAccessoryFile =[NSString stringWithFormat:@"%@/%@",DocumentsDirectory,strAccessoryFile];
    if (![fileManager fileExistsAtPath:pathOfficeFile]) {
        [fileManager createDirectoryAtPath:pathOfficeFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fileManager fileExistsAtPath:pathAccessoryFile]) {
        [fileManager createDirectoryAtPath:pathAccessoryFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)pathECGroups{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    NSString * Files =user.eccode;
    NSString *filePath =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.msisdn,Files];
    if (![fileManager fileExistsAtPath:filePath]) {
         [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


+ (void)pathUsersInfo{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    NSString * Files =user.msisdn;
    NSString *filePath =[NSString stringWithFormat:@"%@/%@",DocumentsDirectory,Files];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - 获取通讯录所有信息
+ (NSMutableArray *)setAllPeopleInfo:(NSString *)str isECMember:(BOOL)isECMember{
    NSMutableArray* AllPeople =[[NSMutableArray alloc] init];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    NSArray *arrGroup=[strGroup componentsSeparatedByString:@"\n"];
    if (arrGroup.count==0&&!arrGroup) return AllPeople;
    for (int i=0; i<arrGroup.count-1; i++) {
        NSArray * arrData =[[arrGroup objectAtIndex:i] componentsSeparatedByString:@","];
        if (arrData.count>=4) {
            GroupInfo *info=[GroupInfo new];
            info.groupID =[arrData objectAtIndex:0];
            info.Name=[arrData objectAtIndex:1];
            info.superID =[arrData objectAtIndex:2];
            info.Count =[arrData objectAtIndex:3];
            info.letter =@"0";
            info.tel=@"";
            [AllPeople addObject:info];
        }
    }
    
    
    str=[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"member.txt"];
    NSString * strData =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    NSArray * arr = [strData componentsSeparatedByString:@"\n"];
    if (arr.count==0&&!arr) return AllPeople;
    for (int i =0; i<arr.count-1; i++) {
        NSArray * arrData =[[arr objectAtIndex:i] componentsSeparatedByString:@","];
        if (arrData.count>=7) {
            PeopelInfo *info=[PeopelInfo new];
            info.userID =[arrData objectAtIndex:0];
            info.Name=[arrData objectAtIndex:1];
            info.job=[arrData objectAtIndex:2];
            info.area =[arrData objectAtIndex:3];
            info.tel=[arrData objectAtIndex:4];
            info.groupID =[arrData objectAtIndex:5];
            info.superID=[arrData objectAtIndex:5];
            info.letter =[arrData objectAtIndex:6];
            info.isecnumer=[arrData objectAtIndex:8];
            if (isECMember) {
                if([info.isecnumer isEqualToString:@"1"])
                   [AllPeople addObject:info];
            }else{ [AllPeople addObject:info]; }
 
        }
    }
    return AllPeople;
}

//获取所有成员
+ (NSMutableArray *)setEcNumberInfo{
    
   NSArray * allSection=@[@"a",@"b",@"c",@"d",@"e",@"f",
                @"g",@"h",@"i",@"j",@"k",@"l",
                @"m",@"n",@"o",@"p",@"q",@"r",
                @"s",@"t",@"u",@"v",@"w",@"x",
                @"y",@"z",@"#",];
    
    NSString *str=[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"member.txt"];
    NSMutableArray* AllPeople =[[NSMutableArray alloc] init];
    NSString *strGroup =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    NSArray *arrGroup=[strGroup componentsSeparatedByString:@"\n"];
    if (arrGroup.count==0&&!arrGroup) return AllPeople;
    NSString * strData =[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:NULL];
    NSArray * arr = [strData componentsSeparatedByString:@"\n"];
    if (arr.count==0&&!arr) return AllPeople;
    for (int i =0; i<arr.count-1; i++) {
        NSArray * arrData =[[arr objectAtIndex:i] componentsSeparatedByString:@","];
        if (arrData.count==11) {
            PeopelInfo *info=[PeopelInfo new];
            info.userID =[arrData objectAtIndex:0];
            info.Name=[arrData objectAtIndex:1];
            info.job=[arrData objectAtIndex:2];
            info.area =[arrData objectAtIndex:3];
            info.tel=[arrData objectAtIndex:4];
            info.groupID =[arrData objectAtIndex:5];
            info.superID=[arrData objectAtIndex:5];
            info.letter =[arrData objectAtIndex:6];
            if ([allSection containsObject:[[arrData objectAtIndex:6] substringToIndex:1]]) {
              info.Firetletter =[[arrData objectAtIndex:6] substringToIndex:1];
            }else{
            info.Firetletter =@"#";
            }
            info.isecnumer=[arrData objectAtIndex:8];
            info.headPath=[arrData objectAtIndex:9];
            info.eccode=[arrData objectAtIndex:10];
            if([info.isecnumer isEqualToString:@"1"]){
            [AllPeople addObject:info];
            }
        }
    }
    return AllPeople;
}

/*同步全局通讯录缓存指示灯*/
+ (void)showSetAllAllGroupAddressBooksHUDWithText:(NSString *)text  withView:(UIViewController *)viewController{
    NSString * str =[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"group.txt"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:str];
    if (!blHave)return;
    if (EX_arrGroupAddressBooks&&EX_arrGroupAddressBooks.count!=0)return;
    MBProgressHUD * _HUD_Group = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    _HUD_Group.labelText =text;
    _HUD_Group.margin = 10.f;
    _HUD_Group.removeFromSuperViewOnHide = YES;
    [_HUD_Group show:YES];
    
    
    __block NSArray *allPeople=nil;
    __block NSMutableArray *allSection=nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //设置通讯录
        /*****************************/
        allPeople=[ConfigFile setEcNumberInfo];
        EX_arrGroupAddressBooks=allPeople;
        
        allSection=[NSMutableArray arrayWithObjects:
                    @"a",@"b",@"c",@"d",@"e",@"f",
                    @"g",@"h",@"i",@"j",@"k",@"l",
                    @"m",@"n",@"o",@"p",@"q",@"r",
                    @"s",@"t",@"u",@"v",@"w",@"x",
                    @"y",@"z",@"#",nil];
        NSMutableArray * arrRemoveObject=[[NSMutableArray alloc] init];
        for (int i = 0; i<allSection.count; i++) {
            NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter == '%@'",allSection[i]];
            NSPredicate * predicate;
            predicate = [NSPredicate predicateWithFormat:strPre];
            NSArray * results = [allPeople filteredArrayUsingPredicate: predicate];
            if (results.count==0) {
                [arrRemoveObject addObject:allSection[i]];
            }
        }
        [allSection removeObjectsInArray:arrRemoveObject];
        EX_arrSection=allSection;
        /*****************************/
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD_Group hide:YES afterDelay:0];
        });
        
    });
}
@end
