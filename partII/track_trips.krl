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
  }

  rule process_trip {
      select when car new_trip
      pre {
          milage = event:attr("milage").klog("our passed in mileage: ")
      }
      send_directive("trip") with
        trip_length = milage
  }

}
