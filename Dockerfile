# Might be replaced by qgis/qgis:3.14
FROM qgis/qgis:release-3_14 as test

RUN apt update \
     && apt remove -y python3-coverage \
     && apt install -y \
        ffmpeg \
        qt5-image-formats-plugins \
        vim \
	pyqt5-dev-tools \
        python3-setuptools

RUN pip3 install \
    black \
    coverage \
    flake8 \
    nose \
    pydevd \
    pytest \
    pytest-cov
#RUN pip3 install PyQt5==5.14
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
RUN mkdir /tmp/runtime-jwaddle && chmod 700 /tmp/runtime-jwaddle
RUN mkdir -p /app /home/user \
    && chmod 777 /home/user

# Keep QGIS settings in a volume
RUN mkdir -p /home/user/.local/share/QGIS/QGIS3/profiles/default \
    && chmod -R 777 /home/user/.local
VOLUME /home/user/.local/share/QGIS/QGIS3/profiles/default

WORKDIR /app

ENV DISPLAY=:0 \
    HOME=/home/user

RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
#COPY /docker-entrypoint.sh /
#ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["pytest"]
