<#
  Actualizar-Indice.ps1
  Regenera el indice (dossier-data.js) escaneando la carpeta del Dossier.
  Ejecutalo cada vez que agregues o quites documentos.

  USO (cualquiera de estas opciones):
   - Clic derecho sobre este archivo  ->  "Ejecutar con PowerShell"
   - O en PowerShell:  cd a esta carpeta y luego:  .\Actualizar-Indice.ps1
  Si Windows bloquea la ejecucion, abre PowerShell y ejecuta una vez:
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#>

$ErrorActionPreference = "Stop"
$webDir   = $PSScriptRoot
$rootDir  = Split-Path $webDir -Parent           # carpeta del Dossier (donde esta index.html)
$rootName = Split-Path $rootDir -Leaf

$excludeDirs  = @("_dossier_web")
$excludeFiles = @("index.html","README.md",".gitignore","desktop.ini","Thumbs.db","ehthumbs.db","LEEME.txt")
$viewable     = @("pdf","png","jpg","jpeg","gif","webp","svg","bmp","txt","html","htm")

function Get-NatKey([string]$s){
    # clave de orden natural: rellena numeros a 8 digitos
    return [regex]::Replace($s.ToLower(), '\d+', { param($m) $m.Value.PadLeft(8,'0') })
}
function Human([long]$n){
    $u=@("B","KB","MB","GB","TB"); $i=0; $v=[double]$n
    while($v -ge 1024 -and $i -lt 4){ $v/=1024; $i++ }
    if($i -eq 0){ return "$n B" }
    return ("{0:N1} {1}" -f $v,$u[$i])
}
function JsonStr([string]$s){
    if($null -eq $s){ return '""' }
    $s = $s -replace '\\','\\' -replace '"','\"' -replace "`r",'' -replace "`n",'\n' -replace "`t",'\t'
    return '"' + $s + '"'
}

# Devuelve @{ json = "..."; nfiles = N }
function Walk([string]$absDir, [string[]]$relParts){
    $items = Get-ChildItem -LiteralPath $absDir -Force | Where-Object { -not $_.PSIsContainer -or $true }
    $dirs  = @($items | Where-Object { $_.PSIsContainer -and ($excludeDirs -notcontains $_.Name) -and -not $_.Name.StartsWith('.') })
    $files = @($items | Where-Object { -not $_.PSIsContainer -and ($excludeFiles -notcontains $_.Name) -and -not $_.Name.StartsWith('.') })
    $dirs  = $dirs  | Sort-Object { Get-NatKey $_.Name }
    $files = $files | Sort-Object { Get-NatKey $_.Name }

    $parts = New-Object System.Collections.Generic.List[string]
    $total = 0
    foreach($d in $dirs){
        $sub = Walk $d.FullName ($relParts + $d.Name)
        $total += $sub.nfiles
        $node = '{"name":' + (JsonStr $d.Name) + ',"type":"folder","nfiles":' + $sub.nfiles + ',"children":' + $sub.json + '}'
        $parts.Add($node)
    }
    foreach($f in $files){
        $ext = ''
        if($f.Name.Contains('.')){ $ext = ($f.Extension.TrimStart('.')).ToLower() }
        $rel = ($relParts + $f.Name) -join '/'
        $isView = ($viewable -contains $ext)
        $node = '{"name":' + (JsonStr $f.Name) + ',"type":"file","path":' + (JsonStr $rel) +
                ',"ext":' + (JsonStr $ext) + ',"size":' + $f.Length +
                ',"sizeh":' + (JsonStr (Human $f.Length)) +
                ',"viewable":' + ($(if($isView){'true'}else{'false'})) + '}'
        $parts.Add($node)
        $total += 1
    }
    return @{ json = '[' + ($parts -join ',') + ']'; nfiles = $total }
}

Write-Host "Escaneando: $rootDir" -ForegroundColor Cyan
$result   = Walk $rootDir @()
$stamp    = (Get-Date).ToString("dd/MM/yyyy HH:mm")

# imagenes de fondo (carpeta _dossier_web\bg)
$imgExt = @("jpg","jpeg","png","webp","gif","bmp")
$bgDir  = Join-Path $webDir "bg"
$bgs    = New-Object System.Collections.Generic.List[string]
if(Test-Path $bgDir){
    Get-ChildItem -LiteralPath $bgDir -File | Sort-Object { Get-NatKey $_.Name } | ForEach-Object {
        $e = ($_.Extension.TrimStart('.')).ToLower()
        if($imgExt -contains $e){ $bgs.Add((JsonStr ("_dossier_web/bg/" + $_.Name))) }
    }
}
$bgJson   = '[' + ($bgs -join ',') + ']'

$payload  = '{"generated":' + (JsonStr $stamp) + ',"totalFiles":' + $result.nfiles +
            ',"backgrounds":' + $bgJson + ',"tree":' + $result.json + '}'
$js       = "window.DOSSIER_DATA = $payload;`n"

$out = Join-Path $webDir "dossier-data.js"
[System.IO.File]::WriteAllText($out, $js, [System.Text.UTF8Encoding]::new($false))

Write-Host "OK - Indice actualizado: $($result.nfiles) documentos." -ForegroundColor Green
Write-Host "Archivo: $out"
Write-Host "Abre (o recarga) index.html para ver los cambios."
