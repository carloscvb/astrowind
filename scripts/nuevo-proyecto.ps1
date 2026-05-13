# nuevo-proyecto.ps1
# Uso: .\scripts\nuevo-proyecto.ps1 -nombre "nombre-proyecto" -repo "carloscvb/nombre-proyecto"
# Ejemplo: .\scripts\nuevo-proyecto.ps1 -nombre "landing-cliente-x" -repo "carloscvb/landing-cliente-x"

param(
    [Parameter(Mandatory=$true)]
    [string]$nombre,

    [Parameter(Mandatory=$true)]
    [string]$repo
)

$plantilla = "https://github.com/carloscvb/astrowind.git"
$destino   = "https://github.com/$repo.git"
$raiz      = Split-Path -Parent $PSScriptRoot  # directorio donde está la plantilla
$proyectos = Split-Path -Parent $raiz          # directorio padre (Proyectos)
$target    = Join-Path $proyectos $nombre

Write-Host "`n[1/5] Clonando plantilla en '$target'..." -ForegroundColor Cyan
git clone $plantilla $target
if ($LASTEXITCODE -ne 0) { Write-Host "Error al clonar." -ForegroundColor Red; exit 1 }

Set-Location $target

Write-Host "[2/5] Configurando remotes..." -ForegroundColor Cyan
git remote set-url origin $destino
git remote add upstream $plantilla
git remote -v

Write-Host "[3/5] Instalando dependencias..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) { Write-Host "Error en npm install." -ForegroundColor Red; exit 1 }

Write-Host "[4/5] Verificando proyecto..." -ForegroundColor Cyan
npm run check
if ($LASTEXITCODE -ne 0) { Write-Host "Advertencia: check con errores, revisar." -ForegroundColor Yellow }

Write-Host "[5/5] Push inicial a origin..." -ForegroundColor Cyan
Write-Host "IMPORTANTE: Crea el repo '$repo' en GitHub antes de continuar." -ForegroundColor Yellow
$confirmar = Read-Host "¿Ya creaste el repo en GitHub? (s/n)"
if ($confirmar -eq "s") {
    git push -u origin main
    Write-Host "`nProyecto '$nombre' listo." -ForegroundColor Green
    Write-Host "Directorio: $target" -ForegroundColor Green
    Write-Host "Próximo paso: edita src/config.yaml con los datos del cliente.`n" -ForegroundColor Green
} else {
    Write-Host "`nCrea el repo en GitHub y luego ejecuta: git push -u origin main" -ForegroundColor Yellow
}
