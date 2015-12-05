//
//  Sky.h
//  myhumm
//
//  Created by Kankemwa Ishaku on 05/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sky : NSObject
@property NSInteger *programme_uuid;
@property NSString *name;
@property NSString *genre;
@property NSString *sub_genres;
@property NSString *tags;
@property NSString *synopsis;
@property UIImage *image;

- (id)name:(NSString *)name :(NSString *)sub_genres : (NSString *)image;

@end
