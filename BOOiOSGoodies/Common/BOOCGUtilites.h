//
//  TINCGUtilites.h
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 02/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

float CGPointDistanceBetween(CGPoint point1, CGPoint point2){
    float x = point2.x - point1.x;
    float y = point2.y - point1.y;
    return sqrtf((x * x) + (y * y));
}
