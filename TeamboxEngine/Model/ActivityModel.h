//
//  ActivityModel.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 30/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CommentModel;
@class ProjectModel;
@class UserModel;

@interface ActivityModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSNumber * target_id;
@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSString * target_type;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * update_at;
@property (nonatomic, retain) NSString * comment_type;
@property (nonatomic, retain) NSNumber * activity_id;
@property (nonatomic, retain) CommentModel * Comment;
@property (nonatomic, retain) ProjectModel * project;
@property (nonatomic, retain) UserModel * user;

@end



