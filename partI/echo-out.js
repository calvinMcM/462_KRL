module.exports = {
  "rid": "echo",
  "meta": {
    "name": "Echo",
    "description": "\nThis is a mess\n",
    "author": "Calvin McMurray",
    "logging": true,
    "shares": [
      "hello",
      "message",
      "__testing"
    ]
  },
  "global": function* (ctx) {
    ctx.scope.set("message", ctx.KRLClosure(ctx, function* (ctx) {
      ctx.scope.set("obj", ctx.getArg(ctx.args, "obj", 0));
      ctx.scope.set("msg", yield ctx.callKRLstdlib("+", "message ", ctx.scope.get("obj")));
      return ctx.scope.get("msg");
    }));
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
    "hello": {
      "name": "hello",
      "select": {
        "graph": { "echo": { "hello": { "expr_0": true } } },
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
        ctx.scope.set("name", yield ctx.callKRLstdlib("klog", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["name"]), "our passed in name: "));
      },
      "action_block": {
        "actions": [{
            "action": function* (ctx) {
              return {
                "type": "directive",
                "name": "say",
                "options": { "something": "Hello World" }
              };
            }
          }]
      }
    },
    "message": {
      "name": "message",
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
        ctx.scope.set("input", yield (yield ctx.modules.get(ctx, "event", "attr"))(ctx, ["input"]));
      },
      "action_block": {
        "actions": [{
            "action": function* (ctx) {
              return {
                "type": "directive",
                "name": "say",
                "options": { "something": ctx.scope.get("input") }
              };
            }
          }]
      }
    }
  }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZXNDb250ZW50IjpbXX0=
