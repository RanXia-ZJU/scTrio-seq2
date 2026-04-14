#!/usr/bin/perl
use warnings;
use strict;

my (%count,%tpm,@sample);
open(LIST,"sample.list");
while(my $sample=<LIST>){
	chomp($sample);
	push @sample,$sample;
	my $file;
	open(IN,"$sample.genes.results");
	while(<IN>){
		next if($_=~/count/);
		chomp;
		my @data=split(/\t/,$_);
		$data[0]=~s/\..*//g;
		$count{$data[0]}{$sample}=$data[4];
		$tpm{$data[0]}{$sample}=$data[5];
	}
	close(IN);
}
close(LIST);

open(OUT1,">merged.count.xls");
open(OUT2,">merged.tpm.xls");
print OUT1 "gene";
print OUT2 "gene";
for(my $i=0;$i<@sample;$i++){
	print OUT1 "\t$sample[$i]";
	print OUT2 "\t$sample[$i]";
}
print OUT1 "\n";
print OUT2 "\n";
foreach my $gene(keys %count){
	print OUT1 "$gene";
	print OUT2 "$gene";
	for(my $i=0;$i<@sample;$i++){
		print OUT1 "\t$count{$gene}{$sample[$i]}";
		print OUT2 "\t$tpm{$gene}{$sample[$i]}";
	}
	print OUT1 "\n";
	print OUT2 "\n";
}
close(OUT1);
close(OUT2);
