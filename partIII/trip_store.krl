ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
Part III Ruleset for Pico I lab BYU CS 462
>>
    author "Calvin McMurray"
    logging on
    shares trips, long_trips, short_trips
    provides trips, long_trips, short_trips
  }

  global {
    long_trips = 7
    trips = function(){
        ent:coll.klog("Known trips:")
    }
    long_trips = function(){
        ent:coll_long.klog("Known long trips:")
    }
    short_trips = function(){
        (ent:coll.filter(function(a){ a{"mileage"} < long_trips })).klog("Known short trips:")
    }
  }

  rule collect_trip {

      select when explicit trip_processed
        pre{
            mileage = event:attr("mileage").klog("our passed in (standard) mileage: ")
            timestamp = time:now()
        }
        always{
            ent:coll.append({"mileage":mileage,"time":timestamp})
        }
  }

  rule collect_long_trip {
    select when explicit found_long_trip
      pre{
        mileage = event:attr("mileage").klog("our passed in (long) mileage: ")
        timestamp = time:now()
      }
      always{
        ent:coll_long.append({"mileage":mileage,"time":timestamp})
      }
  }

  rule clear_trips {
    select when car trip_reset
      pre{
        empty = [].klog("Recieved a clear message!")
      }
      always{
        ent:coll := empty;
        ent:coll_long := empty
      }
  }
}
