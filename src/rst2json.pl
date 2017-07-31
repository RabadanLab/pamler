#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON;

# Separate out file by the Model prefix
$/ = "Model";

my $i = 1 ;
my %all_data;
while (<>) {
	my $filename='tmp'.$i.'.txt';
	open my $fh, '>',  $filename or die;
	# Save to a file
	print $fh $_;

	# parse
	my $rownumber = 1;

	my %data;
	# initialize
	$data{"dnds_info"} ="";
	$data{"NEB"}{"aa"} = "";
	$data{"BEB"} = "";

	my @lines = split "\n", $_;
	my $state_NEB = -1;
	my $state_BEB = -1;
	foreach my $line (@lines ) {
	  if($rownumber == 1 ) {
	  	# trim whitespace
	  	$line =~ s/^\s*//; 
	  	$line =~ s/\s*$//;

  	    $data{"name"} = $line;
	  }
	  if($rownumber >= 3 && $rownumber <= 7) {
	    $data{"dnds_info"} = $data{"dnds_info"}.$line."\n";
	  }
	  # read until the sequence
	  if($line =~ m/^Naive/) {
	  	$state_NEB = 1;
	  	# Number of classes
	  	$line =~ m/(\d+) classes/;
	  	$data{"NEB"}{"number_of_classes"} = $1;
	  }

	  if($state_NEB==1) {

	  	$line =~ m/^lnL = (.*)/;
	  	$data{"NEB"}{"lnL"} = $1;

	  	# info
	  	if($line =~ /^lnL/) {
  	  	  $state_NEB = -1;
  	  	  next;
  	  	}
	  	if($line =~ /^$/ || $line =~ /^(Naive Empirical|\(amino acids refer|Model|Positively|\s+\D)/) {
	  		next;
	  	}
	  	$data{"NEB"}{"aa"} = $data{"NEB"}{"aa"}.$line."\n";
	  	my @fields=split /[ ()]+/, $line ;
	  	my %record;
	  	$record{"pos"}=$fields[1];
	  	$record{"aa"}=$fields[2];
	  	for( my $i = 0; $i < $data{"NEB"}{"number_of_classes"}; $i++) {
		  	$record{"prob".($i+1)}=$fields[3+$i];
	  	}
	  	$record{"class"}=$fields[3+$data{"NEB"}{"number_of_classes"}];
	  	$record{"prob"}=$fields[4+$data{"NEB"}{"number_of_classes"}];
	  	push(@{$data{"NEB"}{"parsed"}}, \%record);
	  	# state_NEB ends when encountering lnL
	  }

	  # BEB 
	  if($line =~ m/^Bayes Empirical/) {
	  	$state_BEB = 1;
	  }
	  if($state_BEB==1) {
	  	# state_BEB ends when encountering Model 
	  	if($line =~ /^Model/) {
  	  	  $state_BEB = -1;
	  	}
	  	$data{"BEB"} = $data{"BEB"}.$line."\n";
	  }
	  $rownumber++;
	}
	#print Dumper \%data;
	$all_data{$i} = \%data;

	$i++;
	close $fh;
}

my $json = encode_json \%all_data;
print $json;
