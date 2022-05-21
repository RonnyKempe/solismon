ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    python3  \
    py3-pip \
  && pip3 install umodbus pysolarmanv5

WORKDIR /data
#ENV PYTHON_PATH=/usr/local/bin/ \
#    PATH="/usr/local/lib/python$PYTHON_VERSION/bin/:/usr/local/lib/pyenv/versions/$PYTHON_VERSION/bin:${PATH}" \
# Copy data for add-on
COPY rootfs / 
 
RUN chmod a+x /run.sh
RUN chmod a+x /usr/bin/rhi.sh


CMD [ "/run.sh" ]
