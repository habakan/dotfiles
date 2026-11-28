FROM alpine:3.22

# git/bash はエージェントがシェルで使う最低限。agy は ripgrep を同梱している
RUN apk add --no-cache bash curl git ca-certificates openssh-client \
 && adduser -D -s /bin/bash agy

# root 所有の場所に置き、毎回の --rm コンテナで自己更新 (約230MB) が走らないようにする。更新はイメージ再ビルドで
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /usr/local/bin \
 && rm -rf /root/.cache /root/.gemini

COPY entrypoint.sh /usr/local/bin/agy-entrypoint
RUN chmod +x /usr/local/bin/agy-entrypoint

USER agy
# 先に作っておかないと、新しい named volume が root 所有でマウントされる
RUN mkdir -p /home/agy/.gemini
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/agy-entrypoint"]
