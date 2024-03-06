**note:** run the setup.sh file in the current os.

**setup docker-swarm:** <br/>
          - ` docker swarm init `   ----> to initialize the swarm and collect the join tokens there, <br/>
          - run the `bash setup.sh` in the swam slave nodes.<br/>
          - add the slave nodes 3 or more to SPOF(single point of failure) and fault tolerance.<br/>
      
**setup mongo-cluster (shard):** <br/>
**step1:** <br/>
            configure the os/containers by using the above docker-compose files individually for the shards and **meta**servers.
      launch all the nodes inside the docker service by using: <br/>
       ` docker stack deploy --compose-file matasvr/meta_config.yml meta_server_stack ` <br/>
      <br/><br/>
**step2:** <br/>
            create the router os which is responsible to connect all the shards and meta servers , launch it by using the mongo_router.yml file by 
      edit the ip's in the file with the current IP's of the **meta**servers.by this , router knows the meta servers to manage the data by using shard1 and shard2.
      <br/>
      launch all the nodes inside the docker service by using:<br/>
      ` docker stack deploy --compose-file shard1/shard1_cinfig.yml  shard1 ` <br/>      
      ` docker stack deploy --compose-file shard2/shard2_cinfig.yml  shard1 ` <br/>
    <br/><br/>
**step3:** <br/>
           now, login to the router node(mongos). which is the node knows about the all meta servers. so now feed the info of the shard severs from this node to the meta servers.
      as follows: <br/>
      **note:** replace the IP's with the shard nodes IP's.<br/>
      to add shard1: ` sh.addShard("shard1repset/172.13.1.3:50001,172.13.1.4:50002,172.13.1.5:50003") ` <br/>
      to add shard2: ` sh.addShard("shard2repset/172.35.2.6:50004,172.35.2.7:50005,172.35.2.8:50006") ` <br/><br/>
      **enable sharding for DB:** <br/>
      ` sh.enableSharding("db2024") `<br/>
      ` sh.shardCollection("db2024.collection",{"age":"hashed"}) ` ----> enable which collection has to be split based on the KEY of the document.
      
