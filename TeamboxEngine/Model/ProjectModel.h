//
//  ProjectModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;
@class Project_UserModel;

@interface ProjectModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSNumber * owner_user_id;
@property (nonatomic, retain) NSString * permalink;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* Project_User;
@property (nonatomic, retain) NSSet* activity;

@end


@interface ProjectModel (CoreDataGeneratedAccessors)
- (void)addProject_UserObject:(Project_UserModel *)value;
- (void)removeProject_UserObject:(Project_UserModel *)value;
- (void)addProject_User:(NSSet *)value;
- (void)removeProject_User:(NSSet *)value;

- (void)addActivityObject:(ActivityModel *)value;
- (void)removeActivityObject:(ActivityModel *)value;
- (void)addActivity:(NSSet *)value;
- (void)removeActivity:(NSSet *)value;

@end

