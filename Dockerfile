ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    python3  \
    py3-pip \
  && pip3 install umodbus

WORKDIR /data

# Copy data for add-on
COPY run.sh 
COPY rhi.sh /data/  
RUN chmod a+x /run.sh
RUN chmod a+x /data/rhi.sh


CMD [ "/run.sh" ]
