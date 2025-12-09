
function New-FolderCreation {                         # Define una función llamada New-FolderCreation.
    [CmdletBinding()]                                 # Activa características avanzadas de cmdlet (como conjuntos de parámetros).
    param(                                            # Inicio del bloque de parámetros.
        [Parameter(Mandatory = $true)]                # Indica que este parámetro es obligatorio.
        [string]$foldername                           # Nombre de la carpeta a crear (tipo texto).
    )

    # Create absolute path for the folder relative to current location
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername   # Une la ruta actual con el nombre de la carpeta para obtener la ruta completa.
    if (-not (Test-Path -Path $logpath)) {            # Si la ruta NO existe...
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null       # Crea la carpeta; -Force evita errores y Out-Null oculta la salida.
    }

    return $logpath                                   # Devuelve la ruta absoluta de la carpeta creada/asegurada.
}

function Write-Log {                                  # Define la función principal Write-Log.
    [CmdletBinding()]                                 # Activa características avanzadas de cmdlet.
    param(                                            # Inicio del bloque de parámetros.
        # Create parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]         # Parámetro obligatorio cuando usas el conjunto 'Create'.
        [Alias('Names')]                               # Alias alternativo: puedes usar -Names en vez de -Name.
        [object]$Name,                                 # Puede ser un solo nombre (string) o un arreglo de nombres.

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]         # Extensión de archivo (ejemplo: log, txt), obligatoria en 'Create'.
        [string]$Ext,

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]         # Carpeta donde se guardarán los archivos, obligatoria en 'Create'.
        [string]$folder,

        [Parameter(ParameterSetName = 'Create', Position = 0)]              # Interruptor (switch) que selecciona el conjunto 'Create'.
        [switch]$Create,

        # Message parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]        # Texto del mensaje a escribir, obligatorio en 'Message'.
        [string]$message,

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]        # Ruta del archivo donde se escribirá el mensaje, obligatoria en 'Message'.
        [string]$path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]       # Severidad del mensaje (opcional) dentro del conjunto 'Message'.
        [ValidateSet('Information','Warning','Error')]                      # Restringe la severidad a uno de estos valores.
        [string]$Severity = 'Information',                                  # Valor por defecto: Information.

        [Parameter(ParameterSetName = 'Message', Position = 0)]             # Interruptor que selecciona el conjunto 'Message'.
        [switch]$MSG
    )

    switch ($PsCmdlet.ParameterSetName) {            # Selecciona qué bloque ejecutar según el conjunto de parámetros usado.
        "Create" {                                   # Bloque para crear archivos de log.
            $created = @()                           # Inicializa un arreglo para guardar las rutas de archivos creados.

            # Normalize $Name to an array
            $namesArray = @()                        # Crea un arreglo temporal para los nombres.
            if ($null -ne $Name) {                   # Si se proporcionó Name...
                if ($Name -is [System.Array]) { $namesArray = $Name }       # Si ya es arreglo, úsalo directamente.
                else { $namesArray = @($Name) }       # Si es un solo valor, conviértelo en arreglo de 1 elemento.
            }

            # Date + time formatting (safe for filenames)
            $date1 = (Get-Date -Format "yyyy-MM-dd") # Obtiene la fecha en formato seguro para nombres de archivo (AAAA-MM-DD).
            $time  = (Get-Date -Format "HH-mm-ss")   # Obtiene la hora en formato seguro para nombres de archivo (HH-mm-ss).

            # Ensure folder exists and get absolute folder path
            $folderPath = New-FolderCreation -foldername $folder             # Crea/asegura la carpeta y obtiene su ruta completa.

            foreach ($n in $namesArray) {            # Recorre cada nombre solicitado.
                # sanitize name to string
                $baseName = [string]$n               # Asegura que el nombre sea tipo texto.

                # Build filename
                $fileName = "${baseName}_${date1}_${time}.$Ext"              # Construye el nombre del archivo con fecha y hora.

                # Full path for file
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName # Une la carpeta con el nombre de archivo para obtener la ruta completa.

                # Create the file (New-Item -Force will create or overwrite; use -ErrorAction Stop to catch errors)
                try {                                   # Intenta crear el archivo y captura errores si ocurren.
                    # If you prefer to NOT overwrite existing file, use: if (-not (Test-Path $fullPath)) { New-Item ... }
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null  # Crea (o sobrescribe) el archivo; oculta la salida.

                    # Optionally write a header line (uncomment if desired)
                    # "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append  # (Opcional) agrega una línea de encabezado.

                    $created += $fullPath              # Agrega la ruta creada al arreglo de resultados.
                }
                catch {
                    Write-Warning "Failed to create file '$fullPath' - $_"   # Muestra una advertencia si falla la creación del archivo.
                }
            }

            return $created                            # Devuelve las rutas de todos los archivos creados.
        }

        "Message" {                                    # Bloque para escribir un mensaje dentro de un archivo existente o nuevo.
            # Ensure directory for message file exists
            $parent = Split-Path -Path $path -Parent   # Obtiene la carpeta padre de la ruta del archivo.
            if ($parent -and -not (Test-Path -Path $parent)) {               # Si la carpeta padre no existe...
                New-Item -Path $parent -ItemType Directory -Force | Out-Null # Crea la carpeta; oculta la salida.
            }

            $date = Get-Date                           # Obtiene fecha y hora actuales.
            $concatmessage = "|$date| |$message| |$Severity|"                # Forma la línea de log con fecha, mensaje y severidad.

            switch ($Severity) {                       # Muestra el mensaje en consola con color según la severidad.
                "Information" { Write-Host $concatmessage -ForegroundColor Green }   # Verde para información.
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }  # Amarillo para advertencia.
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }     # Rojo para error.
            }

            # Append message to the specified path (creates file if it does not exist)
            Add-Content -Path $path -Value $concatmessage -Force            # Agrega el mensaje al archivo (lo crea si no existe).

            return $path                                # Devuelve la ruta del archivo donde se escribió el mensaje.
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"     # Error si se usó un conjunto de parámetros no reconocido.
        }
    }
}

# ---------- Example usage ----------
# This will create the folder "logs" (if missing) and create a file Name-Log_YYYY-MM-DD_HH-mm-ss.log
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create    # Ejemplo: crea la carpeta 'logs' y un archivo con fecha/hora; devuelve su ruta.

$logPaths        # Para recorrer cada ruta: $logPaths | ForEach-Object { $_ }
