//
//  NCTableViewFooterView.m
//  Neocom
//
//  Created by Artem Shimanski on 30.01.16.
//  Copyright © 2016 Artem Shimanski. All rights reserved.
//

#import "NCTableViewFooterView.h"

@implementation NCTableViewFooterView

@synthesize textLabel = _textLabel;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
		NSArray* objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
		UIView* view = objects[0];
		view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:view];
		
		NSDictionary* bindings = NSDictionaryOfVariableBindings(view);
		NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:bindings];
		[self.contentView addConstraints:constraints];
		constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:bindings];
		[self.contentView addConstraints:constraints];
		
		view = self.contentView;
		bindings = NSDictionaryOfVariableBindings(view);
		constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0@760-[view]-0@760-|" options:0 metrics:nil views:bindings];
		[self addConstraints:constraints];
		constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0@760-[view]-0@760-|" options:0 metrics:nil views:bindings];
		[self addConstraints:constraints];
		self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
		
		self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
		self.backgroundView.opaque = NO;
	}
	return self;
}

@end
