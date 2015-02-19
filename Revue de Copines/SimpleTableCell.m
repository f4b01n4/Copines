//
//  SimpleTableCell.m
//  Revue de Copines
//
//  Created by Fábio Violante on 01/12/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell

@synthesize nameLabel = _nameLabel;
@synthesize themesLabel = _themesLabel;
@synthesize photoImageView = _photoImageView;
@synthesize checkImageView = _checkImageView;

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
