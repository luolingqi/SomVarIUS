FROM continuumio/anaconda:latest

ENV PATH /usr/bin:$PATH
ENV PYTHONPATH /opt/conda/lib/python2.7/site-packages/:$PYTHONPATH

# install requirements
RUN pip install --upgrade scipy numpy cython pysam
RUN chmod -R ugo+rX /opt/conda/lib/python2.7/site-packages/

# install samtools as a dependency
RUN apt-get update --fix-missing && apt-get install -y autoconf automake \
    make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev \
    libssl-dev libncurses5-dev python-setuptools wget git apt-utils python-dev

RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 -O samtools.tar.bz2 && \
    tar -xjvf samtools.tar.bz2 && \
    cd samtools-1.3.1 && \
    make && \
    make prefix=/usr/local/bin install

# if you have old version such as 0.x from samtools, you may remove it and create a link to new version
RUN apt remove samtools && \
    ln -s /usr/local/bin/bin/samtools /usr/bin/samtools


# install the SomVarIUS
RUN git clone https://github.com/luolingqi/SomVarIUS.git && \
    cd SomVarIUS && \
    python setup.py install


ENTRYPOINT ["SomVarIUS"]
CMD ["/bin/bash"]