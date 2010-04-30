//
//  UserModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActivityModel;
@class Project_UserModel;

@interface UserModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSSet* Project_User;
@property (nonatomic, retain) NSSet* activity;

@end


@interface UserModel (CoreDataGeneratedAccessors)
- (void)addProject_UserObject:(Project_UserModel *)value;
- (void)removeProject_UserObject:(Project_UserModel *)value;
- (void)addProject_User:(NSSet *)value;
- (void)removeProject_User:(NSSet *)value;

- (void)addActivityObject:(ActivityModel *)value;
- (void)removeActivityObject:(ActivityModel *)value;
- (void)addActivity:(NSSet *)value;
- (void)removeActivity:(NSSet *)value;

@end

