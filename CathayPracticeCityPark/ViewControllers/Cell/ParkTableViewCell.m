//
//  ParkTableViewCell.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/10.
//  Copyright © 2018年 HappyTerry. All rights reserved.
//

#import "ParkTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ParkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellName:(NSString *)name location:(NSString *)location behavior:(NSString *)behavior picUrl:(NSString *)picUrl {
    [self.nameLabel setText:name];
    [self.locationLabel setText:location];
    [self.behaviorLabel setText:behavior];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
}

@end
