//
//  TeamboxEngineHeaders.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#if TARGET_OS_IPHONE
	#import <Foundation/Foundation.h>
	#import <UIKit/UIKit.h>
#else
	#import <Cocoa/Cocoa.h>
#endif

#pragma mark -
#pragma mark Settings
#pragma mark -

#define kLaunchDateSettingsKey @"lastLaunch"
#define kUserNameSettingsKey @"username"
#define kPaswordSettingsKey @"password"

#pragma mark -
#pragma mark URLs
#pragma mark -
#pragma mark # Activity

#if defined(LOCAL)
#define KActivitiesAllXML @"http://%@:%@@0.0.0.0:3000/activities.xml"
#define KActivitiesAllJSON @"http://%@:%@@0.0.0.0:3000/activities.json"
#define KActivitiesAllNewXML @"http://%@:%@@0.0.0.0:3000/activities/%@/show_new.xml"
#define KActivitiesAllNewJSON @"http://%@:%@@0.0.0.0:3000/activities/%@/show_new.json"
#define KActivitiesAllMoreXML @"http://%@:%@@0.0.0.0:3000/activities/%@/show_more.xml"
#define KActivitiesProjectAllXML @"http://%@:%@@0.0.0.0:3000/projects/%@/activities.xml"
#define KActivitiesProjectNewXML @"http://%@:%@@0.0.0.0:3000/projects/%@/activities/%@/show_new.xml"
#define KActivitiesProjectMoreXML @"http://%@:%@@0.0.0.0:3000/projects/%@/activities/%@/show_more.xml"
#define KProjectsXML @"http://%@:%@@0.0.0.0:3000/projects.xml"
#define KProjectsJSON @"http://%@:%@@0.0.0.0:3000/projects.json"
#define KTaskListXML @"http://%@:%@@0.0.0.0:3000/task_lists.xml"
#define KTaskListWithProjectXML @"http://%@:%@@0.0.0.0:3000/projects/%@/task_lists.xml"
#define KConversationsWithProjectXML @"http://%@:%@@0.0.0.0:3000/projects/%@/conversations.xml"
#define KPagesWithProjectXML @"http://%@:%@@0.0.0.0:3000/projects/%@/pages.xml"
#define KTeamboxURL @"http://0.0.0.0:3000/projects.xml"
#define kUserXML @"http://0.0.0.0:3000/users/%@.xml"
#define kUsersXML @"http://0.0.0.0:3000/users.xml"
#define KPostComment @"http://%@:%@@0.0.0.0:3000/projects/%@/comments"
#else
#define KActivitiesAllXML @"http://%@:%@@teambox.com/activities.xml"
#define KActivitiesAllJSON @"http://%@:%@@0.0.0.0:3000/activities.json"
#define KActivitiesAllNewXML @"http://%@:%@@teambox.com/activities/%@/show_new.xml"
#define KActivitiesAllNewJSON @"http://%@:%@@0.0.0.0:3000/activities/%@/show_new.json"
#define KActivitiesAllMoreXML @"http://%@:%@@teambox.com/activities/%@/show_more.xml"
#define KActivitiesProjectAllXML @"http://%@:%@@teambox.com/projects/%@/activities.xml"
#define KActivitiesProjectNewXML @"http://%@:%@@teambox.com/projects/%@/activities/%@/show_new.xml"
#define KActivitiesProjectMoreXML @"http://%@:%@@teambox.com/projects/%@/activities/%@/show_more.xml"
#define KProjectsXML @"http://%@:%@@teambox.com/projects.xml"
#define KProjectsJSON @"http://%@:%@teambox.com/projects.json"
#define KTaskListXML @"http://%@:%@@teambox.com/task_lists.xml"
#define KTaskListWithProjectXML @"http://%@:%@@teambox.com/projects/%@/task_lists.xml"
#define KConversationsWithProjectXML @"http://%@:%@@teambox.com/projects/%@/conversations.xml"
#define KPagesWithProjectXML @"http://%@:%@@teambox.com/projects/%@/pages.xml"
#define KTeamboxURL @"http://teambox.com/projects.xml"
#define kUserXML @"http://teambox.com/users/%@.xml"
#define kUsersXML @"http://teambox.com/users.xml"
#define KPostComment @"http://%@:%@@teambox.com/projects/%@/comments"
#endif