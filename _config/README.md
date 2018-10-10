Rare cases (eg. network information for standalone SSH use) may make it undesirable to pull configuration data from a separate file (ie. "ops"), necessitating "hardcoding" of information within the monolithic shell script output.

Place relevant files here to be hardcoded in at compile time, and update the compile script if necessary.

Keep in mind, even such hardcoded configuration information may still be treated as defaults to be overridden by "ops".

DANGER: Do NOT place files with names or paths identical to internal ubiquitous_bash scripts, unless intending to override these files!
