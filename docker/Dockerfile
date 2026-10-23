# Star Trek: Deep Space Nine - Virtual Space Station (2003 R2 DVD box-set CD-ROM) in a web browser.
# Wine (32-bit prefix) + Xvfb + fluxbox + x11vnc + noVNC. The dead websites it used to call are blocked in compose.yaml.
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 DISPLAY=:1 WINEPREFIX=/root/.wine WINEARCH=win32 WINEDEBUG=-all
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends \
      wine wine32 wine64 libgl1-mesa-dri:i386 libgl1:i386 xvfb x11vnc fluxbox novnc websockify \
      python3 supervisor procps fonts-dejavu-core ca-certificates libarchive-tools \
    && rm -rf /var/lib/apt/lists/*
COPY reg /opt/ds9/reg
COPY mkuserdat.py start-ds9.sh /opt/ds9/
COPY supervisord.conf /etc/supervisor/conf.d/ds9.conf
RUN chmod +x /opt/ds9/start-ds9.sh && ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html
EXPOSE 6080
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
