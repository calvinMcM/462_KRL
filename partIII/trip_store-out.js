module.exports = {
  "rid": "trip_store",
  "meta": {
    "name": "Trip Store",
    "description": "\nPart III Ruleset for Pico I lab BYU CS 462\n",
    "author": "Calvin McMurray",
    "logging": true,
    "shares": [
      "trips",
      "long_trips",
      "short_trips"
    ],
    "provides": [
      "trips",
      "long_trips",
      "short_trips"
    ]
  },
  "global": function* (ctx) {
    ctx.scope.set("long_trips", 7);
    ctx.scope.set("trips", ctx.KRLClosure(ctx, function* (ctx) {
      return yield ctx.modules.get(ctx, "ent", "coll");
    }));
    ctx.scope.set("long_trips", ctx.KRLClosure(ctx, function* (ctx) {
      return yield ctx.modules.get(ctx, "ent", "coll_long");
    }));
    ctx.scope.set("short_trips", ctx.KRLClosure(ctx, function* (ctx) {
      return yield ctx.callKRLstdlib("filter", yield ctx.modules.get(ctx, "ent", "coll"), ctx.KRLClosure(ctx, function* (ctx) {
        ctx.scope.set("a", ctx.getArg(ctx.args, "a", 0));
        return yield ctx.callKRLstdlib("<", yield ctx.callKRLstdlib("get", ctx.scope.get("a"), "mileage"), ctx.scope.get("long_trips"));
      }));
    }));
  },
  "rules": {
    "collect_trip": {
      "name": "collect_trip",
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
        ctx.scope.set("mileage", yield ctx.callKRLstdlib("klog", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["milage"]), "our passed in mileage: "));
        ctx.scope.set("timestamp", yield (yield ctx.modules.get(ctx, "time", "now"))(ctx, []));
      },
      "postlude": {
        "fired": undefined,
        "notfired": undefined,
        "always": function* (ctx) {
          yield ctx.callKRLstdlib("append", yield ctx.modules.get(ctx, "ent", "coll"), {
            "mileage": ctx.scope.get("mileage"),
            "time": ctx.scope.get("timestamp")
          });
        }
      }
    },
    "collect_long_trip": {
      "name": "collect_long_trip",
      "select": {
        "graph": { "explicit": { "found_long_trip": { "expr_0": true } } },
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
        ctx.scope.set("mileage", yield ctx.callKRLstdlib("klog", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["milage"]), "our passed in mileage: "));
        ctx.scope.set("timestamp", yield (yield ctx.modules.get(ctx, "time", "now"))(ctx, []));
      },
      "postlude": {
        "fired": undefined,
        "notfired": undefined,
        "always": function* (ctx) {
          yield ctx.callKRLstdlib("append", yield ctx.modules.get(ctx, "ent", "coll_long"), {
            "mileage": ctx.scope.get("mileage"),
            "time": ctx.scope.get("timestamp")
          });
        }
      }
    },
    "clear_trips": {
      "name": "clear_trips",
      "select": {
        "graph": { "car": { "trip_reset": { "expr_0": true } } },
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
        ctx.scope.set("empty", []);
      },
      "postlude": {
        "fired": undefined,
        "notfired": undefined,
        "always": function* (ctx) {
          yield ctx.modules.set(ctx, "ent", "coll", ctx.scope.get("empty"));
          yield ctx.modules.set(ctx, "ent", "coll_long", ctx.scope.get("empty"));
        }
      }
    }
  }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZXNDb250ZW50IjpbXX0=
