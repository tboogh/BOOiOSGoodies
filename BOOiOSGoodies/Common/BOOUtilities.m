//
//  BOOUtilities.m
//  Catalog
//
//  Created by Tobias Boogh on 05/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOUtilities.h"

float CGPointDistanceBetween(CGPoint point1, CGPoint point2){
    float x = point2.x - point1.x;
    float y = point2.y - point1.y;
    return sqrtf((x * x) + (y * y));
}

float DegreeToRad(float degree){
    return degree / 180 * M_PI;
}