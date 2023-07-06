FROM ubuntu:

ADD setup/ /tmp/

ARG username=
ARG password=

RUN cd /tmp && \
    bash setup.sh --username ${username} --password ${password} \
    rm -r ./* 

USER ${username}
ENV TERM="xterm-256color"
ENV TZ="Asia/Shanghai"
WORKDIR /home/${username}

CMD ["bash"]
