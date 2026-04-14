# scTrio-seq2 data analysis
scTrio-seq2 is a single-cell triple-omics sequencing technique that enables simultaneous analysis of DNA methylome, transcriptome and genomic copy-number variations (CNVs) from individual mammalian cells. 

This repository provides in-house programs for analyzing scTroi-seq2 data.

The workflow for analyzing scTrio-seq2 data is shown below:
![workflow](https://github.com/user-attachments/assets/cdbb53c9-995a-4a09-a266-5573c1cbea6a)

## The above workflow requires the following softwares:
1. Read-quality assessment: FastQC (v0.12.1)
2. Adaptor and quality trimming: Cutadapt (v2.10)
3. RNA read alignment: STAR (2.7.1a)
4. Expression quantification: RSEM (v1.3.3)
5. Bisulfite-aware alignment and mC calling: Bismark (v0.20.0)
6. Alignment processing: SAMtools (v1.9)
7. Copy number calling: QDNAseq
8. Downstream analyses and visualization: R (v4.3.1), Perl (v5.26.2), or Python (v3.7.5)

## How to perform data analysis shown in the workflow
1. Create a project directory and a rawdata directory in this projectory directory

   $ mkdir project

   $ cd project

   $ mkdir rawdata_fq
2. Put the FQ files in the 'rawdata_fq' directory or make soft links as {sample_name}_R1.fq.gz and {sample_name}_R2.fq.gz.
3. Generate the 'sample.list' file which contain the sample name of the FQ files.

   $ ls *R1.fq.gz|sed 's/_R1.fq.gz//' > ../sample.list
4. Go to the project directory. Put the Perl script 'pipeline.pl' in the project directory and execute

   $ cd ..
   
   $ perl pipeline.pl

   This will generate a directory named 'scripts' which contain all the shell scripts to perform data analysis shown in the workflow.
6. Go to the scripts directory and execute the shell scripts sequentially.

## Example downstream analyses
### RNA expression
1) Generate a file named 'sample.list' which contain sample names for all the RNA libraries, and then generate expression matrix in the directory where RSEM output files locate

   $ perl 1.generate_expression_matrix.pl
2) Examine correlation between RNA libraries

   $ Rscript 2.cor.R
3) Perform differential expression analysis using DESeq2

   $ Rscript 3.DEseq2.R
   
   Note: Users need to modify group info in this script.
4) Visulize differentially expressed genes using ggplot2

   $ Rscript 4.DEG_plot.R

   Note: Users need to prepare a file with geneID as the first column and geneName as the second column, and modify the interested genes (which genes to show gene name) in the script.
   
### DNA methylation
1) Generate methylation matrix in the directory where mC calling output files locate

   $ perl 1.mean_methylation_level.100kb_bin.pl

   Note: Users need to modify sample name in this script.
2) Examine correlation between DNA libraries based on DNA methylation levels in 100kb tiling bins.

   $ Rscript 2.cor.R
3) Perform differential methylation analysis using Student's t test.

   $ Rscript 3.DMR.R
   
   Note: Users need to modify group info in this script.
4) Visulize DMR in heatmap

   $ Rscript 4.heatmap

   Note: Users need to modify group info in this script.

### Copy number variation
1) Perform copy number analysis using QDNaseq in the directory where final BAM files of DNA libraries locate

   $ Rscript 1.QDNAseq.R
   
   Note: Users need to modify sample name in this script.
2) Examine correlation between DNA libraries based on copy numbers

   $ Rscript 2.cor.R

   Note: Users need to modify sample name in this script.
3) Visulize CNV ratio on 22 autosomes in each library using ggplot2

   $ Rscript 3.plot.R

## Contact
houyu(AT)zju.edu.cn

guohs(AT)zju.edu.cn

ranxia(AT)zju.edu.cn
