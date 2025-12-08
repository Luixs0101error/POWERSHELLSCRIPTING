function Start-ProgressBar { #Explicación: Declara una función llamada Start-ProgressBar y abre su bloque de código.
    [CmdletBinding()] #Explicación: Habilita características avanzadas para la función (p. ej., manejo de parámetros y soporte para parámetros comunes).
    param ( #Explicación: Inicia la definición de los parámetros que recibirá la función.

        [Parameter(Mandatory = $true)] #Explicación: Indica que el siguiente parámetro es obligatorio.
        $Title, #Explicación: Parámetro texto para el título que se mostrará en la barra de progreso (actividad).
        
        [Parameter(Mandatory = $true)] #Explicación: Línea en blanco para legibilidad.
        [int]$Timer
    )
    
    for ($i = 1; $i -le $Timer; $i++) {
        Start-Sleep -Seconds 1
        $percentComplete = ($i / $Timer) * 100
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete
    }
} 

# Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30