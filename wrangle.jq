def jqpath:
  def t: test("^[A-Za-z_][A-Za-z0-9_]*$");
  reduce .[] as $x
    ("";
     if ($x|type) == "string"
     then . + ($x | if t then ".\(.)" else  ".[" + tojson + "]" end)
     else . + "[\($x)]"
     end);

def farchivo:
  input_filename | split("/")[1] | split(".")[0];

def longitud:
  [paths as $path | select( getpath($path) == "Sinónimos:" ) | $path | {
    archivo   : input_filename ,
    sinonimos : jqpath
  }] | length;

if (longitud != 0) then (
    [paths as $path | select( getpath($path) == "Sinónimos:" ) | $path | {
      archivo   : input_filename ,
      sinonimos : jqpath
    }]
  ) else (
    [{
      archivo   : input_filename ,
      sinonimos : null
    }]
  ) end

# [paths as $path | select( getpath($path) == "Referencias Bibliográficas Argentina:" ) | $path | jqpath]
