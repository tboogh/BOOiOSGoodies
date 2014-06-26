//
//  BOOInsetLabel.m
//  Catalog
//
//  Created by Tobias Boogh on 28/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOInsetLabel.h"

@implementation BOOInsetLabel

-(void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
