//
//  ParkTableViewCell.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/10.
//  Copyright © 2018年 HappyTerry. All rights reserved.
//

#import "ParkTableViewCell.h"

@implementation ParkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellName:(NSString *)name intro:(NSString *)intro {
    [self.nameLabel setText:name];
    if (intro.length > 0) {
        [self.introLabel setText:intro];
    }
}

@end
