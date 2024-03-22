#!/usr/bin/env python3

import sys
import zipfile
import io

# ATTRIBUTION: Github Copilot 2024-03-20

def decompress_zip(input_zip):
    with zipfile.ZipFile(input_zip, 'r') as zip_ref:
        return {name: zip_ref.read(name) for name in zip_ref.namelist()}

def recompress_zip(output_zip, files):
    with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_STORED) as zipf:
        for name, data in files.items():
            zipf.writestr(name, data)

def main():
    input_zip = sys.argv[1]
    output_zip = sys.argv[2]

    with open(input_zip, 'rb') as f:
        files = decompress_zip(io.BytesIO(f.read()))

    output_data = io.BytesIO()
    recompress_zip(output_data, files)

    with open(output_zip, 'wb') as f:
        f.write(output_data.getvalue())

if __name__ == "__main__":
    main()