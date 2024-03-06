yum install docker -y 
systemctl start docker.service
systemctl enable docker.service


sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo -e "[mongodb-org-6.0] \nname=MongoDB Repository \nbaseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/ \ngpgcheck=1 \nenabled=1 \ngpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc \n" > /etc/yum.repos.d/mongodb-org-6.0.repo

yum install mongodb-org -y
systemctl start mongod
systemctl enable mongod



echo "      ==============================>   RUN THE FOLLOWING COMMANDS    <==============================="
echo "    1) docker swarm init ----> to get the tokens \n"
echo "    2) using tokens join the slave nodes to the master node \n"
echo "    3) docker  stack deploy --compose-file docker-compose_file_name.yml metasrv1 \n"

