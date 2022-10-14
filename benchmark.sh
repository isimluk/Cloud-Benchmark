#!/bin/bash
# Universal cloud provider provisioning calculator
# Identifies the current cloud provider, then downloads the necessary scripts
# to perform a sizing calculation.
#
# Creation date: 03.25.21, Joshua Hiller @ CrowdStrike
#

base_url=https://raw.githubusercontent.com/isimluk/Cloud-Benchmark/test/

audit(){
    CLOUD="$1"
    echo "This is ${CLOUD}"
    cloud=$(echo "$CLOUD" | tr '[:upper:]' '[:lower:]')

    curl -o requirements.txt "${base_url}/${CLOUD}/requirements.txt"
    python3 -m pip install -r requirements.txt
    file="${cloud}_cspm_benchmark.py"
    curl -o "${file}" "${base_url}/${CLOUD}/${file}"
    python3 "${file}"
}

python3 -m venv ./cloud-benchmark
pushd ./cloud-benchmark
source ./bin/activate

# MAIN ROUTINE
echo "Determining cloud provider"
if type aws >/dev/null 2>&1; then
    audit "AWS"
fi
if type az >/dev/null 2>&1; then
    audit Azure
fi

if type gcloud >/dev/null 2>&1; then
    audit GCP
fi

popd
deactivate

echo "Type following command to export cloud counts:"
echo "cat ./cloud-benchmark/*benchmark.csv"

# END
#
#       -''--.
#       _`>   `\.-'<
#    _.'     _     '._
#  .'   _.='   '=._   '.
#  >_   / /_\ /_\ \   _<    - jgs
#    / (  \o/\\o/  ) \
#    >._\ .-,_)-. /_.<
#       /__/ \__\ 
#          '---'     E=mc^2
#
#    
