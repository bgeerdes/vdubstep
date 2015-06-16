//
//  NSManagedObject+VDUB.m
//  VDUBStep
//
//  Copyright (c) 2015 VDUB Software. All rights reserved.
//

#import "NSManagedObject+VDUB.h"

#import "VDUBStore.h"

@implementation NSManagedObject (VDUB)

+ (id)createInContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
										 inManagedObjectContext:context];
}

+ (NSString *)entityName
{
	NSString *entityName = nil;
	
	if ([self respondsToSelector:@selector(entityName)]) {
		entityName = [self performSelector:@selector(entityName)];
	} else {
		NSLog(@"error getting entity name, %@ not generated by mogen?", [self class]);
	}
	
	return entityName;
}

#pragma mark -

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context
{
	return [self findAllWithPredicate:nil sortDescriptors:nil inContext:context];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
	return [self findAllWithPredicate:predicate sortDescriptors:nil inContext:context];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
						inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
	request.predicate = predicate;
	request.sortDescriptors = sortDescriptors;
	
	return [self findAllWithRequest:request inContext:context];
}

+ (NSArray *)findAllWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
	return [self findAllWithPredicate:nil sortDescriptors:sortDescriptors inContext:context];
}

+ (NSArray *)findAllWithRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	NSArray *results = nil;
	
	NSError *error = nil;
	results = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"error executing request: %@", error);
	}
	
	return results;
}

#pragma mark -

+ (id)findFirstInContext:(NSManagedObjectContext *)context
{
	return [self findFirstWithPredicate:nil sortDescriptors:nil inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
	return [self findFirstWithPredicate:predicate sortDescriptors:nil inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
				   inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
	request.predicate = predicate;
	request.sortDescriptors = sortDescriptors;
	request.fetchLimit = 1;
	
	return [[self findAllWithRequest:request inContext:(NSManagedObjectContext *)context] lastObject];
}

+ (id)findFirstWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
	return [self findFirstWithPredicate:nil sortDescriptors:sortDescriptors inContext:context];
}

#pragma mark -

+ (NSUInteger)countAllInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
	
	NSError *error = nil;
	NSUInteger count = [context countForFetchRequest:request error:&error];
	if (error) {
		NSLog(@"error getting count: %@", error);
	}
	
	return count;
}

#pragma mark -

- (void)delete
{
	[self.managedObjectContext deleteObject:self];
}

@end
