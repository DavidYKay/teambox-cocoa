//
//  Project_UserModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ProjectModel;
@class UserModel;

@interface Project_UserModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * role;
@property (nonatomic, retain) NSNumber * created_at;
@property (nonatomic, retain) ProjectModel * Project;
@property (nonatomic, retain) UserModel * User;

@end



