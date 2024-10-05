# Author：Akira <e.akimoto.akira@gmail.com>
# Modify：sudojia
FROM alpine:3.12

LABEL AUTHOR="sudojia" \
        VERSION=1.0.0

# 设置工作目录为/AutoTaskScript
WORKDIR /AutoTaskScript

# 设置环境变量，用于配置默认的定时文件、合并类型和脚本仓库地址
ENV DEFAULT_LIST_FILE=crontab_list.sh \
        CUSTOM_LIST_MERGE_TYPE=append \
        REPO_URL=https://github.com/sudojia/AutoTaskScript

# 更新并升级系统包，安装必要的软件包
RUN set -ex \
        && apk update && apk upgrade\
        && apk add --no-cache tzdata  git  nodejs  moreutils  npm curl jq \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

# 克隆仓库代码，安装依赖，创建日志目录结构
RUN git clone ${REPO_URL} . \
    && npm install \
    && mkdir -p src/logs/client src/logs/other src/logs/public src/logs/web src/logs/wx_mini

# 将入口点脚本复制到可执行路径，并赋予执行权限
RUN cp /AutoTaskScript/docker/docker_entrypoint.sh /usr/local/bin \
        && chmod +x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["docker_entrypoint.sh"]

# 容器启动时，默认执行crond服务
CMD [ "crond" ]
