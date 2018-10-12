//
//  ParkModel.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/27.
//  Copyright © 2018 HappyTerry. All rights reserved.
//

#import "ParkModel.h"
#import "Helper.h"

@implementation ParkModel

- (id)init {
    self = [super init];
    if(self){
        self.name = @"";
        self.location = @"";
        self.behavior = @"";
        self.picUrl = @"";
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    self.name = [Helper getStringValueWithColumn:@"A_Name_Ch" data:data];
    self.location = [Helper getStringValueWithColumn:@"A_Location" data:data];
    self.behavior = [Helper getStringValueWithColumn:@"A_Behavior" data:data];
    self.picUrl = [Helper getStringValueWithColumn:@"A_Pic01_URL" data:data];
    if ([self.behavior isEqualToString:@""]) {
        self.behavior = [Helper getStringValueWithColumn:@"A_Interpretation" data:data];
        if ([self.behavior isEqualToString:@""]) {
            self.behavior = @" ";
        }
    }
    return self;
}

@end
