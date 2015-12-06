//
//  Food.h
//  myhumm
//
//  Created by Kankemwa Ishaku on 06/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Food : NSObject
@property NSString *name;
@property NSString *estimated_delivery;
@property NSString *restaurant;
@property UIImage *image;
@property NSInteger rating;

- (id)name:(NSString *)name : (NSString *)estimated_delivery : (NSString *)image : (NSInteger) rating :(NSString*)restaurant;

@end
