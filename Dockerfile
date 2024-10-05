# Base：Akira <e.akimoto.akira@gmail.com>
# Modify：sudojia
FROM alpine:3.12

WORKDIR /AutoTaskScript

LABEL AUTHOR="sudojia" \
        VERSION=1.0.0

ENV DEFAULT_LIST_FILE=crontab_list.sh \
        CUSTOM_LIST_MERGE_TYPE=append \
        REPO_URL=https://github.com/sudojia/AutoTaskScript

RUN set -ex \
        && apk update && apk upgrade\
        && apk add --no-cache tzdata  git  nodejs  moreutils  npm curl jq \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

RUN git clone ${REPO_URL} . \
        && npm install \
        && mkdir -p src/logs \
        && for dir in client other public web wx_mini; do mkdir -p src/logs/$dir; done

RUN cp /AutoTaskScript/docker/docker_entrypoint.sh /usr/local/bin \
        && chmod +x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["docker_entrypoint.sh"]

CMD [ "crond" ]
