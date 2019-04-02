FROM mongo:latest

LABEL name='mongo' tag='nfs' maintainer='RockYuan <RockYuan@gmail>'

# 必须安装指定包
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    nfs-common \
  ;\
  rm -rf /var/lib/apt/lists/*

# 通过ONBUILD文件可定制安装需要的包和依赖包,txt文件每行一个包名
ONBUILD ADD ./mongo-onbuild/*.txt /var/lib/apt/
ONBUILD RUN cd /var/lib/apt; \
  [ -f packages.txt -o -f dependencies.txt ] && apt-get update; \
  [ -f dependencies.txt ] && xargs -r apt-get install -y --no-install-recommends < dependencies.txt; \
  [ -f packages.txt ] && xargs -r apt-get install -y --no-install-recommends < packages.txt; \
  [ -f dependencies.txt ] && xargs -r apt-get purge -y --auto-remove wget < dependencies.txt; \
  [ -f packages.txt -o -f dependencies.txt ] && rm -rf /var/lib/apt/lists/*
