//
//  optionCell.h
//  zwy
//
//  Created by cqsxit on 13-10-17.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface optionCell : UITableViewCell
@property (strong ,nonatomic)UIButton *btnOption;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDelegate:(id)delegate;
@end
