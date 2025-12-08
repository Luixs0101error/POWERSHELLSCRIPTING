
# Declara una función llamada Start-ProgressBar y abre su bloque de código.
function Start-ProgressBar {
    # Habilita características avanzadas para la función (manejo de parámetros y soporte para parámetros comunes).
    [CmdletBinding()]

    # Inicia la definición de los parámetros que recibirá la función.
    param (
        # Indica que el siguiente parámetro es obligatorio.
        [Parameter(Mandatory = $true)]
        # Parámetro texto para el título que se mostrará en la barra de progreso (actividad).
        [string]$Title,

        # Indica que el siguiente parámetro es obligatorio.
        [Parameter(Mandatory = $true)]
        # Parámetro entero que define el tiempo total en segundos que durará la barra de progreso.
        [int]$Timer
    )

    # Bucle que recorre cada segundo desde 1 hasta $Timer. Controla el avance del progreso.
    for ($i = 1; $i -le $Timer; $i++) {
        # Detiene la ejecución durante 1 segundo en cada iteración del bucle.
        Start-Sleep -Seconds 1

        # Calcula el porcentaje completado en base al tiempo transcurrido ($i) y el total ($Timer).
        $percentComplete = ($i / $Timer) * 100

        # Muestra la barra de progreso en la consola:
        # - Activity $Title: título de la tarea.
        # - Status "$i seconds elapsed": mensaje de estado (segundos transcurridos).
        # - PercentComplete $percentComplete: porcentaje que avanza la barra.
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete
    }
}

# Llamar a la función
Start-ProgressBar -Title "Test timeout" -Timer 30
