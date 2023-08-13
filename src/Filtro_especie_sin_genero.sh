  declare -gx strcsv="/home/matbox/Documents/TrabajosExtra/petra-darwin/sofi01-correo/BBDD_RM_MNHN_preconsolidada_soloRMsineliminar_output_resultado_latin1.csv"

  gawk -F'@' 'NR>1 && $6=="" {
  if($5=="Adesmia"           ||
     $5=="Alstroemeria"      ||
     $5=="Anarthrophyllum"   ||
     $5=="Apium"             ||
     $5=="Avena"             ||
     $5=="Baccharis"         ||
     $5=="Calceolaria"       ||
     $5=="Cruckshanksia"     ||
     $5=="Cryptantha"        ||
     $5=="Ephedra"           ||
     $5=="Gilliesia"         ||
     $5=="Haplopappus"       ||
     $5=="Leucheria"         ||
     $5=="Montiopsis"        ||
     $5=="Nastanthus"        ||
     $5=="Oxalis"            ||
     $5=="Poa"               ||
     $5=="Retanilla"         ||
     $5=="Senecio"           )
  {print $5, $6, $7, $8, $9}}' ${strcsv} \
  | sort | uniq
