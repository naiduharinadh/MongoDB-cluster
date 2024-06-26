**note:** run the setup.sh file in the current os.

**setup docker-swarm:** <br/>
          - ` docker swarm init `   ----> to initialize the swarm and collect the join tokens there, <br/>
          - run the `bash setup.sh` in the swam slave nodes.<br/>
          - add the slave nodes 3 or more to SPOF(single point of failure) and fault tolerance.<br/>
      
**setup mongo-cluster (shard):** <br/>
**mandatory:**
   
**step1:** <br/>
            configure the os/containers by using the above docker-compose files individually for the shards and **meta**servers.
      launch all the nodes inside the docker service by using: <br/>
       ` docker stack deploy --compose-file matasvr/meta_config.yml meta_server_stack ` <br/>
       to set theese nodes as the meata servers:<br />
     `  rs.initiate({ _id:"cnfgr" , configsvr: true , members:[ {_id:1,host:"IP address of shard1Node1:40001},{_id:1,host:"IP address of shard1Node2:40002},{_id:1,host:"IP address of shard1Node3:40003}] `
      <br/><br/>
**step2:** <br/>
            create the router os which is responsible to connect all the shards and meta servers , launch it by using the mongo_router.yml file by 
      edit the ip's in the file with the current IP's of the **meta**servers.by this , router knows the meta servers to manage the data by using shard1 and shard2.
      <br/>
      launch all the nodes inside the docker service by using:<br/>
      ` docker stack deploy --compose-file shard1/shard1_cinfig.yml  shard1 ` <br/>      
      ` docker stack deploy --compose-file shard2/shard2_cinfig.yml  shard1 ` <br/>
      - we need to elect one system as the primary node in the shards. so, log into one of shard1  node and run <br />
   ` rs.initiate({ _id:"cnfgr" , configsvr: false , members:[ {_id:1,host:"IP address of shard1Node1:40001},{_id:1,host:"IP address of shard1Node2:40002},{_id:1,host:"IP address of shard1Node3:40003}] `
similarly for the shard2 also, <br />
` rs.initiate({ _id:"cnfgr" , configsvr: false , members:[ {_id:1,host:"IP address of shard2Node1:40004},{_id:1,host:"IP address of shard2Node2:40005},{_id:1,host:"IP address of shard2Node3:40006}] `
    <br/><br/>
**step3:** <br/>
           now, login to the router node(mongos). which is the node knows about the all meta servers. so now feed the info of the shard severs from this node to the meta servers.
      as follows: <br/>
      **note:** replace the IP's with the shard nodes IP's.<br/>
      Provide Info to the MetasSRV by following commands: <br />
      to add shard1:  ### ``` sh.addShard("shard1repset/172.13.1.3:50001,172.13.1.4:50002,172.13.1.5:50003") 
      to add shard2: ` sh.addShard("shard2repset/172.35.2.6:50004,172.35.2.7:50005,172.35.2.8:50006") ` <br/><br/>

    
 **enable sharding for DB:** 
      
      ` sh.enableSharding("db2024") `
      ` sh.shardCollection("db2024.collection",{"age":"hashed"}) ` 
      
      ----> enable which collection has to be split based on the KEY of the document.
      
**to get the actual power of the docker swarm :** <br/>
mix all the docker-comppose files inside one file and launch them in the same overlay network to communicate easily between the contaienrs.
this will gives you the seem less experience, no downtime and no point of failure. 
