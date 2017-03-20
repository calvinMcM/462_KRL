module.exports = {
  "rid": "track_trips_II",
  "meta": {
    "name": "Track Trips II",
    "description": "\nPart II Ruleset for Pico I lab BYU CS 462\n",
    "author": "Calvin McMurray",
    "logging": true,
    "shares": [
      "new_trip",
      "__testing"
    ]
  },
  "global": function* (ctx) {
    ctx.scope.set("__testing", {
      "queries": [],
      "events": [{
          "domain": "car",
          "type": "new_trip",
          "attrs": ["name"]
        }]
    });
    ctx.scope.set("long_trip", 7);
  },
  "rules": {
    "process_trip": {
      "name": "process_trip",
      "select": {
        "graph": { "car": { "new_trip": { "expr_0": true } } },
        "eventexprs": {
          "expr_0": function* (ctx) {
            return true;
          }
        },
        "state_machine": {
          "start": [[
              "expr_0",
              "end"
            ]]
        }
      },
      "prelude": function* (ctx) {
        ctx.scope.set("mileage", yield ctx.callKRLstdlib("as", yield ctx.callKRLstdlib("klog", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["mileage"]), "our passed in mileage: "), "Number"));
        ctx.scope.set("timestamp", yield (yield ctx.modules.get(ctx, "time", "now"))(ctx, []));
      },
      "postlude": {
        "fired": function* (ctx) {
          yield (yield ctx.modules.get(ctx, "event", "raise"))(ctx, [{
              "domain": "explicit",
              "type": "trip_processed",
              "for_rid": undefined,
              "attributes": {
                "mileage": ctx.scope.get("mileage"),
                "timestamp": ctx.scope.get("timestamp")
              }
            }]);
        },
        "notfired": undefined,
        "always": undefined
      }
    },
    "find_long_trips": {
      "name": "find_long_trips",
      "select": {
        "graph": { "explicit": { "trip_processed": { "expr_0": true } } },
        "eventexprs": {
          "expr_0": function* (ctx) {
            return true;
          }
        },
        "state_machine": {
          "start": [[
              "expr_0",
              "end"
            ]]
        }
      },
      "prelude": function* (ctx) {
        ctx.scope.set("mileage", yield ctx.callKRLstdlib("as", yield ctx.callKRLstdlib("klog", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["mileage"]), "our passed in mileage: "), "Number"));
        ctx.scope.set("timestamp", yield (yield ctx.modules.get(ctx, "time", "now"))(ctx, []));
      },
      "action_block": {
        "condition": function* (ctx) {
          return yield ctx.callKRLstdlib(">", ctx.scope.get("mileage"), ctx.scope.get("long_trip"));
        },
        "actions": [{
            "action": function* (ctx) {
              return void 0;
            }
          }]
      },
      "postlude": {
        "fired": function* (ctx) {
          yield (yield ctx.modules.get(ctx, "event", "raise"))(ctx, [{
              "domain": "explicit",
              "type": "found_long_trip",
              "for_rid": undefined,
              "attributes": {
                "mileage": ctx.scope.get("mileage"),
                "timestamp": ctx.scope.get("timestamp")
              }
            }]);
        },
        "notfired": undefined,
        "always": undefined
      }
    }
  }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZXNDb250ZW50IjpbXX0=
