//
//  ParkManager.h
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/10/2.
//  Copyright © 2018 HappyTerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface ParkManager : NSObject

@property AFHTTPSessionManager * manager;

- (void)getListWithLimit:(int)limit
                  offset:(int)offset
       completionHandler:(void (^)(NSDictionary * result))completionHandler;

@end
