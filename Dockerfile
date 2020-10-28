#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################

ARG image=alpine/git
ARG version=:1.0.21
ARG digest=sha256:8715680f27333935bb384a678256faf8e8832a5f2a0d4a00c9d481111c5a29c0

FROM $image$version$digest AS clone

ARG dir=/clone-folder
ARG hostname=github.com
ARG project=phpinfo
ARG username=openshift-academia-online

WORKDIR $dir
RUN git clone https://$hostname/$username/$project

###

FROM alpine:3.12.1@sha256:d7342993700f8cd7aba8496c2d0e57be0666e80b4c441925fc6f9361fa81d10e AS production

ARG dir_old=/clone-folder/phpinfo/src
ARG dir=/production-folder
ARG project=index.php

WORKDIR $dir
COPY --from=clone $dir_old/$project . 

RUN apk add --upgrade php

ENTRYPOINT ["php"]
CMD ["-f","index.php","-S","0.0.0.0:8080"]
#########################################################################
