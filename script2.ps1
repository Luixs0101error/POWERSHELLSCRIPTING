
Add-Type -AssemblyName System.Windows.Forms           # Carga el ensamblado de Windows Forms para poder crear ventanas y controles gráficos.
Add-Type -AssemblyName System.Drawing                 # Carga el ensamblado de Drawing para manejar tamaños, posiciones y estilos gráficos.

# Create form
$form = New-Object System.Windows.Forms.Form          # Crea una nueva instancia de un formulario (ventana).
$form.Text = "Input Form"                             # Establece el título de la ventana.
$form.Size = New-Object System.Drawing.Size(500,250)  # Define el tamaño del formulario (ancho=500, alto=250 píxeles).
$form.StartPosition = "CenterScreen"                  # Hace que la ventana aparezca centrada en la pantalla.

############# Define labels
$textLabel1 = New-Object System.Windows.Forms.Label   # Crea la primera etiqueta (Label).
$textLabel1.Text = "Input 1:"                         # Texto visible de la etiqueta 1.
$textLabel1.Left = 20                                 # Posición horizontal (X) de la etiqueta 1, en píxeles desde el borde izquierdo.
$textLabel1.Top = 20                                  # Posición vertical (Y) de la etiqueta 1, en píxeles desde el borde superior.
$textLabel1.Width = 120                               # Ancho de la etiqueta 1.

$textLabel2 = New-Object System.Windows.Forms.Label   # Crea la segunda etiqueta (Label).
$textLabel2.Text = "Input 2:"                         # Texto visible de la etiqueta 2.
$textLabel2.Left = 20                                 # Posición horizontal (X) de la etiqueta 2.
$textLabel2.Top = 60                                  # Posición vertical (Y) de la etiqueta 2.
$textLabel2.Width = 120                               # Ancho de la etiqueta 2.

$textLabel3 = New-Object System.Windows.Forms.Label   # Crea la tercera etiqueta (Label).
$textLabel3.Text = "Input 3:"                         # Texto visible de la etiqueta 3.
$textLabel3.Left = 20                                 # Posición horizontal (X) de la etiqueta 3.
$textLabel3.Top = 100                                 # Posición vertical (Y) de la etiqueta 3.
$textLabel3.Width = 120                               # Ancho de la etiqueta 3.

############# Textbox 1
$textBox1 = New-Object System.Windows.Forms.TextBox   # Crea la primera caja de texto (TextBox).
$textBox1.Left = 150                                  # Posición horizontal (X) del TextBox 1.
$textBox1.Top = 20                                    # Posición vertical (Y) del TextBox 1.
$textBox1.Width = 200                                 # Ancho del TextBox 1.

############# Textbox 2
$textBox2 = New-Object System.Windows.Forms.TextBox   # Crea la segunda caja de texto.
$textBox2.Left = 150                                  # Posición horizontal (X) del TextBox 2.
$textBox2.Top = 60                                    # Posición vertical (Y) del TextBox 2.
$textBox2.Width = 200                                 # Ancho del TextBox 2.

############# Textbox 3
$textBox3 = New-Object System.Windows.Forms.TextBox   # Crea la tercera caja de texto.
$textBox3.Left = 150                                  # Posición horizontal (X) del TextBox 3.
$textBox3.Top = 100                                   # Posición vertical (Y) del TextBox 3.
$textBox3.Width = 200                                 # Ancho del TextBox 3.

############# Default values
$defaultValue = ""                                    # Define un valor por defecto (cadena vacía) para las cajas de texto.
$textBox1.Text = $defaultValue                        # Asigna el valor por defecto al TextBox 1.
$textBox2.Text = $defaultValue                        # Asigna el valor por defecto al TextBox 2.
$textBox3.Text = $defaultValue                        # Asigna el valor por defecto al TextBox 3.

############# OK Button
$button = New-Object System.Windows.Forms.Button      # Crea un botón (Button).
$button.Left = 360                                    # Posición horizontal (X) del botón.
$button.Top = 140                                     # Posición vertical (Y) del botón.
$button.Width = 100                                   # Ancho del botón.
$button.Text = "OK"                                   # Texto visible del botón.

############# Button click event
$button.Add_Click({                                   # Registra un manejador de evento para el clic del botón.
    $form.Tag = @{                                    # Usa la propiedad Tag del formulario para guardar datos (un Hashtable).
        Box1 = $textBox1.Text                         # Guarda el texto introducido en el TextBox 1 con clave 'Box1'.
        Box2 = $textBox2.Text                         # Guarda el texto introducido en el TextBox 2 con clave 'Box2'.
        Box3 = $textBox3.Text                         # Guarda el texto introducido en el TextBox 3 con clave 'Box3'.
    }
    $form.Close()                                     # Cierra el formulario tras hacer clic.
})

############# Add controls
$form.Controls.Add($button)                           # Agrega el botón al formulario.
$form.Controls.Add($textLabel1)                       # Agrega la etiqueta 1 al formulario.
$form.Controls.Add($textLabel2)                       # Agrega la etiqueta 2 al formulario.
$form.Controls.Add($textLabel3)                       # Agrega la etiqueta 3 al formulario.
$form.Controls.Add($textBox1)                         # Agrega el TextBox 1 al formulario.
$form.Controls.Add($textBox2)                         # Agrega el TextBox 2 al formulario.
$form.Controls.Add($textBox3)                         # Agrega el TextBox 3 al formulario.

############# Show dialog
$form.ShowDialog() | Out-Null                         # Muestra el formulario como diálogo modal; 'Out-Null' suprime el resultado del método.

############# Return values
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3 # Devuelve los valores capturados (como arreglo) de las tres cajas de texto.
