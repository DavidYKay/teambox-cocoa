//
//  TaskList.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 31/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;
@class Task;

@interface TaskList :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSDate * start_on;
@property (nonatomic, retain) NSNumber * assigned_id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSDate * completed_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * finish_on;
@property (nonatomic, retain) NSSet* Task;
@property (nonatomic, retain) ActivityModel * Activity;

@end


@interface TaskList (CoreDataGeneratedAccessors)
- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)value;
- (void)removeTask:(NSSet *)value;

@end

