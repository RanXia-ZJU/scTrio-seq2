#!/usr/bin/perl
use warnings;
use strict;

my %mean_methy;
my @sample=('sample1','sample2')
for(my $i=0;$i<@sample;$i++){
		my (%methy,%count);
		open(IN,"zcat $sample[$i].bismark_bt2.filter.deduplicated.sort.genome_DNA.bedGraph.gz|");
		while(<IN>){
			next if($_=~/track/);
			chomp;
			my ($chr,$pos1,$pos2,$methy_rate)=split(/\t/,$_);
			next if($chr=~/\_/ or $chr=~/X/ or $chr=~/Y/ or $chr=~/M/);
			$chr=~s/chr//;
			my $window=int(($pos2-1)/100000)+1;
			$methy{$chr}{$window}+=$methy_rate;
			$count{$chr}{$window}++;

		}
		close(IN);
		foreach my $chr(keys %methy){
			foreach my $window(keys %{$methy{$chr}}){
				$mean_methy{$chr}{$window}{$sample[$i]}=sprintf("%.2f",$methy{$chr}{$window}/$count{$chr}{$window});
			}
		}
}
open(OUT,">mean_methylation_level.xls");
print OUT "bin";
for(my $i=0;$i<@sample;$i++){
	print OUT "\t$sample[$i]";
}
print OUT "\n";
foreach my $chr(sort {$a<=>$b} keys %mean_methy){
	my @window=sort {$a<=>$b} keys %{$mean_methy{$chr}};
        for(my $j=0;$j<@window;$j++){
		my $start=($window[$j]-1)*100000+1;
                my $end=$start+100000-1;
                print OUT "$chr:$start-$end";
		for(my $i=0;$i<@sample;$i++){
			$mean_methy{$chr}{$window[$j]}{$sample[$i]}='NA' unless(exists $mean_methy{$chr}{$window[$j]}{$sample[$i]});
			print OUT "\t$mean_methy{$chr}{$window[$j]}{$sample[$i]}";
		}
		print OUT "\n";
	}
}
close(OUT);
