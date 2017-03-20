ruleset track_trips {
  meta {
    name "Track Trips"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello, __testing
  }

  global {
    __testing = {
        "queries": [
            {
                "name": "hello",
                "args": [ "obj" ]
            },
            { "name": "__testing" }
        ],
        "events": [
            {
                "domain": "echo",
                "type": "hello",
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
