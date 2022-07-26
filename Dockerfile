FROM redis

RUN mkdir -p /data/conf/redis /data/log/redis /redis/data /redis/log

COPY redis.conf /data/conf/redis/redis.conf

CMD [ "redis-server", "/data/conf/redis/redis.conf" ]