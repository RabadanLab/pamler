#!/usr/bin/perl
# usage:
#   $perl rst2json.pl <rst_file> > tmp.json
# then use json2r.R to access the data
# output:
#  will print JSON to STDOUT
use strict;
use warnings;
use Data::Dumper;
use JSON;
use 5.010;

# Separate out file by the Model prefix
$/ = "Model";

my $i = 1 ;
my %all_data;
while (<>) {
	# my $filename='tmp'.$i.'.txt';
	# open my $fh, '>',  $filename or die;
	# # Save to a file
	# print $fh $_;
	# close $fh;

	# parse
	my $rownumber = 1;

	my %data;
	# initialize
	$data{"dnds_info"}{"raw"} ="";
	$data{"NEB"}{"aa"} = "";
	$data{"BEB"}{"aa"} = "";

	my @lines = split "\n", $_;
	my $state_NEB = -1;
	my $state_BEB = -1;
	my $state_DNDS = -1;
	foreach my $line (@lines ) {
	  next if $line =~ /^$/;

	  if($rownumber == 1 ) {
	  	# trim whitespace
	  	$line =~ s/^\s*//; 
	  	$line =~ s/\s*$//;

  	    $data{"name"} = $line;
	  }
	  if($line =~ m/^dN/) {
	  	$state_DNDS = 1;
	  }
	  if($state_DNDS==1 && $line !~ m/^Naive/) {
	    $data{"dnds_info"}{"raw"} = $data{"dnds_info"}{"raw"}.$line."\n";
	  }
	  # read until the sequence
	  if($line =~ m/^Naive/) {
	  	$state_NEB = 1;
	  	$state_DNDS = -1;
	  	# Number of classes
	  	$line =~ m/(\d+) classes/;
	  	$data{"NEB"}{"number_of_classes"} = $1;
	  }

	  if($state_NEB==1) {

	  	# info
	  	if($line =~ /^lnL/) {
		  $line =~ m/^lnL = (.*)/;
		  $data{"NEB"}{"lnL"} = $1;
  	  	  $state_NEB = -1;
  	  	  next;
  	  	}
	  	if($line =~ /^$/ || $line =~ /^(Naive Empirical|\(amino acids refer|Model|Positively|\s+Prob)/) {
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
	  	$record{"w_bar"}=$fields[4+$data{"NEB"}{"number_of_classes"}];
	  	push(@{$data{"NEB"}{"parsed"}}, \%record);
	  	# state_NEB ends when encountering lnL
	  }

	  # BEB 
	  if($line =~ m/^Bayes Empirical/) {
	  	$state_BEB = 1;
	  	# Number of classes
	  	$line =~ m/(\d+) classes/;
	  	$data{"BEB"}{"number_of_classes"} = $1;

	  }
	  if($state_BEB==1) {
	  	# state_BEB ends when encountering Model 
	  	if($line =~ /^Model/) {
  	  	  $state_BEB = -1;
	  	}

	  	if($line =~ /^$/ || $line =~ /^(Bayes Empirical Bayes|\(amino acids refer|Model|Positively|\s+Prob)/) {
	  		next;
	  	}
	  	$data{"BEB"}{"aa"} = $data{"BEB"}{"aa"}.$line."\n";

	  	my @fields=split /[ \(\)]+/, $line ;
	  	if($#fields != $data{"BEB"}{"number_of_classes"} + 6) {
	  		next;
	  	}
	  	my %record;
	  	$record{"pos"}=$fields[1];

	  	$record{"aa"}=$fields[2];
	  	for( my $i = 0; $i < $data{"BEB"}{"number_of_classes"}; $i++) {
		  	$record{"prob".($i+1)}=$fields[3+$i];
	  	}
	  	$record{"class"}=$fields[3+$data{"BEB"}{"number_of_classes"}];
	  	$record{"w_bar"}=$fields[4+$data{"BEB"}{"number_of_classes"}];
	  	$record{"sd"}=$fields[6+$data{"BEB"}{"number_of_classes"}];
	  	push(@{$data{"BEB"}{"parsed"}}, \%record);
	  }



	  $rownumber++;
	}
	#print Dumper \%data;
	$all_data{$i} = \%data;

	$i++;
}

my $json = encode_json \%all_data;
print $json;
