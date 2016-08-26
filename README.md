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
        AKEvent* event1 = [AKEvent make:NSDate.now
        title:@"Title"
        location:@"Central perk"];

        AKEvent* event2 = [AKEvent make:[NSDate.now addMinutes:10]
        duration:60*3
        title:@"Title 2"
        location:@"Central perk"];

        _weekView.events = @[event1,event2];        
    }
```

Easy right?


#### Drag and drop
You can get a dragable events calendar using `RVWeekViewDragable` instead.

it will fire the following functions on your `dragDelegate`

``` 
-(BOOL)RVWeekView:(RVWeekView*)weekView canMoveEvent:(AKEvent*)event to:(NSDate*)date;

-(void)RVWeekView:(RVWeekView*)weekView event:(AKEvent*)event moved:(NSDate*)date;

```

#### Options
You can even customeize some options

```
_weekView.weekFlowLayout.show24Hours    = YES; //Show All hours or just the min to cover all events
_weekView.daysToShowOnScreen            = 7;   //How many days visible at the same time
_weekView.daysToShow                    = 31;  //How many days to display (Ininite scroll feature pending)
```


![drag and drop](https://github.com/BadChoice/RVCalendarWeekView/blob/master/readme_images/drag_n_drop.gif?raw=true)   

![iPhone](https://github.com/BadChoice/RVCalendarWeekView/blob/master/readme_images/iphone.png?raw=true)   

![iPad](https://github.com/BadChoice/RVCalendarWeekView/blob/master/readme_images/ipad.png?raw=true)   

