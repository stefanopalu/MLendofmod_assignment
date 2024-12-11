#!/bin/bash
urls=(
    "https://data.london.gov.uk/download/london-atmospheric-emissions-inventory--laei--2019/f2129345-06d4-4d3d-8304-d65fcdeb118e/LAEI2019-nox-pm-co2-major-roads-link-emissions.zip"
    "https://data.london.gov.uk/download/london-atmospheric-emissions-inventory--laei--2019/17d21cd1-892e-4388-9fea-b48c1b61ee3c/LAEI-2019-Emissions-Summary-including-Forecast.zip"
    "https://data.london.gov.uk/download/london-atmospheric-emissions-inventory--laei--2019/3a00296b-c88b-4de0-8336-b127034cc07b/laei-2019-major-roads-vkm-flows-speeds.zip"
    "https://data.london.gov.uk/download/london-atmospheric-emissions-inventory--laei--2019/f9f70e47-5683-4430-86e2-ffa2a50b31b1/LAEI2019-Concentrations-Data-CSV.zip"
)

for url in "${urls[@]}"; do
    filename=$(basename "$url" .zip)
    final_file="datasets/$filename.xlsx"

    if [ -f "$final_file" ]; then
        echo "File $filename.xlsx already exists, skipping download."
        continue
    fi

    curl -L -o "datasets/$filename.zip" \
        -H "Accept-Encoding: gzip" \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
        --http2 \
        "$url"

    if [ ! -s "datasets/$filename.zip" ]; then
        echo "Error: Failed to download $url"
        continue
    fi

    unzip -o "datasets/$filename.zip" -d datasets
    rm "datasets/$filename.zip"
done

if [ -d "datasets/LAEI2019-Concentrations-Data-CSV" ]; then
        mv datasets/LAEI2019-Concentrations-Data-CSV/* datasets/
        rmdir datasets/LAEI2019-Concentrations-Data-CSV
fi

