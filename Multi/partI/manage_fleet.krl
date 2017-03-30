ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<
Fleet Manager
>>
    author "Calvin McMurray"
    logging on
    shares __testing
  }

  global {
    nameFromID = function(vehicle_id) {
      "Vehicle" + vehicle_id + " Pico"
    }
    __testing = {
        "queries": [
        ],
        "events": [
            {
                "domain": "car",
                "type": "new_vehicle",
                "attrs": ["vehicle_id"]
            }
        ]
    }
  }

  rule create_vehicle {
      select when car new_vehicle
      pre {
        vehicle_id = event:attr("vehicle_id")
        exists = ent:vehicles >< vehicle_id
        eci = meta:eci
      }
      if exists then
        send_directive("section_ready")
            with vehicle_id = vehicle_id
      fired {
      }
      else {
        raise pico event "new_child_request"
            attributes { "vehicle_id": vehicle_id, "dname": nameFromID(vehicle_id), "color": "#7383d5" }
      }
  }

  // Sets up a child pico with the Subscriptions, trip_store, and track_trips rulesets.
  rule pico_child_initialized {
      select when pico child_initialized
      pre {
        the_vehicle = event:attr("new_child")
        vehicle_id = event:attr("rs_attrs"){"vehicle_id"}.klog("Howdy, Y'all!")
      }
      event:send(
        { "eci": the_vehicle.eci, "eid": "install-ruleset",
          "domain": "pico", "type": "new_ruleset",
          "attrs": { "rid": "Subscriptions", "vehicle_id": vehicle_id } } )
      event:send(
        { "eci": the_vehicle.eci, "eid": "install-ruleset",
          "domain": "pico", "type": "new_ruleset",
          "attrs": { "rid": "trip_store", "vehicle_id": vehicle_id } } )
      event:send(
        { "eci": the_vehicle.eci, "eid": "install-ruleset",
          "domain": "pico", "type": "new_ruleset",
          "attrs": { "rid": "track_trips_II", "vehicle_id": vehicle_id } } )
      fired {
        ent:vehicles := ent:vehicles.defaultsTo([]).union([vehicle_id])
      }
  }
}
