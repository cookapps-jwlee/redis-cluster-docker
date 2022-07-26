REDIS_CLUSTER_NODE_RUNTIME_TAG='chirichidi/redis-cluster-node'

update: 
	update-code-only
	build


update-code-only: 
	git reset --hard
	git pull


build: \
	require-redis-cluster-node-build

# redis.conf 에 requirepass 수정할것
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
	docker run --rm \
	--name redis-${shell hostname} \
	--network host \
	-v /data/log/redis:/data/log/redis \
	-v /data/lib/redis:/data/lib/redis \
	${REDIS_CLUSTER_NODE_RUNTIME_TAG} \
	redis-server /data/conf/redis/redis.conf


# 클러스터 모드 레디스 접속 예시
# docker run --rm -it redis redis-cli -c -h ip -p port -a "password"


# 레디스 클러스터 생성 예시
# docker run --rm --detach --name redis-cluster --network host redis redis-cli -a "password" --cluster create ip1:6379 ip12:6379 ip13:6379 --cluster-replicas 0

# 클러스터 노드 확인
# docker run --rm -it redis redis-cli -c -h ip -p 6379 -a "password"
# CLUSTER NODES

## 생성된 클러스터 아이피, 포트 잘 확인할 것
# 1f391450b82742e473a906e624759d2ae8385815 10.1.0.6:6379@16379 myself,master - 0 1658751639000 1 connected 0-5460
# 5d83da10e13fc72ba475199f64e728209a2ad11f 3.39.14.49:6379@16379 master - 0 1658751640408 3 connected 10923-16383
# 8251048e7895b1b3089030e3b57f3c84665e19b3 3.37.59.157:6379@16379 master - 0 1658751640000 2 connected 5461-10922

# cluster monitoring (https://github.com/junegunn/redis-stat)
# docker run --name redis-stat -p 63790:63790 -d insready/redis-stat -a "password" --server ip1:6379  ip12:6379 ip3:6379
# http://localhost:63790
