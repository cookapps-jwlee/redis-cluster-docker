REDIS_CLUSTER_NODE_RUNTIME_TAG='chirichidi/redis-cluster-node'
REDIS_HOST=$(shell dig +short myip.opendns.com @resolver1.opendns.com)
MY_IP=${shell ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d/ -f 1}
REDIS_PASSWORD='PLEASE INPUT'
REDIS_PORT=6379

update: \
	update-code-only 
	build

update-code-only: 
	git reset --hard
	git pull

build: \
	require-redis-cluster-node-build


require-redis-cluster-node-build:
	docker build \
	--tag ${REDIS_CLUSTER_NODE_RUNTIME_TAG} \
	./

require-redis: 
	docker run \
	--rm \
	--detach \
	--name redis \
	--publish 6379:6379 \
	redis

require-redis-cluster-mode:
	docker run \
	--rm -d \
	--name redis-${shell hostname} \
	--network host \
	-v /data/log/redis:/data/log/redis \
	-v /data/lib/redis:/data/lib/redis \
	${REDIS_CLUSTER_NODE_RUNTIME_TAG} \
	redis-server \
	--dir /data/lib/redis \
	--loglevel notice \
	--cluster-enabled yes \
	--cluster-config-file /data/log/redis/nodes-${shell hostname}.conf \
	--cluster-node-timeout 3000 \
	--appendonly yes \
	--requirepass ${REDIS_PASSWORD} \
	--slowlog-log-slower-than 10000 \
	--protected-mode no \
	--bind "* -::*" \
	--maxmemory 4gb \
	--maxmemory-policy noeviction \
	--cluster-announce-ip ${REDIS_HOST}

benchmark:
	docker exec -t --rm ${REDIS_CLUSTER_NODE_RUNTIME_TAG} redis-benchmark -a ${REDIS_PASSWORD} -h ${REDIS_HOST} -p ${REDIS_PORT}


## 클러스터 모드 레디스 접속 예시
# docker run --rm -it redis redis-cli -c -h ip -p port -a "password"


## 레디스 클러스터 생성 예시
# docker run --rm --detach --name redis-cluster --network host redis redis-cli -a "password" --cluster create ip1:6379 ip12:6379 ip13:6379 --cluster-replicas 0

## 클러스터 노드 확인
# docker run --rm -it redis redis-cli -c -h ip -p 6379 -a "password"
# CLUSTER NODES
## 생성된 클러스터 아이피, 포트 잘 확인할 것


# cluster monitoring (https://github.com/junegunn/redis-stat)
# docker run --name redis-stat -p 63790:63790 -d insready/redis-stat -a "password" --server ip1:6379  ip12:6379 ip3:6379
# http://localhost:63790
