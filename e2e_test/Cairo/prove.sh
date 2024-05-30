#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

rm -rf result
mkdir result

echo "Tracing..."
./cairo-vm/target/release/cairo1-run fibonacci.cairo \
    --proof_mode \
    --layout=small \
    --air_public_input=result/public_input.json \
    --air_private_input=result/private_input.json \
    --trace_file=result/trace.json \
    --memory_file=result/memory.json

echo "Proving..."
../../cpu_air_prover \
    --out_file=result/proof.json \
    --private_input_file=result/private_input.json \
    --public_input_file=result/public_input.json \
    --prover_config_file=cpu_air_prover_config.json \
    --parameter_file=cpu_air_params.json

echo "Verifying..."
../../cpu_air_verifier --in_file=result/proof.json 

echo "Successfully verified proof."
