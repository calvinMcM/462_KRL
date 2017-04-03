ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
Part III Ruleset for Pico I lab BYU CS 462
>>
    author "Calvin McMurray"
    logging on
    shares trips, long_trips, short_trips, __testing
    provides trips, long_trips, short_trips
  }

  global {
    long_trip = 7
    __testing = {
        "queries": [
            {"name":"trips"},
            {"name":"long_trips"},
            {"name":"short_trips"}],
        "events": [
            {
                "domain": "explicit",
                "type": "trip_processed",
                "attrs": ["mileage", "timestamp"]
            },
            {
                "domain": "explicit",
                "type": "found_long_trip",
                "attrs": ["mileage", "timestamp"]
            },
            {
                "domain": "car",
                "type": "trip_reset",
                "attrs": []
            }
        ]
    }
    trips = function(){
        ent:coll.klog("Known trips:")
    }
    long_trips = function(){
        ent:coll_long.klog("Known long trips:")
    }
    short_trips = function(){
        ent:coll.filter(function(a){ a{"mileage"} < 7 })
    }
  }

  rule collect_trip {
      select when explicit trip_processed
        pre{
            mileage = event:attr("mileage").klog("our passed in (standard) mileage: ")
            timestamp = event:attr("timestamp")
        }
        always{
            ent:coll := ent:coll.append({"mileage":mileage,"timestamp":timestamp})
        }
  }

  rule collect_long_trip {
    select when explicit found_long_trip
      pre{
        mileage = event:attr("mileage").klog("our passed in (long) mileage: ")
        timestamp = event:attr("timestamp")
      }
      always{
        ent:coll_long := ent:coll_long.append({"mileage":mileage,"timestamp":timestamp})
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

  rule make_fleet_report {
      select when car make_fleet_report
        pre{
            events = event:attrs.klog("_EVENT ATTRIBUTES:")
            rcn = event:attr("rcn").klog("Vehicle recieved directive with rcn:")
            target_eci = event:attr("sender_eci").klog("Vehicle will reply to:")
            trips_log = trips() || []
        }

        event:send(
          { "eci": target_eci, "eid": "deliver_report",
            "domain": "fleet", "type": "deliver_report",
            "attrs": { "rcn": rcn, "log": trips_log } } )

  }
}
