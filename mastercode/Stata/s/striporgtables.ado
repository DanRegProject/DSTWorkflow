cap program drop striporgtables
program define striporgtables
// syntax : striporgtables using infile, savind(outfile)

version 16.0
syntax using/, SAVing(string) [wrap]

file open fin using "`using'", read text
file open fout using "`saving'", write text replace

file read fin line
while r(eof)==0{
    local line = subinstr("`line'", ",", "|", .)
    if "`wrap'" == "wrap" local line = "|" + "`line'" + "|"
    *local trimmed = strtrim("`line'")
        file write fout "`line'" _n
    }
    file read fin line
}
file close fin
file close fout
!"$EMACSDOWE" --batch "`saving'" --eval "(progn (require 'org) (org-table-map-tables 'org-table-align) (save-buffer))"

dis as txt "Done"
end
