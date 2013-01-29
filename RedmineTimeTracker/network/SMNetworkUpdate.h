//
//  SMNetworkUpdate.h
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCurrentUser+trackingExtension.h"
#import "SMHttpClient.h"
@class SMNetworkUpdateCommand;

@interface SMNetworkUpdate : NSObject
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,weak) SMCurrentUser *user;
@property (nonatomic,strong) SMHttpClient *client;
@property (nonatomic,strong) NSMutableArray *allCommands;


-(void)update;
-(void)queueItemFinished:(SMNetworkUpdateCommand*)cmd;
-(void)queueItemFailed:(SMNetworkUpdateCommand*)cmd;

@end
