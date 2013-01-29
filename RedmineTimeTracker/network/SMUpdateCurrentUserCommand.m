//
//  SMUpdateCurrentUserCommand.m
//  RedmineTimeTracker
//
//  Created by pfy on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMUpdateCurrentUserCommand.h"
#import "SMCurrentUser+trackingExtension.h"
#import "SMManagedObject+networkExtension.h"

@implementation SMUpdateCurrentUserCommand
-(void)run:(SMNetworkUpdate *)networkUpdateCenter{
    LOG_INFO(@"update current user");
    [networkUpdateCenter.client getPath:@"users/current.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            [[SMCurrentUser findOrCreate] updateWithDict:responseObject andSet:nil];
            [networkUpdateCenter queueItemFinished:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_ERR(@"error happend %@",error);
        [networkUpdateCenter queueItemFailed:self];
    } ];
}
@end
