
  function HtmlToJson ()
  {
    find ./html/ -type f -regextype posix-extended -regex '\.\/html\/[0-9]{6}\.html' | sort |
    gawk '{printf("cat %s | pup '\''table json{}'\'' > %s\n", $0, $0)}' |
    gawk 'BEGIN{FS=OFS=" "} {gsub( /html/ , "json" , $8) ; print $0}' > ${1}
   #sed -r 's/\.\/(.*)\/(.*)\.(.*)/cat \1\/\2\.\3 | pup '\''table json{}'\'' > json\/\2\.json/' > ${1}
  }
  export -f HtmlToJson

  function ParallelHtmlToJson ()
  {
    parallel       --block -1 --pipepart -a ${1} LANG=C bash
  }
  export -f ParallelHtmlToJson

  function ExtraerTablaDarwinionEspecie ()
  {
    jq       -f ./jq/ExtraerTablaEspecie.jq ${1} |
    jq -s -r -f ./jq/JsonToCsv.jq
  }
  export -f ExtraerTablaDarwinionEspecie

  function ApilarTablaDarwinionEspecie ()
  {
    find ./json/ -type f -regextype posix-extended -regex '\.\/json\/[0-9]{6}\.json' | sort |
    gawk '{printf("ExtraerTablaDarwinionEspecie %s\n", $0)}'              | bash |
    gawk 'BEGIN{FS=OFS="@"} NR==1 {gsub(/col_[0-9]{2}_/,"",$0) ; print $0} NR>1 && !/col_[0-9]{2}_/ {print $0}' > ${1}
  }
  export -f ApilarTablaDarwinionEspecie

