ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares message, __testing
  }

  global {
    __testing = {
        "queries": [],
        "events": [
            {
                "domain": "echo",
                "type": "message",
                "attrs": ["name"]
            }
        ]
    }
  }

  rule process_trip {
      select when echo message
      pre {
          milage = event:attr("milage").klog("our passed in mileage: ")
      }
      send_directive("trip") with
        trip_length = milage
  }

}
