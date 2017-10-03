use List::Util qw(sum);



$A = $ARGV[0];
chomp $A;
open(file, $A);
$/=">"; 
while(<file>){
 	next if $_ eq ">";
 	$_ =~ s/>//g;
 	($x,$y)= split(/\n/,$_,2); 

$output = "resultado$A";
open(resultado, ">$output");

 	$y=~ s/\n//g; 
 	$y=~ s/\s+//g;

 	$fasta{$x}="$y"; 

}
$/="\n";
close(file);
@valor=keys(%fasta);
#print "enter file1 AGAIN\n";
#$nombress = <STDIN>;
#chomp $nombress;
#open(file, $nombress);
#$nombres = <file>;
#@nombre = split(/:/, $nombres);
#$length = scalar(@nombre);

my @arreglo;

	foreach $aa (@valor)  {
              $contenido=$fasta{$aa};

			  @seq=split('',$contenido);
			  
			  $longseq=scalar(@seq);
			$indet=0;
			$ntA=0;
			$ntT=0;
			$ntC=0;
			$ntG=0;
			

		foreach $base (@seq) {
		if ($base eq 'A')
		{
		     ++$ntA;

             }
elsif ($base eq 'T')
		{
		     ++$ntT;

             }
			 
			elsif ($base eq 'G')
		{
		     ++$ntG;

             } 
			 			elsif ($base eq 'C')
		{
		     ++$ntC;

             } 
			 else 
		{
		     ++$indet;

             } 
			 
}
$ATGC= $ntA+$ntT+$ntG+$ntC;
print resultado "$aa; indets+gaps=; $indet; ATGC=; $ATGC\n"; 			       
						 					#print $longseq;
	push(@arreglo, $indet);									
}

@sorted = sort { $a <=> $b } @arreglo;
$states=scalar(@sorted);
$overall_indet=sum(0,@sorted);
$total_nucs=$longseq*$states;
$perc_indets=($overall_indet/$total_nucs)*100;
$umbral_lower=(5*$states)/100;
$umbral_upper=$states-$umbral_lower;


$proportion_095= (@sorted[$umbral_upper]/$longseq)*100;
print resultado "\n\n\n 95% of your sequences in $A have less than  @sorted[$umbral_upper] indets+gaps, which is $proportion_095 % of the alignment's length\n";
print resultado "The overall % of gaps+indets in the alignment $A is $perc_indets";


close(resultado);


exit;
