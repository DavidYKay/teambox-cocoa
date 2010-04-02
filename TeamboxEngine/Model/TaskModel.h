//
//  TaskModel.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 01/04/10.
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
@property (nonatomic, retain) NSNumber * task_list_id;
@property (nonatomic, retain) NSDate * due_on;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSDate * completed_at;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TaskListModel * TaskList;
@property (nonatomic, retain) ActivityModel * Activity;

@end



