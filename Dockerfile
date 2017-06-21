FROM geodata/gdal:latest

RUN apt-get update && \
    apt-get install -y gfortran gfortran-5 libboost-all-dev libopenblas-dev liblapacke-dev libatlas-base-dev python-scipy python-skimage

RUN pip install pip --upgrade && \
    pip install scikit-learn pyproj && \
    mkdir /out

#RUN mkdir /out &&  \
#    mkdir /usr/include/gdal && \
#    cp -r /usr/include/gdal* /usr/include/gdal/ && \
#    cp -r /usr/include/ogr* /usr/include/gdal/ && \
#    cp -r /usr/include/cpl_* /usr/include/gdal/
RUN mkdir /wrk && \
    mkdir /usr/include/gdal/ &&\
    cp -f /usr/include/gdal*.h /usr/include/gdal/ &&\
    cp -f /usr/include/ogr*.h /usr/include/gdal/ &&\
    cp -f /usr/include/cpl_*.h /usr/include/gdal/

COPY ./scripts /usr/local/bin
WORKDIR /data

#RUN pip install -r requirements.txt

#COPY . /app

CMD perl run_by_dir.pl
