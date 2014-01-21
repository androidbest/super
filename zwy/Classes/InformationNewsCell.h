//
//  InformationNewsCell.h
//  zwy
//
//  Created by cqsxit on 13-12-11.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationNewsCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDelegate:(id)delegate;
@property (strong ,nonatomic)UILabel *labelTitle1;
@property (strong ,nonatomic)UILabel *labelTitle2;
@property (strong ,nonatomic)UILabel *labelTitle3;
@property (strong ,nonatomic)UILabel *labelTitle4;
@property (strong ,nonatomic)UILabel *labelTitle5;
@property (strong ,nonatomic)UILabel *labelTitle6;

@property (strong ,nonatomic)UILabel *labelAddress1;
@property (strong ,nonatomic)UILabel *labelAddress2;
@property (strong ,nonatomic)UILabel *labelAddress3;
@property (strong ,nonatomic)UILabel *labelAddress4;
@property (strong ,nonatomic)UILabel *labelAddress5;
@property (strong ,nonatomic)UILabel *labelAddress6;

@property (strong ,nonatomic)UILabel *labelContent1;
@property (strong ,nonatomic)UILabel *labelContent2;
@property (strong ,nonatomic)UILabel *labelContent3;
@property (strong ,nonatomic)UILabel *labelContent4;
@property (strong ,nonatomic)UILabel *labelContent5;
@property (strong ,nonatomic)UILabel *labelContent6;

@property (strong ,nonatomic)UILabel *labelTime1;
@property (strong ,nonatomic)UILabel *labelTime2;
@property (strong ,nonatomic)UILabel *labelTime3;
@property (strong ,nonatomic)UILabel *labelTime4;
@property (strong ,nonatomic)UILabel *labelTime5;
@property (strong ,nonatomic)UILabel *labelTime6;

@property (strong ,nonatomic)UIImageView *imageFirstNews;
@end
