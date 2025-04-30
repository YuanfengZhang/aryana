#! /bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: prepare_genomes.sh <reference genome> <position of CpG islands file> <output folder>"
	exit
fi

GENOME="$1"
CPG_F="$2"
OUTPUT_DIR="$3"

declare -a fa_files=(
    "${OUTPUT_DIR}/originalGenome.fa"
    "${OUTPUT_DIR}/BisulfiteGenomeIslandConsideredCT.fa"
    "${OUTPUT_DIR}/BisulfiteGenomeCompleteCT.fa"
    "${OUTPUT_DIR}/BisulfiteGenomeIslandConsideredGA.fa"
    "${OUTPUT_DIR}/BisulfiteGenomeCompleteGA.fa"
)

timestamp() {
    date +"%Y-%m-%d %T"
}

log_start() {
    echo "[$(timestamp)] START: $1"
}

log_end() {
    echo "[$(timestamp)] END: $1"
}

ARYANA_DIR=$(dirname $(readlink -f $0));
mkdir -p "${OUTPUT_DIR}"
log_start "Converting genomes"
"$ARYANA_DIR/convert_genomes" -g "${GENOME}" -a "${CPG_F}" -o "${OUTPUT_DIR}"
if [ $? -eq 0 ]; then
    log_end "Converting genomes"
	log_start "Creating index files"
else
    echo "[[$(timestamp)]] Converting genomes was FAILED. Please check the above errors and run the prepare_genome.sh again after fixing errors."
	exit
fi
log_end "End of convert_genomes"
log_start "Start of aryana"

aryana_steps=("index" "fa2bin")
for step in "${aryana_steps[@]}"; do
    log_start "Running aryan $step on genome files"
    for file in "${fa_files[@]}"; do
        if [ -f "$file" ]; then
            log_start "  $step: $(basename "$file")"
            "$DIR/aryana" "$step" "$file"
            if [ $? -eq 0 ]; then
                log_end "  Finished $step: $(basename "$file")"
            else
                echo "[$(timestamp)] ERROR: Failed to run aryan $step on $file"
                exit 1
            fi
        else
            echo "[$(timestamp)] WARNING: File not found (skipped): $file"
        fi
    done
    log_end "Finished aryan $step"
done

echo "[$(timestamp)] All tasks completed!"
