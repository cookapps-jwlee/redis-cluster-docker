FROM redis

RUN mkdir -p /data/conf/redis /data/lib/redis /data/log/redis

COPY redis.conf /data/conf/redis/redis.conf

CMD [ "redis-server", "/data/conf/redis/redis.conf" ]
