# RVCalendarWeekView
Simple but powerful Calendar Week View for iOS With dragable events


Following the work from [MSCollectionView](https://github.com/erichoracek/MSCollectionViewCalendarLayout)
I created this library simplifing its usage

### Installation

Pod pending yet...


### Usage
you can now use storyboard to create a simple UIView extending the RVCalendarView and then just do this:


```
    -(void)viewDidLoad{
        MSEvent* event1 = [AKEvent make:NSDate.now
        title:@"Title"
        location:@"Central perk"];

        MSEvent* event2 = [AKEvent make:[NSDate.now addMinutes:10]  //AddMinutes comes from EasyDate pod
        duration:60*3
        title:@"Title 2"
        location:@"Central perk"];

        _weekView.events = @[event1,event2];        
    }
```

Easy right?

#### Features
To add features to the WeekView I'm using a decorator pattern, this way we can extend the `weekView` with diferent features without the need of multiple inhertance and to have a expressive modular design
However, this adds the need to have a `strong` reference to the `decorator` that will have the features.

So we can add features to the `weekView` with the following code:

```
    self.decoratedWeekView = [MSWeekViewDecoratorFactory make:self.weekView
                                                     features:(MSDragableEventFeature|MSNewEventFeature|MSInfiniteFeature)
                                                  andDelegate:self];
```

This is the fast way where the delegate should have all the methods for each feature delegate (see below).

The long way is something more like the standard `decorator` pattern in case you need more flexibility.

```
    MSWeekView* decoratedView = baseView;
    decoratedView = [MSWeekViewDecoratorInfinite makeWith:decoratedView andDelegate:infiniteDelegate];
    decoratedView = [MSWeekViewDecoratorNewEvent makeWith:decoratedView andDelegate:newEventDelegate];
    decoratedView = [MSWeekViewDecoratorDragable makeWith:decoratedView andDelegate:dragableDelegate];

```

##### Drag and drop
You can get a dragable events calendar using `RVWeekViewDragable` instead.

it will fire the following functions on your `dragDelegate`

``` 
    -(BOOL)MSWeekView:(MSWeekView*)weekView canMoveEvent:(MSEvent*)event to:(NSDate*)date;

    -(void)MSWeekView:(MSWeekView*)weekView event:(MSEvent*)event moved:(NSDate*)date;

```


##### Create new event on long press

```
    -(void)MSWeekView:(MSWeekView*)weekView onLongPressAt:(NSDate*)date
```

##### Infinite scroll


```
    -(void)MSWeekView:(MSWeekView*)weekView newDaysLoaded:(NSDate*)startDate to:(NSDate*)endDate;
```

##### Options
You can even customeize some options

```
_weekView.weekFlowLayout.show24Hours    = YES; //Show All hours or just the min to cover all events
_weekView.daysToShowOnScreen            = 7;   //How many days visible at the same time
_weekView.daysToShow                    = 31;  //How many days to display (Ininite scroll feature pending)
```


![drag and drop](https://github.com/BadChoice/RVCalendarWeekView/blob/master/readme_images/drag_n_drop.gif?raw=true)   

![iPhone](https://github.com/BadChoice/RVCalendarWeekView/blob/master/readme_images/iphone.png?raw=true)   

![iPad](https://github.com/BadChoice/RVCalendarWeekView/blob/master/readme_images/ipad.png?raw=true)   

