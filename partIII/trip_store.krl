ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
Part III Ruleset for Pico I lab BYU CS 462
>>
    author "Calvin McMurray"
    logging on
    shares new_trip, __testing
  }

  global {
    __testing = {
        "queries": [],
        "events": [
            {
                "domain": "car",
                "type": "new_trip",
                "attrs": ["name"]
            }
        ]
    }
    long_trip = 7
  }

  rule collect_trip {

      select when explicit trip_processed
        pre{
            mileage = event:attr("milage").klog("our passed in mileage: ")
            timestamp = time:now()
        }
        always{
            ent:coll.append({"mileage":mileage,"time":timestamp})
        }
  }

  rule collect_long_trip {
    select when explicit found_long_trip
      pre{
        mileage = event:attr("milage").klog("our passed in mileage: ")
        timestamp = time:now()
      }
      always{
        ent:coll_long.append({"mileage":mileage,"time":timestamp})
      }
  }

  rule clear_trips {
    select when car trip_reset
      pre{
        empty = []
      }
      always{
        ent:coll := empty;
        ent:coll_long := empty
      }
  }
}
