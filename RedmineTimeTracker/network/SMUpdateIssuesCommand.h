//
//  SMUpdateIssuesCommand.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "SMNetworkUpdateCommand.h"

@interface SMUpdateIssuesCommand : SMNetworkUpdateCommand
@property (nonatomic,strong) NSMutableArray *allIssues;
@property (nonatomic,weak) SMNetworkUpdate *center;

@end
