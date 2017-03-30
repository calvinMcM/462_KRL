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
        exists = ent:sections >< vehicle_id
        eci = meta:eci
      }
      if exists then
        send_directive("section_ready")
            with vehicle_id = vehicle_id
      fired {
      }
      else {
        ent:sections := ent:sections.defaultsTo([]).union([vehicle_id]);
        raise pico event "new_child_request"
            attributes { "dname": nameFromID(vehicle_id), "color": "#FF69B4" }
      }
  }
}
