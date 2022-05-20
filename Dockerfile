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
COPY run.sh /
COPY rhi.sh /DATA/
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
