//
//  MyDocument.h
//  Teambox-Engine
//
//  Created by Alejandro JL on 26/03/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TeamboxEngine.h"

@interface MyDocument : NSPersistentDocument <TeamboxEngineDelegate> {
	TeamboxEngine *engine;
}

@end
