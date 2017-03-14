module.exports = {
  "rid": "hello_world",
  "meta": {
    "name": "Hello World",
    "description": "\nA first ruleset for the Quickstart\n",
    "author": "Phil Windley",
    "logging": true,
    "shares": ["hello"]
  },
  "global": function* (ctx) {
    ctx.scope.set("hello", ctx.KRLClosure(ctx, function* (ctx) {
      ctx.scope.set("obj", ctx.getArg(ctx.args, "obj", 0));
      ctx.scope.set("msg", yield ctx.callKRLstdlib("+", "Hello ", ctx.scope.get("obj")));
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
          "type": "hello"
        }]
    });
  },
  "rules": {
    "hello_world": {
      "name": "hello_world",
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
    }
  }
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZXNDb250ZW50IjpbXX0=
