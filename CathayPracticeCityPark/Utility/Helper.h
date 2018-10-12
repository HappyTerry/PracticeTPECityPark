//
//  Helper.h
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/27.
//  Copyright © 2018 HappyTerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (NSString *)getStringValueWithColumn:(NSString *)column data:(NSDictionary *)data;
+ (int)getIntValueWithColumn:(NSString *)column data:(NSDictionary *)data;

@end
