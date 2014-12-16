###Wasteland.Altis (Sock-RPC-Stats fork) ###

This is a fork of the Wasteland mission with persistence support using the [sock-rpc-stats Node.js module](https://www.npmjs.org/package/sock-rpc-stats), and the [sock.dll / sock.so](https://bitbucket.org/micovery/sock.dll) Arma 3 extension.

The main mission itself is maintained by "Team Wasteland".

### PBOs ###

If you are looking for the prebuilt PBO files head over to the [Release Files](https://github.com/micovery/ArmA3_Wasteland.Altis/releases/). 

###Demo video tutorial (dedicated server)###


[![Demo Video](http://img.youtube.com/vi/-NIziTcKwok/0.jpg)](http://www.youtube.com/watch?v=-NIziTcKwok)

### Prerequisites ###
  * Download and install [Node.js](http://nodejs.org/download/)
  * Install Arma 3 dedicated server by following [these instructions](https://community.bistudio.com/wiki/Arma_3_Dedicated_Server) from the BIS Wiki
  

###Linux Setup Instructions (dedicated server)###

0. Install the stats server packages using npm
<pre>npm install -g sock-rpc-stats</pre>
0. Start the Stats server (example below using file system storage)
<pre>sock-rpc-stats --url=file://./stats --repl</pre>
0. Open a new terminal, and switch to the Arma 3 server directory
<pre>cd ~/steamcmd/arma3</pre>
0. Download and unzip the Wasteland saving pack  
<pre>wget https://github.com/micovery/ArmA3_Wasteland.Altis/releases/download/v0.0.1/A3W_Saving_Pack-sock_v0.0.1.zip</pre>
<pre>unzip A3W_Saving_Pack-sock_v0.0.1.zip</pre>
0. Download misison file, and put it in the mpmissions directory
<pre>wget https://github.com/micovery/ArmA3_Wasteland.Altis/releases/download/v0.0.1/ArmA3_Wasteland_v0.9h-sock_v0.0.1.Altis.pbo</pre>
<pre>mv ArmA3_Wasteland_v0.9h-sock_v0.0.1.Altis.pbo mpmissions/</pre>
0. Modify your server config file to reference the Wasteland mission
<pre>
  //excerpt from server.cfg
  class Missions {
    class Test {
      template="ArmA3_Wasteland_v0.9h-sock_v0.0.1.Altis";
      difficulty="regular";
    };
  };
</pre>
0. Start the Arma 3 server
<pre>./arma3server -sock_host=127.0.0.1 -sock_port=1337 -profiles=server -config=server/server.cfg -cfg=server/arma3.cfg -port=2302</pre>


###Help###


For defects related to the mission please visit their [forums](http://forums.a3wasteland.com/), or submit issues directly to their [github repository](https://github.com/A3Wasteland/ArmA3_Wasteland.Altis/issues)

For defects related to persistence, use the [issue tracker](https://github.com/micovery/ArmA3_Wasteland.Altis/issues) in this repository.



### *Team Wasteland* ###

       GoT - JoSchaap
       TPG - AgentRev
           - MercyfulFate
       KoS - His_Shadow
       KoS - Bewilderbeest
       404 - Del1te

           

