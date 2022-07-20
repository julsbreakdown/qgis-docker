# Might be replaced by qgis/qgis:3.24
FROM qgis/qgis:latest as test
#FROM camptocamp/qgis-server:latest
RUN apt update && apt install -y wget
#RUN wget -qO - https://qgis.org/downloads/qgis-$(date +%Y).gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
RUN wget -qO - https://qgis.org/downloads/qgis-2021.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
#sudo chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg
RUN echo "deb https://qgis.org/debian unstable main" | tee -a /etc/apt/sources.list
RUN echo "deb-src https://qgis.org/debian unstable main" | tee -a /etc/apt/sources.list
#RUN wget -O - https://qgis.org/downloads/qgis-2021.gpg.key | gpg --import gpg --fingerprint 46B5721DBBD2996A

RUN apt remove -y python3-coverage \
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
    HOME=/home/user \
    AWS_DEFAULT_REGION_S3=ch-dk-2 \
    AWS_S3_ENDPOINT=sos-ch-dk-2.exo.io \
    AWS_ACCESS_KEY_ID=EXO4bb02213935891a4710b3e33 \
    AWS_SECRET_ACCESS_KEY=VOkfo8X0bmaxRlCuBoxlZkv1L7VGNp9oPn-38v8vZDg
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
#COPY /docker-entrypoint.sh /
#ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["pytest"]
