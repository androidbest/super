//
//  CalendarView.h
//  zwy
//
//  Created by cqsxit on 14-2-13.
//  Copyright (c) 2014年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "KxMenu.h"
@interface CalendarView : BaseView<UICollectionViewDelegate,UICollectionViewDataSource,KxMenuViewdelegate>
@property (strong ,nonatomic) UICollectionView *collView;
@property (strong, nonatomic) IBOutlet UIButton *btnLeft;
@property (strong, nonatomic) IBOutlet UIButton *btnCalendar;
@property (strong, nonatomic) IBOutlet UIButton *btnRight;
@property (strong, nonatomic) IBOutlet UIButton *btnShowDown;

@end
