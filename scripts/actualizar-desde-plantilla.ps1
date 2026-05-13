# actualizar-desde-plantilla.ps1
# Ejecutar DENTRO del directorio del proyecto cliente.
# Trae cambios de carloscvb/astrowind (seguridad, deps, fixes).
# Uso: .\scripts\actualizar-desde-plantilla.ps1

$plantilla = "https://github.com/carloscvb/astrowind.git"

# Verificar que estamos en un repo git
if (-not (Test-Path ".git")) {
    Write-Host "Error: ejecutar desde la raiz del proyecto." -ForegroundColor Red
    exit 1
}

# Verificar upstream configurado
$remotes = git remote
if ($remotes -notcontains "upstream") {
    Write-Host "upstream no configurado. Añadiendo..." -ForegroundColor Yellow
    git remote add upstream $plantilla
}

# Verificar working tree limpio
$status = git status --porcelain
if ($status) {
    Write-Host "Error: hay cambios sin commitear. Haz commit o stash primero." -ForegroundColor Red
    git status --short
    exit 1
}

Write-Host "`n[1/4] Obteniendo cambios de la plantilla..." -ForegroundColor Cyan
git fetch upstream
if ($LASTEXITCODE -ne 0) { Write-Host "Error al fetch upstream." -ForegroundColor Red; exit 1 }

# Mostrar qué commits vienen
$nuevos = git log --oneline HEAD..upstream/main
if (-not $nuevos) {
    Write-Host "Proyecto ya esta al dia con la plantilla." -ForegroundColor Green
    exit 0
}

Write-Host "`nCommits nuevos de la plantilla:" -ForegroundColor Yellow
git log --oneline HEAD..upstream/main
Write-Host ""

$confirmar = Read-Host "¿Aplicar estos cambios? (s/n)"
if ($confirmar -ne "s") { Write-Host "Cancelado." -ForegroundColor Yellow; exit 0 }

Write-Host "[2/4] Mergeando plantilla..." -ForegroundColor Cyan
git merge upstream/main --no-edit
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nHay conflictos. Resuelvelos manualmente:" -ForegroundColor Red
    Write-Host "  - Priorizar TUS cambios en: config.yaml, navigation.ts, index.astro" -ForegroundColor Yellow
    Write-Host "  - Priorizar PLANTILLA en: componentes, utils, deps" -ForegroundColor Yellow
    Write-Host "Tras resolver: git add . && git commit" -ForegroundColor Yellow
    exit 1
}

Write-Host "[3/4] Actualizando dependencias..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) { Write-Host "Error en npm install." -ForegroundColor Red; exit 1 }

Write-Host "[4/4] Verificando..." -ForegroundColor Cyan
npm run check
if ($LASTEXITCODE -ne 0) {
    Write-Host "Check con errores. Revisar antes de pushear." -ForegroundColor Yellow
    exit 1
}

Write-Host "`nActualizacion completada. Verifica visualmente y luego: git push origin main`n" -ForegroundColor Green
