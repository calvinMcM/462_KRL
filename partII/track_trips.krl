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
        "queries": [
        ],
        "events": [
            {
                "domain": "car",
                "type": "new_trip",
                "attrs": ["mileage"]
            }
        ]
    }
    long_trip = 7
  }

  rule process_trip {

      select when car new_trip
      pre{
          mileage = event:attr("mileage").as("Number")
          timestamp = time:now()
      }
      fired{
        raise explicit event "trip_processed"
          attributes {"mileage":mileage, "timestamp":timestamp}
      }
  }

  rule find_long_trips{
      select when explicit trip_processed
        pre {
            mileage = event:attr("mileage").as("Number")
            timestamp = time:now()
        }
        if(mileage >= long_trip) then
            noop()
            fired{
              raise explicit event "found_long_trip"
                attributes {"mileage":mileage, "timestamp":timestamp}
            }
  }
}
