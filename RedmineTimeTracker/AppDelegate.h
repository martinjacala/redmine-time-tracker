//
//  AppDelegate.h
//  RedmineTimeTracker
//
//  Created by pfy on 23.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusBarMenu.h"
#import "ActiveApplicationTracker.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) NSOperationQueue *asyncDbQueue;


@property (nonatomic,strong) StatusBarMenu  *statusBarMenu;
@property (nonatomic,strong)  ActiveApplicationTracker *activeApplicationTracker;

- (IBAction)saveAction:(id)sender;

@end
