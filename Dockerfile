FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/bugmenot081/docker-vps"

ENV TZ=Asia/Kuala_Lumpur \
    SSH_USER=ubuntu \
    SSH_PASSWORD=ubuntu!8080

COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot
COPY workspace /opt/workspace/

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y \
        tzdata openssh-server sudo curl ca-certificates wget vim net-tools supervisor cron unzip iputils-ping telnet git iproute2 \
        exiftool ffmpeg jq nano rclone tmux \
        --no-install-recommends; \
# Custom :: butterbash
    mkdir -p /opt/gitrepo_butterbash; \
    apt-get install -y bc exa fzf ripgrep --no-install-recommends; \
    git clone https://github.com/drewgrif/butterbash.git /opt/gitrepo_butterbash; \
    find /opt/workspace -name "*.bash" -print0 | xargs -0 cp -t /opt/gitrepo_butterbash/bash/functions/ \
#    cp /opt/workspace/tmux/tmux-util.bash /opt/gitrepo_butterbash/bash/functions/; \
# Finalize up everything
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /var/run/sshd; \
    chmod +x /entrypoint.sh; \
    chmod +x /usr/local/sbin/reboot; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
