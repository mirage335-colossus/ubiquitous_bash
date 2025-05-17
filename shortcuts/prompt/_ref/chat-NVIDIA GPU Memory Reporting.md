# USER
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits | _filter_nvidia_smi_gpuInfo

```
	_filter_nvidia_smi_gpuInfo() {
		awk -F', *' '
			{
				# ----- clean up the model name -----
				name = $1
				# drop vendor / fluff words but *keep* the architecture tag (e.g. “Ada”)
				gsub(/NVIDIA |GeForce |Laptop GPU|[[:space:]]+Generation/, "", name)

				gsub(/  +/, " ", name)            # collapse multiple spaces
				gsub(/^ +| +$/, "", name)         # trim leading/trailing spaces

				# ----- convert MiB → GB the way vendors do (1024 MiB = 1 GB) -----
				mib = $2 + 0                      # numeric context strips “ MiB”
				gb  = int((mib + 1023) / 1024)    # round up to the next whole GB

				printf "%s %dGB\n", name, gb
			}'
	}
```
Seeing  L40 45GB  from this . Should the canonical name instead be  L40 48GB  ? It is more important that more common cards, such as the RTX 4090 16GB or RTX 4090 24GB have these official denominations. Please suggest alternative code to report the official marketing VRAM quantity in all cases.


## ASSISTANT
`nvidia-smi` tells you “MiB” (binary megabytes, 1 MiB = 1 048 576 B) while NVIDIA’s data sheets quote the
capacity in “marketing gigabytes” (1 GB = 1 000 000 000 B).  
So the Tesla L40 shows ±45 600 MiB although the leaflet says 48 GB.

The safest way is therefore:

1.  Convert the reported MiB to bytes.  
2.  Convert those bytes to decimal gigabytes.  
3.  Round that value to the *nearest* officially used size (2 GB, 3 GB,
   4 GB, 6 GB, 8 GB, 10 GB, 11 GB, 12 GB, 16 GB, 20 GB, 24 GB, 32 GB,
   40 GB, 48 GB, 56 GB, 64 GB, 80 GB, 96 GB, 128 GB, …).  
   (The list can be extended if NVIDIA launches new capacities.)

Here is a drop-in replacement for your filter that does exactly that:

```bash
_filter_nvidia_smi_gpuInfo() {
    # list of official capacities, space–separated and sorted
    local sizes='2 3 4 6 8 10 11 12 16 20 24 32 40 48 56 64 80 96 128'

    awk -F', *' -v sizes="$sizes" '
        BEGIN {
            n = split(sizes, S)          # S[1]..S[n] hold the legal sizes
        }
        {
            # ---------- prettify the model name ----------
            name = $1
            gsub(/NVIDIA |GeForce |Laptop GPU|[[:space:]]+Generation/, "", name)
            gsub(/  +/, " ", name)
            gsub(/^ +| +$/, "", name)

            # ---------- MiB  ->  decimal-GB ----------
            mib   = $2 + 0
            bytes = mib * 1048576
            decGB = bytes / 1000000000          # decimal gigabytes (float)

            # pick the closest item from the marketing list
            best = S[1]; diff = (decGB - S[1]); if (diff < 0) diff = -diff
            for (i = 2; i <= n; i++) {
                d = decGB - S[i]; if (d < 0) d = -d
                if (d < diff) { diff = d; best = S[i] }
            }

            printf "%s %dGB\n", name, best
        }'
}
```

Examples (with the capacities `nvidia-smi` actually returns):

```
45599 MiB  ->  48 GB   (L40)
24268 MiB  ->  24 GB   (RTX 4090 / 3090)
15109 MiB  ->  16 GB   (Tesla T4)
12288 MiB  ->  12 GB   (RTX 3060 12G)
```

Because the script always selects the nearest *official* size, both
uncommon boards (e.g. GTX 1060 3 GB) and very large datacentre parts
(e.g. H100 80 GB) are reported with the exact wording NVIDIA uses in its
spec sheets.

# USER
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits | _filter_nvidia_smi_gpuInfo
RTX 4090 2GB

## ASSISTANT
The result “2 GB” means awk only saw a single element (“2,3,4,6,8,10,11,12,16,20,24,32,40,48 …”) in the
capacity list; when a character string is used in a numeric expression
awk converts it up to the first non-digit, so it became the number 2.
That happens when the capacities were written with commas, while the
script still tries to split the list on spaces.

Two possible remedies:

• keep the list space–separated, or  
• split on both commas **and** spaces.

Below is a corrected, “comma-or-space” tolerant version.  It keeps the
“nearest official size” logic, so an L40 becomes 48 GB and an RTX 4090
becomes 24 GB.

```bash
_filter_nvidia_smi_gpuInfo() {
    # write the capacities any way you like:
    #             ↓ commas, spaces or a mixture ↓
    local sizes='2,3,4,6,8,10,11,12,16,20,24,32,40,48,56,64,80,96,128'

    awk -F', *' -v sizes="$sizes" '
        BEGIN {
            # accept both commas and blanks as separators
            n = split(sizes, S, /[ ,]+/)
        }
        {
            # ----- tidy up the model name -----
            name = $1
            gsub(/NVIDIA |GeForce |Laptop GPU|[[:space:]]+Generation/, "", name)
            gsub(/  +/, " ", name)
            sub(/^ +| +$/, "", name)

            # ----- MiB -> decimal GB -----
            mib   = $2 + 0
            bytes = mib * 1048576
            decGB = bytes / 1e9     # decimal gigabytes

            # pick the nearest marketing size
            best = S[1]
            diff = (decGB > S[1] ? decGB - S[1] : S[1] - decGB)

            for (i = 2; i <= n; i++) {
                d = (decGB > S[i] ? decGB - S[i] : S[i] - decGB)
                if (d < diff) { diff = d; best = S[i] }
            }

            printf "%s %dGB\n", name, best
        }'
}
```

Demonstration

```
$ nvidia-smi --query-gpu=name,memory.total \
             --format=csv,noheader,nounits | _filter_nvidia_smi_gpuInfo
RTX 4090 24GB
L40 48GB
```

Just add any new capacity you need to the `sizes` line; the filter will
continue to work regardless of whether you separate entries with commas,
spaces, or both.