#### Set REDIS_PASSWORD in Makefile
#### Require at least 3 machines for clustering redis
#### Make redis cluster mode node in each machine


> make build


> make require-redis-cluster-mode


#### And then, 
#### Create redis cluster(below is sample command for reference)


> docker run --rm --detach --name redis-cluster --network host redis redis-cli -a "password" --cluster create ip1:6379 ip12:6379 ip13:6379 --cluster-replicas 0
