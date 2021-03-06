## Retrieve Ensembl annotations from biomaRt.

library(optparse)

## deal with the options
option_list <- list(
    make_option(c("--host"), default="www.ensembl.org",
                help="the ensembl version to use"),
    make_option(c("--dataset"), default="hsapiens_gene_ensembl",
                help="e.g. hsapiens_gene_ensembl or mmusculus_gene_ensembl"),
    make_option(c("--outfile"), default="none",
                help="outfile")
    )

opt <- parse_args(OptionParser(option_list=option_list))

print("Running with options:")
print(opt)

require(biomaRt)

ensembl <- useMart(host=opt$host,
                   biomart='ENSEMBL_MART_ENSEMBL',
                   dataset=opt$dataset)


annotation <- getBM(attributes=c('ensembl_gene_id',
                                 'ensembl_transcript_id',
                                 'gene_biotype',
                                 'transcript_biotype',
                                 'external_gene_name'),
                                        mart = ensembl)


annotation <- annotation[,c("ensembl_gene_id", "ensembl_transcript_id", "gene_biotype",
                            "transcript_biotype","external_gene_name")]

colnames(annotation) <- c("gene_id", "transcript_id","gene_biotype",
                          "transcript_biotype","gene_name")


write.table(annotation,
            gzfile(opt$outfile),
            quote=FALSE,
            col.names=T,
            row.names=FALSE,sep="\t")
