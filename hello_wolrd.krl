ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello, __testing
  }

  global {
    message = function(obj) {
      msg = "message " + obj;
      msg
    }

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

  rule hello_world {
      select when echo hello
      pre {
          name = event:attr("name").klog("our passed in name: ")
      }
      send_directive("say") with
        something = "Hello " + name
  }

  rule message{
    select when echo message
    pre {
        input = event:attr("input")
    }
    send_directive("say") with
        something = input
  }

}
