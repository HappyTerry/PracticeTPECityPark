//
//  ParkModel.h
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/27.
//  Copyright © 2018 HappyTerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkModel : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * location;
@property (strong, nonatomic) NSString * behavior;
@property (strong, nonatomic) NSString * picUrl;

- (id)initWithData:(NSDictionary *)data;

@end
