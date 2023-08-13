  strind="Indice_Especies.csv"
  strdar="Darwinion_no_encontradas.csv"

  dfmind <- read.csv( strind , header = TRUE , sep = '@' )
  dfmdar <- read.csv( strdar , header = TRUE , sep = '@' )

  colnames( dfmdar ) <- tolower( colnames( dfmdar ))
  dfmind$genero.especie <- paste( dfmind$genero , dfmind$especie )

  dfmmer <- merge( dfmdar , dfmind , by = 'genero.especie' , all.x = TRUE )
