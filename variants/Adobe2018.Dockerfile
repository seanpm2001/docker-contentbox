# syntax = edrevo/dockerfile-plus
INCLUDE+ Dockerfile

LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL maintainer "Luis Majano <lmajano@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-contentbox"

# Hard Code our engine environment
ENV CFENGINE adobe@2018

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh