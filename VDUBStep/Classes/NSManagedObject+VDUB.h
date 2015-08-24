//
//  NSManagedObject+VDUB.h
//  VDUBStep
//
//  Copyright (c) 2015 VDUB Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (VDUB)

+ (id)createInContext:(NSManagedObjectContext *)context;

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
						inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllWithRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

+ (id)findFirstInContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
				   inContext:(NSManagedObjectContext *)context;
+ (id)findFirstWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSUInteger)countAllInContext:(NSManagedObjectContext *)context;
+ (NSUInteger)countAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

- (void)delete;

@end
