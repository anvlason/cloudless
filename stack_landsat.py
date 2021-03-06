#!/usr/bin/python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
#******************************************************************************
#Script for dark-stack
#Cloud and shadow detection and removal for Landsat-8 data
#version 1.0
#******************************************************************************

from osgeo import gdal
import numpy as np
import os
import sys
from sys import stdout
import re
import glob
import gc
import timeit
from scipy import ndimage
import logging

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
def gdal_write(oname,data,sds,nodata=-9999,OutDataType=gdal.GDT_Float32):    
#    OutDataType=gdal.GDT_Float32
    driver=gdal.GetDriverByName("Gtiff")
    nbands=1
    ods=driver.Create(oname,data.shape[1],data.shape[0],nbands,OutDataType)
    ods.SetGeoTransform(sds.GetGeoTransform())
    ods.SetProjection(sds.GetProjection())
    ob=ods.GetRasterBand(1)
    ob.SetNoDataValue(nodata)
    ob.WriteArray(data,0,0)
    ob = None
    ods= None

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
if __name__ == '__main__':
    tic = timeit.default_timer()
    gdal.AllRegister()
    gdal.UseExceptions()
    if (len(sys.argv)<2):
        print "Bad arguments"
        print "Usage:\stack [input_stack.vrt]"
        exit(1)
    print sys.argv
    srcname = sys.argv[1]
    outname = sys.argv[2]#re.sub(".vrt",".tif",srcname)
    perc    = float(sys.argv[3])
    try:
        sds = gdal.Open(srcname)
    except:
        print "No input data"
        exit(1)
    stack = sds.ReadAsArray()
    print "read data done by %f sec"%(timeit.default_timer()-tic)
    out = np.zeros((stack.shape[1],stack.shape[2]),dtype=np.float)
    ndmask = np.zeros_like(out)
    for b in range(stack.shape[0]):
        ndmask[stack[b,:,:]==0]+=1
    for y in range(0,out.shape[0]):
        stdout.write("\r%d" % y)
        stdout.flush()
        for x in range(0,out.shape[1]):
            out[y,x] = np.percentile(stack[:,y,x],perc)
    stdout.write("\n")
    out[ndmask>0]=0
    print "calc data done by %f sec"%(timeit.default_timer()-tic)
    gdal_write(outname,out,sds,0,gdal.GDT_UInt16)
    del stack,out,sds,ndmask
    gc.collect()
    print "Processed by %f sec"%(timeit.default_timer()-tic)
    print "Done"
    exit(0)
