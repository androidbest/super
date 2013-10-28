//
//  peopleDeleteView.h
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface peopleDeleteView : BaseView
@property (strong ,nonatomic)NSMutableArray * arrAllInfo;
@property (strong, nonatomic) IBOutlet UITableView *tableViewAllIfo;
@property (assign ,nonatomic)id peopleDeleteDelegate;
- (void)returnPeoPleEditInfo:(NSMutableArray *)array;
@end
