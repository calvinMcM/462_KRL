ruleset hello_world {
  meta {
    name "Hello World"
    description <<
This is a mess
>>
    author "Calvin McMurray"
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
        something = "Hello World"
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
