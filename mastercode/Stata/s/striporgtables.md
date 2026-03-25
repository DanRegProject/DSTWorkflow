# striporgfiles.md

striporgtables (Stata): extract and align Org‑mode tables from a text file

Overview
- striporgtables scans a plain‑text file and writes out only the lines that belong to Org‑mode tables (lines that begin with the pipe character |).
- Optionally, it can help convert delimited text into Org tables by wrapping lines with pipes.
- After writing the output, it calls Emacs in batch mode to run org-table-align on all tables, then saves the file.

Requirements
- Stata 16.0 or newer.
- GNU Emacs with Org mode (Org is bundled with Emacs).
- The operating system environment variable EMACSDOWE must point to the Emacs executable (or be set to emacs if it’s in your PATH).

Examples for EMACSDOWE:
- macOS/Linux (bash/zsh):
  export EMACSDOWE=emacs
- Windows (PowerShell):
  setx EMACSDOWE "C:\Program Files\Emacs\bin\runemacs.exe"

Syntax
striporgtables using infile, saving(outfile) [wrap]

- using infile: Path to the input text file.
- saving(outfile): Path to the output file that will contain the extracted/aligned Org tables. Required.
- wrap (optional): When specified, each line is wrapped with pipes (| ... |). This can be helpful when converting delimited text into an Org table before alignment.

What the program does
1) Opens infile for reading and outfile for writing.
2) Reads the input line by line.
   - By default, only lines that start with | are written to outfile (i.e., existing Org tables are extracted).
   - If wrap is specified, the program will add leading and trailing pipes to each processed line before alignment.
3) After writing, Emacs is executed in batch mode on outfile to align all Org tables:
   (org-table-map-tables 'org-table-align)
   The aligned file is then saved.
4) Displays: Done

Typical usage
- Extract all Org tables from notes.org and align them:
  . striporgtables using notes.org, saving(tables.org)

- Convert a delimited file into an Org‑style table and align it:
  . striporgtables using data.txt, saving(data_table.org) wrap

Notes and limitations
- The program focuses on lines that begin with | (Org table rows). Non‑table content is discarded in the output.
- The wrap option is a simple helper for table formatting; it does not perform robust CSV/TSV parsing (e.g., it won’t handle quoted delimiters).
- Ensure EMACSDOWE is set correctly and Emacs is installed; otherwise, the alignment step will fail.
- The program writes the output file with replace, overwriting any existing file of the same name.

Installation
- Save the program body as striporgtables.ado somewhere on your Stata ado‑path (e.g., PERSONAL).
- Verify EMACSDOWE is set and Emacs is accessible.
- In Stata, run:
  . which striporgtables
  to confirm Stata can find the ado file.

Exit status and messages
- On success, the command prints:
  Done
- If file paths are wrong or Emacs cannot be invoked, Stata will display the corresponding file or shell error.

Contributing
- Issues and pull requests are welcome. Please describe your environment (OS, Stata version, Emacs version) and include a minimal reproducible example of your input and expected output.

License
- Provide licensing terms for this repository (e.g., MIT/Apache‑2.0). If unspecified, this code is shared “as is.”