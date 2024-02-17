FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN apt-get update && apt-get install -y --no-install-recommends \
        ocl-icd-libopencl1 \
        clinfo pkg-config && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
################################ end nvidia opencl driver ################################


# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget make clinfo build-essential git libcurl4-openssl-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libssl-dev pciutils

# Fetch PCI IDs list to display proper GPU names
RUN update-pciids

RUN mkdir /root/tools
WORKDIR /root/tools

RUN git clone https://github.com/hashcat/hashcat.git && cd hashcat && make install -j4

RUN git clone https://github.com/hashcat/hashcat-utils.git && cd hashcat-utils/src && make
RUN ln -s /root/tools/hashcat-utils/src/cap2hccapx.bin /usr/bin/cap2hccapx

RUN git clone https://github.com/ZerBea/hcxtools.git && cd hcxtools && make install

RUN git clone https://github.com/ZerBea/hcxdumptool.git && cd hcxdumptool && make install

RUN git clone https://github.com/hashcat/kwprocessor.git && cd kwprocessor && make
RUN ln -s /root/kwprocessor/kwp /usr/bin/kwp

# Add wordlists folder
WORKDIR /root
ADD wordlists wordlists

# Install SSH server 
RUN DEBIAN_FRONTEND=noninteractive apt-get install openssh-server -y; mkdir -p /root/.ssh; chmod 700 /root/.ssh

COPY entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]