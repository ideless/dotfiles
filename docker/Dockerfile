FROM ubuntu:latest

ADD setup/ /tmp/

ARG username=
ARG password=

RUN cd /tmp && \
    bash setup.sh --username ${username} --password ${password} \
    rm -r ./* 

USER ${username}
ENV TERM xterm-256color
WORKDIR /home/${username}

CMD ["bash"]
