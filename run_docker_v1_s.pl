#!/usr/bin/perl
use File::Basename;
use strict; 

if($#ARGV!=2){
    print "Usage:\nrun_for_landsat.pl [start_path] [end_path] [start_row] [end_row]\n"
}
my $spath = $ARGV[0];
#my $epath = $ARGV[1];
#my $srow  = $ARGV[2];
my $erow  = $ARGV[1];#$ARGV[3];
my $prc = 5;

my $DIR_IN = "/mnt/hdfs/S2/tiles";
my $DIR_OUT = "/data/cloudless";

foreach my $dir (glob("$DIR_IN/$spath/$erow*")){
    my $row = basename($dir);
    my $path = $spath;
    my $dir = $DIR_IN."/$path/$row/";
    my $odir = $DIR_OUT."/$path/$row/";
    if(-d $dir){
        if(-d $odir) { next;} 
        system("sudo docker run -i -v $DIR_IN:/data:rw -v $DIR_OUT:/out:rw --rm avs/cloudless.v1.2 run_by_dir_s.pl /data/$path/$row /out/$path/$row $prc");
    }
}

__END__
for (my $i=$spath;$i<=$epath;$i++){
  my $path = sprintf("%03d",$i);
  for(my $j=$srow;$j<=$erow;$j++){
    my $row = sprintf("%02d",$j);
    my $dir = $DIR_IN."/$path/$row/";
    my $odir = $DIR_OUT."/$path/$row/";
    if(-d $dir){
#        system("sudo docker run -i -v $DIR_IN:/data:rw -v $DIR_OUT:/out:rw --rm avs/cloudless.v1.1 run_by_dir_s.pl /data/$path/$row /out/$path/$row $prc");
    }
  }
}

#print +(A..Z);
__END__
  foreach my $dir (glob("/mnt/hdfs/OLI_TOA/scenes/$tbuf/*")){
    my @chk = glob("$dir/LC8*");
    print "$dir $#chk\n";
    if($#chk+1<2) { print "Less then 2 scnes in folder $dir\n"; next; } 
    (my $tdir = $dir)=~s/\/mnt\/hdfs\/OLI_TOA\/scenes/\/data/;
    if(-d $dir."/stack"){
        print "Skipping dir $tdir\n";
        next;
    }
    system("sudo docker run -i -v /mnt/hdfs/OLI_TOA/scenes:/data:rw --rm avs/cloudless run_by_dir.pl $tdir");
  }
}
