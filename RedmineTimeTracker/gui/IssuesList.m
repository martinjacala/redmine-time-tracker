//
//  IssuesList.m
//  RedmineTimeTracker
//
//  Created by pfy on 24.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import "IssuesList.h"
#import "SMIssue.h"


@implementation IssuesList
-(id)init{
    self = [super init];
    if(self){
        NSManagedObjectContext *context = [(AppDelegate*)[NSApplication sharedApplication].delegate managedObjectContext];
        BOOL result;
        self.issuesArrayController = [[NSArrayController alloc] initWithContent:nil];
        [self.issuesArrayController setManagedObjectContext:context];
        [self.issuesArrayController setEntityName:@"SMIssue"];
        NSError *error;
        if ([self.issuesArrayController fetchWithRequest:nil merge:YES error:&error] == NO)
            result = NO;
        else
        {
            //do all that other pageArrayController configuration stuff
            result = [self.issuesArrayController setSelectionIndex:0];
        }
    }
    return self;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil){
        return [[self.issuesArrayController arrangedObjects] count ];
    }
    return 0;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    return NO;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        return [[self.issuesArrayController arrangedObjects] objectAtIndex:index ];
    }
    return 0;
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    SMIssue *issue = item;
    if(issue.n_subject)
        [cell setTitle:issue.n_subject];
}

@end
