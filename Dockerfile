FROM ubuntu:20.04

# Install the dependencies
# See https://microchipdeveloper.com/install:mplabx-lin64
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 wget sudo make && \
  apt-get clean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

# Download and install XC8
RUN wget -nv -O /tmp/xc8 "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v2.40-full-install-linux-x64-installer.run" && \
  chmod +x /tmp/xc8 && \
  /tmp/xc8 --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix "/opt/microchip/xc8/v2.40" && \
  rm /tmp/xc8

# Download and install MPLAB X
RUN wget -nv -O /tmp/mplabx "https://www.microchip.com/content/dam/mchp/documents/DEV/ProductDocuments/SoftwareTools/MPLABX-v6.00-linux-installer.tar" &&\
  cd /tmp && \
  tar -xf mplabx && \
  rm mplabx && \
  mv "MPLABX-v6.00-linux-installer.sh" mplabx && \
  sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe 0 --collectInfo 0 --installdir /opt/mplabx --16bitmcu 0 --32bitmcu 0 --othermcu 0 && \
  rm mplabx

COPY build.sh /build.sh

ENTRYPOINT [ "/build.sh" ]
