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

	# Intialize State
	my $state_NEB = -1;
	my $state_NEB_TABLE = -1;

	my $state_BEB = -1;
	my $state_BEB_TABLE = -1;

	my $state_DNDS = -1;

	foreach my $line (@lines ) {
	  # DEBUG
	  #print "state_NEB: $state_NEB | state_NEB_TABLE: $state_NEB_TABLE | state_BEB: $state_BEB | state_BEB_TABLE: $state_BEB_TABLE | state_DNDS: $state_DNDS : $line \n";
	  next if $line =~ /^$/;

	  if($rownumber == 1 ) {
	  	# trim whitespace
	  	$line =~ s/^\s*//; 
	  	$line =~ s/\s*$//;

  	    $data{"name"} = $line;
	  }

	  # State determination - DnDS
	  if($line =~ m/^dN/) {
	  	$state_DNDS = 1;
	  }

	  if($state_DNDS==1 && $line !~ m/^Naive/) {
	    $data{"dnds_info"}{"raw"} = $data{"dnds_info"}{"raw"}.$line."\n";
	  }
	  # read until the sequence

	  # State determination - Initiate NEB state
	  if($line =~ m/^Naive/) {  
	  	$state_NEB = 1;
	  	$state_DNDS = -1;
	  	# Number of classes
	  	$line =~ m/(\d+) classes/;
	  	$data{"NEB"}{"number_of_classes"} = $1;

	  	$state_NEB_TABLE=1;
	  }

	  # NEB State
	  if($state_NEB == 1) {
	  	# info

	  	# NEB Ending State
	  	if($line =~ /^lnL/) {
		  $line =~ m/^lnL = (.*)/;
		  $data{"NEB"}{"lnL"} = $1;

  	  	  $state_NEB = -1;
  	  	  $state_NEB_TABLE = -1;

  	  	  next;
  	  	}
  	  	if($line =~ /^Positively/ ){
  	  		$state_NEB_TABLE = -1;
  	  		next;
  	  	}
  	  	# Skipping line
	  	if($line =~ /^$/ || $line =~ /^(Naive Empirical|\(amino acids refer|Model|\s+Prob)/) {
	  		next;
	  	}

	  	if($state_NEB_TABLE == 1) {
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
	  	} else {

	  		my %record;
		  	my @fields=split /\s+/, $line ;

		  	$record{"pos"} = $fields[1];
		  	$record{"aa"} = $fields[2];
		  	$record{"prob_w_gt_1"} = $fields[3];
		  	$record{"mean_w"} = $fields[4];

		  	push(@{$data{"NEB"}{"POST_SELECTED"}}, \%record);
	  		# print Dumper 
	  		#$data{"NEB"}{"POS_SELECTED"}
	  	}
	  	# state_NEB ends when encountering lnL
	  }

	  # State Determination - BEB 
	  if($line =~ m/^Bayes Empirical/) {
	  	$state_BEB = 1;
	  	$state_BEB_TABLE=1;
	  	$state_NEB = -1;
	  	# Number of classes
	  	$line =~ m/(\d+) classes/;
	  	$data{"BEB"}{"number_of_classes"} = $1;

	  }
	  if($state_BEB==1) {
	  	# state_BEB ends when encountering Model 
	  	if($line =~ /^Model/) {
  	  	  $state_BEB = -1;
	  	}
	  	if($line =~ /^Positively/) {
  	  	  $state_BEB_TABLE = -1;
  	  	  next;
	  	}
	  	if($line =~ /^$/ || $line =~ /^(Bayes Empirical Bayes|\(amino acids refer|Model|\s+Prob)/) {
	  		next;
	  	}

	    if($state_BEB_TABLE == 1 )	{
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
	    } else {
	  		my %record;
		  	my @fields=split /\s+/, $line ;

		  	$record{"pos"} = $fields[1];
		  	$record{"aa"} = $fields[2];
		  	$record{"prob_w_gt_1"} = $fields[3];
		  	$record{"mean_w"} = $fields[4];

		  	push(@{$data{"BEB"}{"POST_SELECTED"}}, \%record);
	    }
	  }



	  $rownumber++;
	}
	#print Dumper \%data;
	$all_data{$i} = \%data;

	$i++;
}

my $json = encode_json \%all_data;
print $json;
