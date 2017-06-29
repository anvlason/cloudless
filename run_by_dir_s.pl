#!/usr/bin/perl
#--------------------------------------------------------------------------------------------
#version 1.2
#script for create cloudless vrt scene by all scenes in current path\row
#
#--------------------------------------------------------------------------------------------

use File::Basename;
use strict;

my $num_args = $#ARGV + 1;
print "$num_args\n";
if($num_args < 2) {die "No input or output dir\nUsage:run_by_dir.pl [DIR_IN] [DIR_OUT] [PRC] [MKDC] [MKCOLOR]";}
print "DIR_IN=$ARGV[0]\n";
print "DIR_OUT=$ARGV[1]\n";
print "PRC=$ARGV[2]\n";
print "MKDC=$ARGV[3]\n";
print "MKCOLOR=$ARGV[4]\n";

if(-f "$ARGV[0]/stack/stack_b2.txt") { unlink ("$ARGV[0]/stack/stack_b2.txt");}
if(-f "$ARGV[0]/stack/stack_b3.txt") { unlink ("$ARGV[0]/stack/stack_b3.txt");}
if(-f "$ARGV[0]/stack/stack_b4.txt") { unlink ("$ARGV[0]/stack/stack_b4.txt");}
system("rm -r -f $ARGV[0]/stack/*.vrt");

if(!-d "$ARGV[0]/stack") { mkdir("$ARGV[0]/stack"); }
foreach my $dir(glob("$ARGV[0]/*"))
{
    if((-s "$dir/B2.tif" > 0)&(-s "$dir/B3.tif" > 0)&(-s "$dir/B4.tif" > 0)){
        print "add to stack $dir\n";
        open(lst2,">>$ARGV[0]/stack/stack_b2.txt");
        print lst2 "$dir/B2.tif\n";
        close(lst2);
        open(lst3,">>$ARGV[0]/stack/stack_b3.txt");
        print lst3 "$dir/B3.tif\n";
        close(lst3);
        open(lst4,">>$ARGV[0]/stack/stack_b4.txt");
        print lst4 "$dir/B4.tif\n";
        close(lst4);
    }
}
system("gdalbuildvrt -separate -input_file_list $ARGV[0]/stack/stack_b2.txt $ARGV[0]/stack/stack_b2.vrt");
system("gdalbuildvrt -separate -input_file_list $ARGV[0]/stack/stack_b3.txt $ARGV[0]/stack/stack_b3.vrt");
system("gdalbuildvrt -separate -input_file_list $ARGV[0]/stack/stack_b4.txt $ARGV[0]/stack/stack_b4.vrt");
system("mp_runner.py $ARGV[0]/stack $ARGV[1] $ARGV[2] $ARGV[3]");
#system("stack_landsat.py $ARGV[0]/stack_b2.vrt $ARGV[0]/b2_cloudless.vrt 10");
#system("stack_landsat.py $ARGV[0]/stack_b3.vrt $ARGV[0]/b3_cloudless.vrt 10");
#system("stack_landsat.py $ARGV[0]/stack_b4.vrt $ARGV[0]/b4_cloudless.vrt 10");
#system("gdalbuildvrt -separate $ARGV[0]/stack/cloudless-rgb.vrt $ARGV[0]/stack/b4_cloudless.vrt $ARGV[0]/stack/b3_cloudless.vrt $ARGV[0]/stack/b2_cloudless.vrt");
if($ARGV[4]!=0){
    system("gdalbuildvrt -separate $ARGV[1]/cloudless-rgb.vrt $ARGV[1]/b4_cloudless.tif $ARGV[1]/b3_cloudless.tif $ARGV[1]/b2_cloudless.tif");
    system("logdra_tif $ARGV[1]/cloudless-rgb.vrt $ARGV[1]/cloudless-rgb_dra.tif");
    system("gdal_translate -of JPEG $ARGV[1]/cloudless-rgb_dra.tif $ARGV[1]/cloudless-rgb_dra.jpg");

    system("gdalbuildvrt -separate $ARGV[1]/cloudless-rgb_dc.vrt $ARGV[1]/b4_cloudless_dc.tif $ARGV[1]/b3_cloudless_dc.tif $ARGV[1]/b2_cloudless_dc.tif");
    system("logdra_tif $ARGV[1]/cloudless-rgb_dc.vrt $ARGV[1]/cloudless-rgb_dc_dra.tif");
    system("gdal_translate -of JPEG $ARGV[1]/cloudless-rgb_dc_dra.tif $ARGV[1]/cloudless-rgb_dc_dra.jpg");
}

system("chmod -R 777 $ARGV[1]");
