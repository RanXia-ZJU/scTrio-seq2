# scTrio-seq2 data analysis
scTrio-seq2 is a single-cell triple-omics sequencing technique that enables simultaneous analysis of DNA methylome, transcriptome and genomic copy-number variations (CNVs) from individual mammalian cells. 

This repository provides in-house programs for analyzing scTroi-seq2 data.

The workflow for analyzing scTrio-seq2 data is shown below:
![workflow](https://github.com/user-attachments/assets/cdbb53c9-995a-4a09-a266-5573c1cbea6a)

The above workflow requires the following softwares:
1. Read-quality assessment: FastQC (v0.12.1)
2. Adaptor and quality trimming: Cutadapt (v2.10)
3. RNA read alignment: STAR (2.7.1a)
4. Expression quantification: RSEM (v1.3.3)
5. Bisulfite-aware alignment and mC calling: Bismark (v0.20.0)
6. Alignment processing: SAMtools (v1.9) for 
7. Downstream analyses and visualization: R (v4.3.1), Perl (v5.26.2), or Python (v3.7.5)

**Quick start**
