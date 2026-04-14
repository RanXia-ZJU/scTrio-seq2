#!/usr/bin/env python

from collections import defaultdict
import sys
import re
import pysam

def read_mc_level(read):
    bismark_tag = read.get_tag('XM')
    m_cpg = bismark_tag.count('Z')
    normal_cpg = bismark_tag.count('z')
    return m_cpg, normal_cpg


total_m_cpg = 0
total_normal_cpg = 0

with pysam.AlignmentFile(sys.argv[1]) as f:
    for read in f:
        m_cpg, normal_cpg = read_mc_level(read)
        total_m_cpg += m_cpg
        total_normal_cpg += normal_cpg

total_m_cpg_level = total_m_cpg / (total_m_cpg + total_normal_cpg) if (total_m_cpg + total_normal_cpg) != 0 else 0
CT_efficiency = 1 - total_m_cpg_level if (total_m_cpg + total_normal_cpg) != 0 else "NA"

with open(str(sys.argv[1]) + '.CT_efficiency.tsv','w') as out_f:
    out_f.write(f'lambda_CT_efficiency\t{CT_efficiency:.2%}\n')
