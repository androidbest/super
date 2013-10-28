//
//  GroupsInfo.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupDetaInfo.h"
#import "PeopleDedaInfo.h"

@interface GroupsInfo : NSObject

//通讯录分组信息
@property (strong ,nonatomic)NSMutableArray * AllGroups;//所有分组

//通讯录成员信息
@property (strong ,nonatomic)NSMutableArray *AllGroupmembers;//所有分组成员

//分组详情
@property (strong ,nonatomic)GroupDetaInfo * detas;

@property (strong ,nonatomic)PeopleDedaInfo * peopleDetas;

@property (assign )int rowCount;//总数

@end
