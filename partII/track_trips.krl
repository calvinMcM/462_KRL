ruleset track_trips_II {
  meta {
    name "Track Trips II"
    description <<
Part II Ruleset for Pico I lab BYU CS 462
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

  rule process_trip {

      select when car new_trip
      fired{
        raise explicit event "trip_processed"
          attributes event:attrs()
      }
  }

  rule find_long_trips{
      select when explicit trip_processed
        pre {
            milage = event:attr("milage").klog("our passed in mileage: ").as("Number")
        }
        if(milage > long_trip) then
            noop()
            fired{
              raise explicit event "found_long_trip"
            }
  }
}
