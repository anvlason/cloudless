#!/usr/bin/python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from osgeo import gdal
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
