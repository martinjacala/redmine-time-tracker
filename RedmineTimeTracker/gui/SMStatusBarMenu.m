//
//  SMStatusBarMenu.m
//  RedmineTimeTracker
//
//  Created by Florian Friedrich on 17.5.14.
//  Copyright (c) 2014 Smooh AG. All rights reserved.
//

#import "SMStatusBarMenu.h"
#import "SMCurrentUser+trackingExtension.h"
#import "SMTimeEntry+DisplayThingi.h"
#import "MASShortcut+UserDefaults.h"

@interface SMStatusBarMenu ()
@property (nonatomic, strong, readonly) NSSet *shortcutKeys;
@end

@implementation SMStatusBarMenu
@synthesize shortcutKeys = _shortcutKeys;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.windowsManager = [SMWindowsManager sharedWindowsManager];
        self.user = [SMCurrentUser findOrCreate];
        
        self.startTrackingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Start Tracking"
                                                                action:@selector(showStartTrackingWindow:)
                                                         keyEquivalent:@""];
        self.startTrackingMenuItem.target = self.windowsManager;
        
        self.stopTrackingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Stop Tracking"
                                                               action:@selector(stopTracking)
                                                        keyEquivalent:@""];
        self.stopTrackingMenuItem.target = self;
        
        self.createNewTimeEntryMenuItem = [[NSMenuItem alloc] initWithTitle:@"Create Time Entry"
                                                                 action:@selector(showNewTimeEntryWindow:)
                                                          keyEquivalent:@""];
        self.createNewTimeEntryMenuItem.target = self.windowsManager;
        
        self.createNewIssueMenuItem = [[NSMenuItem alloc] initWithTitle:@"Create Issue"
                                                                 action:@selector(showNewIssueWindow:)
                                                          keyEquivalent:@""];
        self.createNewIssueMenuItem.target = self.windowsManager;
        
        self.applicationsTrackerMenuItem = [[NSMenuItem alloc] initWithTitle:@"Applications"
                                                                      action:@selector(showApplicationTrackerWindow:)
                                                               keyEquivalent:@""];
        self.applicationsTrackerMenuItem.target = self.windowsManager;
        
        self.preferencesMenuItem = [[NSMenuItem alloc] initWithTitle:@"Preferences"
                                                              action:@selector(showPreferencesWindow:)
                                                       keyEquivalent:@""];
        self.preferencesMenuItem.target = self.windowsManager;
        
        self.statusMenu = [[NSMenu alloc] initWithTitle:@"RedmineTimeTracker"];
        self.statusMenu.autoenablesItems = NO;
        [self.statusMenu addItem:self.startTrackingMenuItem];
        [self.statusMenu addItem:self.stopTrackingMenuItem];
        [self.statusMenu addItem:self.createNewTimeEntryMenuItem];
        [self.statusMenu addItem:self.createNewIssueMenuItem];
        [self.statusMenu addItem:self.applicationsTrackerMenuItem];
        [self.statusMenu addItem:self.preferencesMenuItem];
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusItem.menu = self.statusMenu;
        self.statusItem.highlightMode = YES;
        
        [self addShortcutObservers];
        [self.user addObserver:self forKeyPath:@"currentTimeEntry"
                       options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                       context:nil];
        [self updateStatusText];
        [self configureMenuItemsWithShortcuts];
    }
    return self;
}

- (void)dealloc
{
    [self removeShortcutObservers];
    // TODO: Remove Observer from user
}

#pragma mark - Shortcuts
- (NSSet *)shortcutKeys
{
    if (!_shortcutKeys) {
        _shortcutKeys = [NSSet setWithArray:@[@"SMStartTrackingShortcut",
                                              @"SMStopTrackingShortcut",
                                              @"SMNewIssueShortcut"]];
    }
    return _shortcutKeys;
}

- (void)registerHotkey {
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"SMStartTrackingShortcut" handler:^{
        [self.windowsManager showStartTrackingWindow:self.startTrackingMenuItem];
    }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"SMStopTrackingShortcut" handler:^{
        [self stopTracking];
    }];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:@"SMNewIssueShortcut" handler:^{
        [self.windowsManager showNewIssueWindow:self.createNewIssueMenuItem];
    }];
}

- (void)addShortcutObservers
{
    [self.shortcutKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:keyPath
                                                                     options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                                                                     context:nil];
    }];
}

- (void)removeShortcutObservers
{
    [self.shortcutKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:keyPath];
    }];
}

- (void)configureMenuItemsWithShortcuts
{
    [self configureMenuItemsWithShortcutsForKeyPath:nil];
}

- (void)configureMenuItemsWithShortcutsForKeyPath:(NSString *)keyPath
{
    MASShortcut *shortcut;
    if (keyPath) {
        NSData *data = [[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:keyPath];
        shortcut = [MASShortcut shortcutWithData:data];
    }
    NSString *keyEquiv = shortcut.keyCodeStringForKeyEquivalent ?: @"";
    NSUInteger *modifierMask = shortcut.modifierFlags;
    if (!keyPath || [keyPath isEqualToString:@"values.SMStartTrackingShortcut"]) {
        self.startTrackingMenuItem.keyEquivalent = keyEquiv;
        self.startTrackingMenuItem.keyEquivalentModifierMask = modifierMask;
    }
    if (!keyPath || [keyPath isEqualToString:@"values.SMStopTrackingShortcut"]) {
        self.stopTrackingMenuItem.keyEquivalent = keyEquiv;
        self.stopTrackingMenuItem.keyEquivalentModifierMask = modifierMask;
    }
    if (!keyPath || [keyPath isEqualToString:@"values.SMNewIssueShortcut"]) {
        self.createNewIssueMenuItem.keyEquivalent = keyEquiv;
        self.createNewIssueMenuItem.keyEquivalentModifierMask = modifierMask;
    }
}

#pragma mark - Menu Item
- (BOOL)validateMenuItem:(NSMenuItem *)item
{
    return YES;
}

#pragma mark - Tracking
- (void)stopTracking
{
    [SMCurrentUser findOrCreate].currentTimeEntry = nil;
    SAVE_APP_CONTEXT;
}

- (void)setEntry:(SMTimeEntry *)entry
{
    if (entry != _entry){
        [_entry removeObserver:self forKeyPath:@"formattedTime"];
        _entry = entry;
        [_entry addObserver:self forKeyPath:@"formattedTime"
                   options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                   context:nil];
    }
}

- (void)updateStatusText
{
    [self setEntry:self.user.currentTimeEntry];
    if (self.entry) {
        [self.statusItem setTitle:[NSString stringWithFormat:@"%@", self.entry.formattedTime]];
    } else {
        [self.statusItem setTitle:@"Idle"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == [NSUserDefaultsController sharedUserDefaultsController]) {
        [self configureMenuItemsWithShortcutsForKeyPath:keyPath];
    } else if (object == self.entry) {
        [self updateStatusText];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
