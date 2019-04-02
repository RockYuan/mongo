FROM mongo:latest

LABEL name='mongo' tag='nfs' maintainer='RockYuan <RockYuan@gmail>'

# 必须安装指定包
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    nfs-common \
  ;\
  rm -rf /var/lib/apt/lists/*

# 通过ONBUILD文件可定制安装需要的包和依赖包,mongonfs文件每行一个包名
ONBUILD ADD ./*.mongonfs /var/lib/apt/
ONBUILD RUN cd /var/lib/apt; \
  [ -f packages.mongonfs -o -f dependencies.mongonfs ] && apt-get update; \
  [ -f dependencies.mongonfs ] && xargs -r apt-get install -y --no-install-recommends < dependencies.mongonfs; \
  [ -f packages.mongonfs ] && xargs -r apt-get install -y --no-install-recommends < packages.mongonfs; \
  [ -f dependencies.mongonfs ] && xargs -r apt-get purge -y --auto-remove wget < dependencies.mongonfs; \
  [ -f packages.mongonfs -o -f dependencies.mongonfs ] && rm -rf /var/lib/apt/lists/*
