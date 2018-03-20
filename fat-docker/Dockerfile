#Ubuntu 16.04 docker image for k8s+vault demo
FROM ubuntu:16.04

ENV TERM=xterm

RUN apt-get update && apt-get install -y jq curl vim wget unzip git httpie && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    wget -q https://releases.hashicorp.com/vault/0.9.5/vault_0.9.5_linux_amd64.zip -O /tmp/vault.zip && \
    unzip -o /tmp/vault.zip -d /usr/local/sbin && rm -rf /tmp/vault.zip && \
    wget -q https://github.com/Caiyeon/goldfish/releases/download/v0.8.0/goldfish-linux-amd64 -O /usr/local/sbin/goldfish && \
    chmod +x /usr/local/sbin/goldfish && \
    wget -q https://raw.githubusercontent.com/vim-scripts/vimcat/master/vimcat -O /usr/local/bin/vimcat && \
    chmod +x /usr/local/bin/vimcat && cd /root && git clone https://github.com/b4b4r07/vim-hcl .vim

COPY config.hcl demo2_entrypoint.sh demo3_entrypoint.sh demo3_init.sh demo2-3-k8s-run-in-pod.sh demo3-3-interactive-init-run-in-pod.sh ./

RUN echo 'export PS1="\033[35;1;0;32;5;226m\u@\h:\w \033[m"' >> /root/.bashrc

EXPOSE 8000

