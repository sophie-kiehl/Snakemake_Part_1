# This is the Snakefile that you will use for your wokflow.

rule all:
    input:
        expand("results/{sample}.sorted.bam.bai", sample=config["samples"])

rule map_reads:
    input:
        sample="samples/{sample}.fastq"
    output:
        bam="results/{sample}.bam"
    params:
    	bowtie_index=config["genome"]
    log:
    	"results/{sample}.log"
    shell:
        "bowtie2 -x {params.bowtie_index} {input.sample} 2> {log} | samtools view -bS - -o {output.bam}"
        
rule sort_reads:
    input:
        bam_fin="results/{sample}.bam"
    output:
        bam_sorted="results/{sample}.sorted.bam"
    shell:
        "samtools sort {input.bam_fin} -o {output.bam_sorted}"
        
rule bam_index:
    input:
        sorted_fin="results/{sample}.sorted.bam"
    output:
        bai="results/{sample}.sorted.bam.bai"
    shell:
        "samtools index {input.sorted_fin}"