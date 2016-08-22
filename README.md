# RVCalendarWeekView
Simple but powerful Calendar Week View for iOS 

Following the work from (MSCollectionView) [https://github.com/erichoracek/MSCollectionViewCalendarLayout]
I created this library simplifing its usage

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
