module.exports = {
  "rid": "track_trips",
  "meta": {
    "name": "Track Trips",
    "description": "\nA first ruleset for the Quickstart\n",
    "author": "Phil Windley",
    "logging": true,
    "shares": [
      "hello",
      "__testing"
    ]
  },
  "global": function* (ctx) {
    ctx.scope.set("__testing", {
      "queries": [
        {
          "name": "hello",
          "args": ["obj"]
        },
        { "name": "__testing" }
      ],
      "events": [{
          "domain": "echo",
          "type": "hello",
          "attrs": ["name"]
        }]
    });
  },
  "rules": {
    "process_trip": {
      "name": "process_trip",
      "select": {
        "graph": { "echo": { "message": { "expr_0": true } } },
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
        ctx.scope.set("milage", yield ctx.callKRLstdlib("klog", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["milage"]), "our passed in mileage: "));
      },
      "action_block": {
        "actions": [{
            "action": function* (ctx) {
              return {
                "type": "directive",
                "name": "trip",
                "options": { "trip_length": ctx.scope.get("milage") }
              };
            }
          }]
      }
    }
  }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZXNDb250ZW50IjpbXX0=
