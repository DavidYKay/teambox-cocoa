//
//  TaskModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;
@class TaskListModel;

@interface TaskModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * assigned_id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSNumber * task_list_id;
@property (nonatomic, retain) NSDate * due_on;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSDate * completed_at;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TaskListModel * TaskList;
@property (nonatomic, retain) NSSet* Activity;

@end


@interface TaskModel (CoreDataGeneratedAccessors)
- (void)addActivityObject:(ActivityModel *)value;
- (void)removeActivityObject:(ActivityModel *)value;
- (void)addActivity:(NSSet *)value;
- (void)removeActivity:(NSSet *)value;

@end

