#!/usr/bin/perl

use strict;
use warnings;
use Time::localtime;
use File::stat;
use Image::Info qw(image_info dim image_type);
use Image::EXIF;
use UNIVERSAL 'isa';
use Data::Dumper;
use File::Spec;
use Image::ExifTool;
use Switch;
use Cwd;

my $dir = shift || die "No filename on command line\n";
#my $dir  = '/tmp';

opendir( DIR, $dir ) or die $!;
my $cnt = 0;
while ( my $file = readdir(DIR) ) {
    my $p =$dir.$file;
    # Use a regular expression to ignore files beginning with a period
    next if ( $file =~ m/^\./ );
    if (-f $dir.$file) {
        #file extension
        my ($ext) = $file =~ /(\.[^.]+)$/;

        #	switch($ext){
#		case ".mp4" {
		# Create a new Image::ExifTool object
# my $exifTool = new Image::ExifTool;

# Extract meta information from an image
# $exifTool->ImageInfo($p);
# my $date = $exifTool->GetValue('CreateDate');
# print $date."\n";
#		}
#		else {
	
	
	#extract date from EXIF
        my @ioTagList = ('CreateDate');
        my $exifTool = new Image::ExifTool;
        $exifTool->Options(DateFormat => "%Y%m%d_%H%M%S");
        my $info = $exifTool->ImageInfo($p);
        #print $$info{'CreateDate'}."\n";

	#print Dumper($info)."\n";
	#create new filename
        my $name;
        if ($$info {'DateTimeOriginal'}) { $name   = $$info {'DateTimeOriginal'}; }                
        elsif ($$info {'ModifyDate'}) { $name   = $$info {'ModifyDate'}; }
        elsif ($$info {'CreateDate'}) { $name   = $$info {'CreateDate'}; }
        else { $name = ''; }
        
        my ($pathvol,$pathdir,$pathfile) = File::Spec->splitpath($p);
        if($name) {
            my $tail = '';
            my $newfile = File::Spec->catfile($name.$tail.$ext);
            
#            print $p."\n".$pathdir.$newfile."\n\n";
            #write files
            if( -f $newfile ) {
                print "skipping $p: already exists at $newfile";
            }
            if($p ne $newfile) {                
                rename($p,$pathdir."/".$newfile) or die "Error: could not copy $p to $newfile: $!n";
            }
        } else {
            print "Skipping: ".$p." -> No information for rename\n"; 
            print "Possible dates:\n";
            print $$info{'ModifyDate'}."\n";
            print $$info{'FileModifyDate'}."\n";
        }
        ++$cnt;
    }
}
print $cnt;
closedir(DIR);
exit 0;
