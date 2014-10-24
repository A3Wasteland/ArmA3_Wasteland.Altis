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
  },
  wait: {
    default: 120,
    describe: "Maximum number of seconds to wait for server response"
  },
  name: {
    default: "A3W",
    describe: "Prefix name of the server to communicate with"
  }
};

var id = new Date().getTime().toString();
var ctx = {
  msg: {
    id: id,
    from: id,
    to: "server",
    subject: "restart"
  }
};

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
      console.log("connected");
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
          if (key.match(new RegExp(ctx.argv.name + "_Messages$"))) {
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

var flushReceiveQueue = function(cb) {
  try {
    ctx.send = ctx.msg.to + ".recv";
    ctx.recv = ctx.msg.from + ".recv";
    console.log("scope=%s, send=%s, recv=%s", JSON.stringify(ctx.scope), JSON.stringify(ctx.send),JSON.stringify(ctx.recv));
    ctx.client.set(ctx.scope, ctx.send, [], function(err) {
      try {
        if (err) throw err;
        cb(null);
      }
      catch(ex) {
        cb(ex);
      }
    });
  }
  catch(ex) {
    cb(ex);
  };
};

var sendMessageToServer = function(cb) {
  try {
    ctx.client.push(ctx.scope, ctx.send, ctx.msg, function(err) {
      try {
        if (err) throw err;
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
    var maxAttempts = Math.ceil(ctx.argv.wait / delay);
    var waitResponse = function(){
      attempts++;
      if (attempts > maxAttempts) {
        attempts--;
        return cb(new Error(util.format("attempt(%s/%s): no response form server, giving up",attempts, maxAttempts, attempts)));
      }


      ctx.client.pop(ctx.scope, ctx.recv, function(err, result) {
        if (err) {
          console.log("attempt(%s/%s): remote error, will try again in %s seconds", attempts, maxAttempts, delay);
          console.log(err);
          return setTimeout(waitResponse,delay*1000);
        }

        if (!result) {
          console.log("attempt(%s/%s): no response from server, will try again in %s seconds", attempts, maxAttempts, delay);
          return setTimeout(waitResponse,delay*1000);
        }

        if (!result.id || result.id != ctx.msg.id) {
          console.log("attempt(%s/%s): protocol error, invalid response from server: %s, will try again in %s seconds", attempts, maxAttempts, JSON.stringify(result), delay);
          console.log(err);
          return setTimeout(waitResponse,delay*1000);
        }

        console.log("attempt(%s/%s): server response: %s", attempts, maxAttempts, JSON.stringify(result));
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
    flushReceiveQueue,
    sendMessageToServer,
    waitForServerResponse
  ],
  errorHandler
);