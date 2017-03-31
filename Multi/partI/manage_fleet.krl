ruleset manage_fleet {
  meta {
    name "Manage Fleet"
    description <<
Fleet Manager
>>
    author "Calvin McMurray"
    logging on
    use module Subscriptions
    shares __testing, vehicles, gatherAllTrips
  }

  global {
    nameFromID = function(vehicle_id) {
      "Vehicle" + vehicle_id + " Pico"
    }

    vehicles = function(){
        ent:vehicle_map
    }

    vehicleFromID = function(vehicle_id) {
      ent:vehicle_map{vehicle_id}
    }

    subscriptionFromID = function(vehicle_id){
        "Subs" + vehicle_id + "-veh"
    }

    gatherAllTrips = function(){
        Subscriptions:getSubscriptions().filter(function(v){
            v{"attributes"}{"subscriber_role"} == "vehicle"
        }).map(function(s){
            r = http:get("http://localhost:8080/sky/cloud/" + s{"attributes"}{"subscriber_eci"} + "/trip_store/trips");
            r{"content"}.decode().klog("response:")
        })
    }

    __testing = {
        "queries": [
            {"name":"vehicles"},
            {"name":"gatherAllTrips"}
        ],
        "events": [
            {
                "domain": "car",
                "type": "new_vehicle",
                "attrs": ["vehicle_id"]
            },
            {
                "domain": "car",
                "type": "unneeded_vehicle",
                "attrs": ["vehicle_id"]
            },
            {
                "domain": "fleet",
                "type": "destroy_all_vehicles",
                "attrs": []
            },
            {
                "domain": "debug",
                "type": "kill_sub",
                "attrs": ["vehicle_id"]
            }
        ]
    }
  }

  rule create_vehicle {
      select when car new_vehicle
      pre {
        vehicle_id = event:attr("vehicle_id")
        exists = ent:vehicle_map >< vehicle_id
        eci = meta:eci
      }
      if exists then
        send_directive("vehicle already ready")
            with vehicle_id = vehicle_id
        fired{}
      else {
        raise pico event "new_child_request"
            attributes { "vehicle_id": vehicle_id, "dname": nameFromID(vehicle_id), "color": "#7383d5" }
      }
  }

  // Sets up a child pico with the Subscriptions, trip_store, and track_trips_II rulesets.
  rule pico_child_initialized {
      select when pico child_initialized
      pre {
        the_vehicle = event:attr("new_child")
        vehicle_id = event:attr("rs_attrs"){"vehicle_id"}.klog("Howdy, Y'all!")
        eci = meta:eci
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
      event:send(
        { "eci": eci, "eid": "subscription",
          "domain": "wrangler", "type": "subscription",
          "attrs": {
            "name": subscriptionFromID(vehicle_id),
            "name_space": "car",
            "my_role": "fleet",
            "subscriber_role": "vehicle",
            "channel_type": "subscription",
            "subscriber_eci": the_vehicle.eci
          }
        }
      )
      fired {
        ent:vehicle_map := ent:vehicle_map.defaultsTo({}).klog("Blarf:");
        ent:vehicle_map{vehicle_id} := the_vehicle.klog("Glogle:")
      }
  }

  rule kill_sub{
      select when debug kill_sub
      pre{
        vehicle_id = event:attr("vehicle_id")
      }
      fired {
          raise wrangler event "subscription_cancellation"
            with subscription_name = "car:" + subscriptionFromID(vehicle_id).klog("Killing Subscription:")
      }
  }

  rule delete_vehicle {
      select when car unneeded_vehicle
      pre{
          vehicle_id = event:attr("vehicle_id")
          exists = ent:vehicle_map >< vehicle_id
          eci = meta:eci
          vehicle_to_delete = vehicleFromID(vehicle_id)
      }
      if exists then
          send_directive("vehicle_deleted")
            with vehicle_id = vehicle_id
      fired {
          raise wrangler event "subscription_cancellation"
            with subscription_name = "car:" + subscriptionFromID(vehicle_id).klog("Killing Subscription:");
          raise pico event "delete_child_request"
            attributes vehicle_to_delete;
          ent:vehicle_map{[vehicle_id]} := null
      }
      else {
        send_directive("vehicle unknown")
          with vehicle_id = vehicle_id
      }
  }

  rule delete_all{
      select when fleet destroy_all_vehicles
      always{
        ent:vehicle_map := {}
      }
  }
}
