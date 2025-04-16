struct report *report_discordant_alignment_results(
    global_vars *g, char *buffer, char *cigar[], char *cigar2[],
    bwa_seq_t *seq, bwa_seq_t *seq2, hash_element *table, hash_element *table2,
    int *can, int *can2, int canNum, int canNum2,
    penalty_t *penalty, penalty_t *penalty2
);

typedef struct {
    int mismatch_num, gap_open_num, gap_ext_num, penalty;
    double mapq;
} penalty_t;


char getNuc(uint64_t place, uint64_t *reference, uint64_t seq_len);

void bwa_aln_core2(aryana_args *args);

void bwa_aln_single(const char *prefix, const char *fn_fa);
