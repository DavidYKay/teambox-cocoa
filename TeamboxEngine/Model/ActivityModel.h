//
//  ActivityModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CommentModel;
@class ConversationModel;
@class ProjectModel;
@class TaskListModel;
@class TaskModel;
@class UserModel;

@interface ActivityModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * comment_type;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSNumber * activity_id;
@property (nonatomic, retain) NSString * target_type;
@property (nonatomic, retain) NSDate * update_at;
@property (nonatomic, retain) NSNumber * target_id;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * created_at_string;
@property (nonatomic, retain) UserModel * User;
@property (nonatomic, retain) TaskModel * Task;
@property (nonatomic, retain) ProjectModel * Project;
@property (nonatomic, retain) CommentModel * Comment;
@property (nonatomic, retain) TaskListModel * TaskList;
@property (nonatomic, retain) ConversationModel * Conversation;

@end



