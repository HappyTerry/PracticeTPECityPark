//
//  ParkManager.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/10/2.
//  Copyright © 2018 HappyTerry. All rights reserved.
//

#import "ParkManager.h"

@implementation ParkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPSessionManager alloc] init];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain", nil];
        self.manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 300)];
    }
    return self;
}

- (void)getListWithLimit:(int)limit
                  offset:(int)offset
       completionHandler:(void (^)(NSDictionary * result))completionHandler {
    NSString *URLString = @"http://data.taipei/opendata/datalist/apiAccess";
    NSDictionary *parameters =
    @{@"scope": @"resourceAquire",
      @"rid": @"a3e2b221-75e0-45c1-8f97-75acbd43d613",
      @"limit": [NSString stringWithFormat:@"%d",limit],
      @"offset": [NSString stringWithFormat:@"%d",offset]
      };
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [[self.manager dataTaskWithRequest:request
                        uploadProgress:nil
                      downloadProgress:nil
                     completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
                         if (error) {
                             NSLog(@"Error: %@", error);
                         } else {
                             NSLog(@"response \n%@ \nresponse object \n%@", response, responseObject);
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completionHandler(responseObject);
                             });
                         }
                     }] resume];
}
@end
