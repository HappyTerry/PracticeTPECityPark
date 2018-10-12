//
//  Helper.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/27.
//  Copyright © 2018 HappyTerry. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *)getStringValueWithColumn:(NSString *)column data:(NSDictionary *)data {
    if ([data.allKeys containsObject:column]) {
        return [NSString stringWithFormat:@"%@", data[column]];
    }
    return @"";
}

+ (int)getIntValueWithColumn:(NSString *)column data:(NSDictionary *)data {
    NSString * result = [self getStringValueWithColumn:column data:data];
    if (result.length > 0) {
        return [result intValue];
    }
    return 0;
}

@end
