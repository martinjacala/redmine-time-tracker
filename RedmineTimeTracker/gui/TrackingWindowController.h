//
//  TrackingWindowController.h
//  RedmineTimeTracker
//
//  Created by David Gunzinger Smooh GmbH on 28.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TrackingWindowController : NSWindowController
@property (nonatomic,weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic,weak) IBOutlet NSArrayController *timeEntryArrayController;
@property (nonatomic,strong)  NSManagedObjectContext *context;
@property (nonatomic,strong)  NSDate *currentDate;
@property (nonatomic,strong)  NSString *currentDateString;
@property (nonatomic,strong) NSDateFormatter *formatter;

-(IBAction)nextDay:(id)sender;
-(IBAction)prevDay:(id)sender;
-(IBAction)today:(id)sender;
-(IBAction)refresh:(id)sender;

- (NSArray *)timeEntrySortDescriptors;

@end
