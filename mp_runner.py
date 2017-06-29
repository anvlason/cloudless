#!/usr/bin/python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from multiprocessing import Pool
import os
import sys
import re
import errno

global prc, mkdc

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
def get_data_paths(folder):
    return (os.path.join(folder, f)
            for f in os.listdir(folder)
            if 'vrt' in f)
#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
def runner(iname):
    proc = "stack_landsat_1.1.py"
    print prc
    oname = re.sub("stack_","",iname)
    oname = re.sub(".vrt","_cloudless.tif",oname)
    bn = os.path.basename(oname)
    oname = "/tmp/"+bn
    os.system("%s %s %s %d %d"%(proc,iname,oname,prc,mkdc))
#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
if __name__ == '__main__':
    folder = sys.argv[1]
    ofolder = sys.argv[2]
    try:
        prc = float(sys.argv[3])
        mkdc = int(sys.argv[4])
    except:
        prc = 25
        mkdc = 0
    images = get_data_paths(folder)
    mkdir_p(ofolder)

    pool = Pool()
    pool.map(runner, images)
    pool.close()
    pool.join()
    
    os.system("cp -f /tmp/*.tif %s"%(ofolder))
#    os.system("chmod -R 777 %s"%(ofolder))
