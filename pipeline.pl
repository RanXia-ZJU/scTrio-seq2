#!/usr/bin/perl
use warnings;
use strict;

my $dir=`pwd`;chomp($dir);
`mkdir -p $dir/scripts`;
open(LIST,"sample.list");
while(my $sample=<LIST>){
	chomp($sample);

	if($sample=~/R_/){ #RNA
		open(OUT1,">scripts/1.fastqc.$sample.sh");
		print OUT1 "mkdir -p $dir/RNA/01.FastQC\n";
		print OUT1 "fastqc -o $dir/RNA/01.FastQC -f fastq $dir/rawdata_fq/$sample\_1.fq.gz\n";
		print OUT1 "fastqc -o $dir/RNA/01.FastQC -f fastq $dir/rawdata_fq/$sample\_2.fq.gz\n";
		close(OUT1);

		open(OUT2,">scripts/2.cutadapt.$sample.sh");
		print OUT2 "mkdir -p $dir/RNA/02.cutadapt\n";
		print OUT2 "cutadapt --cores 2 -g TSO=AAGCAGTGGTATCAACGCAGAGT -G TSO=AAGCAGTGGTATCAACGCAGAGT -a R1Adaptor=AGATCGGAAGAGCACACGTCTGAAC -A R2Adaptor=AGATCGGAAGAGCGTCGTGTAGGGA -O 20 -q 20 -m 30 $dir/rawdata_fq/$sample\_1.fq.gz $dir/rawdata_fq/$sample\_2.fq.gz -o $dir/RNA/02.cutadapt/$sample\_R1.trimmed.fq.gz -p $dir/RNA/02.cutadapt/$sample\_R2.trimmed.fq.gz 2>$dir/RNA/02.cutadapt/$sample.R1.log\n";
		print OUT2 "\n";
		close(OUT2);

		open(OUT3,">scripts/3.rsem.$sample.sh");
		print OUT3 "mkdir -p $dir/RNA/03.rsem\n";
		print OUT3 "/data/software/RSEM/RSEM-1.3.3/rsem-calculate-expression --paired-end --star --star-path /data/software/miniconda3/envs/mapping/bin --star-gzipped-read-file -p 8 $dir/RNA/02.cutadapt/$sample\_R1.trimmed.fq.gz $dir/RNA/02.cutadapt/$sample\_R2.trimmed.fq.gz /data/reference/2.index/RSEM/hg38/hg38 $dir/RNA/03.rsem/$sample\n";
		print OUT3 "\n";
		close(OUT3);
	}elsif($sample=~/M_/){#mC
		open(OUT1,">scripts/1.fastqc.$sample.sh");
		print OUT1 "mkdir -p $dir/DNA/01.FastQC\n";
		print OUT1 "fastqc -o $dir/DNA/01.FastQC -f fastq $dir/rawdata_fq/$sample\_1.fq.gz\n";
		print OUT1 "fastqc -o $dir/DNA/01.FastQC -f fastq $dir/rawdata_fq/$sample\_2.fq.gz\n";
		close(OUT1);

		open(OUT2,">scripts/2.cutadapt.$sample.sh");
		print OUT2 "mkdir -p $dir/DNA/02.cutadapt\n";
		print OUT2 "cutadapt --cores 2 -a R1Adaptor=AGATCGGAAGAGCACACGTCTGAAC -a polyG=G{16} $dir/rawdata_fq/$sample\_1.fq.gz 2> $dir/DNA/02.cutadapt/$sample.R1.log | cutadapt --cores 2 --report=minimal -O 6 -q 20 -u 9 -u -9 -m 30 -o $dir/DNA/02.cutadapt/$sample\_R1.trimmed.fq.gz - >> $dir/DNA/02.cutadapt/$sample.R1.log\n";
		print OUT2 "cutadapt --cores 2 -a R2Adaptor=AGATCGGAAGAGCGTCGTGTAGGGA -a polyG=G{16} $dir/rawdata_fq/$sample\_2.fq.gz 2> $dir/DNA/02.cutadapt/$sample.R2.log | cutadapt --cores 2 --report=minimal -O 6 -q 20 -u 9 -u -9 -m 30 -o $dir/DNA/02.cutadapt/$sample\_R2.trimmed.fq.gz - >> $dir/DNA/02.cutadapt/$sample.R2.log\n";
		close(OUT2);

		open(OUT3,">scripts/3.bismark.$sample.sh");
		print OUT3 "mkdir -p $dir/DNA/03.mapping\n";
		print OUT3 "bismark --bowtie2 --non_directional -N 0 -L 20 --quiet --un --ambiguous --bam --parallel 8 -o $dir/DNA/03.mapping /data/reference/2.index/Bismark/hg38 $dir/DNA/02.cutadapt/$sample\_R1.trimmed.fq.gz\n";
		print OUT3 "bismark --bowtie2 --non_directional -N 0 -L 20 --quiet --un --ambiguous --bam --parallel 8 -o $dir/DNA/03.mapping /data/reference/2.index/Bismark/hg38 $dir/DNA/02.cutadapt/$sample\_R2.trimmed.fq.gz\n";
		print OUT3 "samtools merge --threads 4 -f $dir/DNA/03.mapping/$sample.bismark_bt2.bam $dir/DNA/03.mapping/$sample\_R1.trimmed_bismark_bt2.bam $dir/DNA/03.mapping/$sample\_R2.trimmed_bismark_bt2.bam\n";
		print OUT3 "samtools view -bh -q 10 --threads 4 -o $dir/DNA/03.mapping/$sample.bismark_bt2.filter.bam $dir/DNA/03.mapping/$sample.bismark_bt2.bam\n";
		print OUT3 "deduplicate_bismark -s $dir/DNA/03.mapping/$sample.bismark_bt2.filter.bam --bam --output_dir $dir/DNA/03.mapping\n";
		print OUT3 "samtools sort --threads 4 -o $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.bam $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.bam\n";
		print OUT3 "samtools index -@ 4 $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.bam\n";
		print OUT3 "samtools view -@ 4 $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.bam | awk '\$3!=\"chrL\"' | samtools view -@ 4 -bS -T /data/reference/1.genome/hg38/hg38.fa - > $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.genome_DNA.bam\n";
		print OUT3 "samtools view -@ 4 $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.bam | awk '\$3==\"chrL\"' | samtools view -@ 4 -bS -T /data/reference/1.genome/lamda/lambda.fa - > $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.lamda_DNA.bam\n";
		print OUT3 "DNA_methylation/lambda_CT_efficiency.py $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.lamda_DNA.bam\n";
		print OUT3 "samtools index -@ 4 $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.genome_DNA.bam\n";
		close(OUT3);

		open(OUT4,">scripts/4.mC.$sample.sh");
		print OUT4 "mkdir -p $dir/DNA/04.mC_bismark\n";
		print OUT4 "bismark_methylation_extractor -s --comprehensive --no_overlap --bedGraph --counts --buffer_size 20G --report --cytosine_report --parallel 4 --genome_folder /data/reference/1.genome/hg38/ --gzip --output $dir/DNA/04.mC_bismark $dir/DNA/03.mapping/$sample.bismark_bt2.filter.deduplicated.sort.genome_DNA.bam\n";
		close(OUT4);
	}
}
close(LIST);
