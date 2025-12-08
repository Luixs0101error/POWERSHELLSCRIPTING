function Start-ProgressBar { #Explicación: Declara una función llamada Start-ProgressBar y abre su bloque de código.
    [CmdletBinding()] #Explicación: Habilita características avanzadas para la función (p. ej., manejo de parámetros y soporte para parámetros comunes).
    param ( #Explicación: Inicia la definición de los parámetros que recibirá la función.

        [Parameter(Mandatory = $true)] #Explicación: Indica que el siguiente parámetro es obligatorio.
        $Title, #Explicación: Parámetro texto para el título que se mostrará en la barra de progreso (actividad).
        
        [Parameter(Mandatory = $true)] #Explicación: Línea en blanco para legibilidad.
        [int]$Timer #Explicación: Parámetro entero que define el tiempo total en segundos que durará la barra de progreso.


    )#Explicación: Cierra el bloque param.
    
    for ($i = 1; $i -le $Timer; $i++) { #Explicación: Bucle que recorre cada segundo desde 1 hasta $Timer. Controla el avance del progreso.

        Start-Sleep -Seconds 1#Explicación: Detiene la ejecución durante 1 segundo en cada iteración del bucle.
        $percentComplete = ($i / $Timer) * 100 #Explicación: Calcula el porcentaje completado en base al tiempo transcurrido ($i) y el total ($Timer).


        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete
    }
} 

# Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30