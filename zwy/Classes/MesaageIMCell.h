//
//  MesaageIMCell.h
//  zwy
//
//  Created by wangshuang on 12/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MesaageIMCell : UITableViewCell
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *username;
@property (strong, nonatomic) UILabel *content;
@property (strong ,nonatomic) UIImageView * imageMark;
@property (strong, nonatomic) UILabel *labelCount;
@property (strong ,nonatomic) CALayer *bottomBorder;
@end
