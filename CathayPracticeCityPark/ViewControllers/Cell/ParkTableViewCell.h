//
//  ParkTableViewCell.h
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/10.
//  Copyright © 2018年 HappyTerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

- (void)configureCellName:(NSString *)name intro:(NSString *)intro;

@end
