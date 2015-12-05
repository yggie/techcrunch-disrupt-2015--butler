//
//  Sky.m
//  myhumm
//
//  Created by Kankemwa Ishaku on 05/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import "Sky.h"

@implementation Sky

- (id)name:(NSString *)name :(NSString *)sub_genres :  (NSString *)image{
    self.name = name;
    self.sub_genres = sub_genres;
    self.image = [UIImage imageNamed:image];
    return self;
}

@end
