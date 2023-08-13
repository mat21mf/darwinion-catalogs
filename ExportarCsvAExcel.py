# -*- coding: utf8 -*-
import sys, csv, xlsxwriter
import numpy as np
import pandas as pd
import pandas.io.formats.excel

#### Ejemplo
#### python ExportarCsvAExcel.py ArchivoCsv.csv ArchivoExcel.xlsx 30
#### Argumentos
#### sys.argv[1] : archivo csv
#### sys.argv[2] : archivo xlsx
#### sys.argv[3] : numero de columnas
#### Notas
#### Actualmente solo acepta nombre de archivos en el mismo directorio
#### Usa entorno anaconda con python 3.6

archivo_csv = pd.read_csv(sys.argv[1],sep='@', dtype={'codesp': object})

pandas.io.formats.excel.header_style = None
sheetnm = sys.argv[1].split(".")[0]
if len(sheetnm) >= 31:
    sheetnm = sheetnm[0:31]
numrow = len(archivo_csv)
writer = pd.ExcelWriter(sys.argv[2], engine='xlsxwriter')
archivo_csv.to_excel(writer, sheet_name=sheetnm, index=False)
workbook = writer.book
## workbook.formats[0].set_font_color('white')
## workbook.formats[0].set_bg_color('black')

# Formato
numcol = int(sys.argv[3])-1
worksheet = writer.sheets[str(sheetnm)]
worksheet.freeze_panes(1,0)
worksheet.autofilter(0,0,numrow,numcol)
# worksheet.set_column(0,0,8)
# worksheet.set_column(1,1,12)
# worksheet.set_column(2,2,20)
# worksheet.set_column(3,3,15)
# worksheet.set_column(4,4,15)
# worksheet.set_column(5,4,15)
# worksheet.set_column(6,4,15)
# worksheet.set_column(7,4,15)
# worksheet.set_column(8,4,15)
writer.save()
workbook.close()

