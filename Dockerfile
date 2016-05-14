FROM debian:jessie

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.0.5-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-4.0.5-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-4.0.5-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda update -y conda

# Python packages from conda
ADD requirements.txt /tmp/requirements.txt
RUN if [ -f /tmp/requirements.txt ]; then conda install -y --file /tmp/requirements.txt; fi

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# Bundle app source
ADD . /src

# Expose
EXPOSE  5000

# Run
CMD ["python", "/src/application.py"]