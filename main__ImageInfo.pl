#!/usr/bin/perl

use strict;
use warnings;
use Image::Info qw(image_info dim image_type);
use UNIVERSAL 'isa';
use Data::Dumper;
use File::Spec;

my $dir = shift || die "No filename on command line\n";

opendir( DIR, $dir ) or die $!;
my $cnt = 0;

while ( my $file = readdir(DIR) ) {
	my $p =$dir.$file;
	# Use a regular expression to ignore files beginning with a period
	next if ( $file =~ m/^\./ );

	if (-f $p){
		my $info = image_info($p);
	print Dumper($info);
#		print Dumper($image_info);
#		print "\n";
#		print "$file\n";
		
		
		if (my $error = $info->{error}) {
			die "Can't parse image info: $error\n";
 		}
 		
		my $date = $info -> {DateTime};
		
		if (isa($date,'ARRAY')){
			#print $file."---ARRAY--->".Dumper $date."\n";
			#print Dumper(Dumper $date)."\n";
			my @datearr = $$date[0];
			$date = $datearr[0];
			print "$file ------> $date\n";
		}else {
			print "$file ------> $date\n";
		}
		
		my $newname = $date.".jpg"; 
		$newname =~ s/://g;		 
		$newname =~ s/ /_/;
		rename $p,$dir.$newname;
	++$cnt;
	}
}
print $cnt;
closedir(DIR);
exit 0;

	
	
	

