//
//  StartTrackingWindowController.m
//  RedmineTimeTracker
//
//  Created by pfy on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "StartTrackingWindowController.h"

@interface StartTrackingWindowController ()

@end

@implementation StartTrackingWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] setLevel:NSFloatingWindowLevel];
    [[self window] makeKeyWindow];
    [NSApp activateIgnoringOtherApps:YES];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
