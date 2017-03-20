ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
I'd call it trip logic. But it's more like "trippy" logic...
>>
    author "Calvin McMurray"
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
          mileage = event:attr("mileage").klog("our passed in mileage: ")
      }
      send_directive("trip") with
        trip_length = mileage
  }

}
