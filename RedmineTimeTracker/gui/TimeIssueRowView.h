//
//  TimeIssueRowView.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 29.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TimeIssueRowView : NSTableCellView
@property (nonatomic,weak) IBOutlet NSButton *pauseButton;
@property (nonatomic,weak) IBOutlet NSTextField *timeTextField;

-(IBAction)pressPause:(id)sender;
-(IBAction)pressIssueSubject:(id)sender;
@end
