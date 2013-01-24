//
//  SMUpdateOperation.m
//  entertrainment
//
//  Created by pfy on 22.10.12.
//  Copyright (c) 2012 pfy. All rights reserved.
//

#import "SMUpdateOperation.h"
#import "AppDelegate.h"

@implementation SMUpdateOperation
-(void)main{
    int max_faults = 10;
    while(max_faults){
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        [context setPersistentStoreCoordinator:[(AppDelegate*)[UIApplication sharedApplication].delegate persistentStoreCoordinator]];
        [context setUndoManager:nil];
        
        NSError *error = nil;
        @try {
            /* execute the associated object context block */
        self.block(context);
        } @catch (NSException *exception) {
            if ([[exception name] isEqualToString:NSObjectInaccessibleException]){
                LOG_INFO(@"block did fault, will retry");
            }
            else
                [exception raise];      // Unknown exception thrown.
        }
        [context processPendingChanges];

        @try {
            /* save it */
            [context save:&error];
        }
        @catch (NSException *exception) {
            if ([[exception name] isEqualToString:NSObjectInaccessibleException]){
                LOG_INFO(@"save did fault, will retry");
                                // Deleted.
            }
            else
                [exception raise];      // Unknown exception thrown.
        }

        if(error){
           // LOG_INFO(@"did fail safe managed object context %@, tries %d",error,max_faults);
            max_faults--;
        } else {
            //if(max_faults != 10)
             //   LOG_INFO(@"did success safe managed object context after %d",10-max_faults);
            max_faults = 0;
        }        
        [context release];
    }
}
+(SMUpdateOperation*)operationWithBlock:(ContextBlock) block{
    SMUpdateOperation *operation = [SMUpdateOperation new];
    operation.block = block;
    return [operation autorelease];
}
-(void)dealloc{
    self.block = nil;
    [super dealloc];
}

@end
