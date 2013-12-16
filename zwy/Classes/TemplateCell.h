//
//  TemplateCell.h
//  zwy
//
//  Created by wangshuang on 10/14/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateCell : UITableViewCell
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *content;
@property (strong ,nonatomic) UIImageView * imageMark;
@property (strong ,nonatomic) UILabel *greetingCount;
@property (strong ,nonatomic)UIImageView *imageContent;

@end
