var Client = require("sock-rpc-stats").Client,
  yargs = require("sock-rpc-stats/node_modules/yargs"),
  async = require("sock-rpc-stats/node_modules/async"),
  util = require("util");


var options = {
  host: {
    default: "localhost",
    describe: "IP address of the stats server to connect to"
  },
  port: {
    default: 1337,
    describe: "port number of the stats server to connect to"
  }
};

var ctx = {};

var processCommandLine = function(cb) {
  try {
    var argv = yargs
      .options(options)
      .help("help")
      .alias("help", "h")
      .argv;

    ctx.argv = argv;
    return cb(null);
  }
  catch(ex) {
    cb(ex);
  }
};

var connectToStatsServer = function(cb) {
  try {
    var client = new Client(ctx.argv);
    client.connect(function(err) {
      ctx.client = client;
      return cb(err);
    });
  }
  catch(ex) {
    cb(ex);
  }
};

var findMessageQueue = function(cb) {
  try {
    ctx.client.keys(function(err, result) {
      try {
        if (err) throw err;
        for(var i = 0; i < result.length; i++) {
          var key = result[i];
          if (key.match(/_Messages/)) {
            ctx.scope = key;
            return cb(null);
          }
        }
        throw new Error("Could not find a message queue on the stats server");
      }
      catch(ex) {
        cb(ex);
      }
    });
  }
  catch(ex) {
    cb(ex);
  }
};

var sendMessageToServer = function(cb) {
  try {
    var message = {
      id: new Date().getTime().toString(),
      from: "server-restart",
      to: "server",
      subject: "restart"
    };

    ctx.client.push(ctx.scope, "server.recv", message, function(err) {
      try {
        if (err) throw err;
        ctx.message = message;
        return cb(null);
      }
      catch(ex) {
        cb(ex);
      }
    });
  }
  catch(ex) {
    cb(ex);
  }
};

var waitForServerResponse = function(cb) {
  try {
    var delay = 10;
    var attempts = 0;
    var waitResponse = function(){
      attempts++;
      if (attempts > 6) {
        return cb(new Error(util.format("Did not receive response form server after %s contact attempts", attempts -1)));
      }

      var key = ctx.message.from + ".recv";
      console.log("Waiting for server response at %s.%s", ctx.scope, key);
      ctx.client.pop(ctx.scope, key, function(err, result) {
        if (err) {
          console.log("Remote error, will try again in %s seconds", delay);
          console.log(err);
          return setTimeout(waitResponse,delay*1000);
        }

        if (!result) {
          console.log("No response from server yet, will try again in %s seconds", delay);
          console.log(err);
          return setTimeout(waitResponse,delay*1000);
        }

        if (!result.id || result.id != ctx.message.id) {
          console.log("Protocol error, server sent invalid response: %s, will try again in %s seconds", JSON.stringify(result), delay);
          console.log(err);
          return setTimeout(waitResponse,delay*1000);
        }

        console.log("Server responded with: %s", JSON.stringify(result));
        return cb(null);
      });
    };

    waitResponse();
  }
  catch(ex) {
    cb(ex);
  }
};

var errorHandler = function(err) {
  if (err) {
    console.log(err);
  }

  if (ctx.client) {
    ctx.client.disconnect(function() {
      console.log("disconnected");
    });
  }
};

async.waterfall(
  [
    processCommandLine,
    connectToStatsServer,
    findMessageQueue,
    sendMessageToServer,
    waitForServerResponse
  ],
  errorHandler
);