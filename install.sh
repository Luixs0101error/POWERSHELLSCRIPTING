# Prerequisites

# Update the list of packages Explicación: Refresca los índices de paquetes disponibles desde los repositorios configurados.

sudo apt-get update

# Install pre-requisite packages.Explicación: Instala herramientas requeridas:
#wget para descargar archivos,
#apt-transport-https para usar repos HTTPS,
#software-properties-common para gestionar repositorios adicionales

sudo apt-get install -y wget apt-transport-https software-properties-common

# Get the version of Ubuntu Explicación: Carga variables del sistema (como VERSION_ID) en el entorno actual para usarlas en comandos posteriores.
source /etc/os-release

# Download the Microsoft repository keys Explicación: Descarga el paquete .deb que configura los repositorios oficiales de Microsoft para tu versión de Ubuntu.
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys Explicación: Instala el paquete para añadir los repositorios y claves de firma de Microsoft a APT.
sudo dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository keys file Explicación: Limpia el archivo descargado ya que no se necesita después de instalarlo.
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com  Explicación: Vuelve a actualizar los índices para incluir los paquetes disponibles desde el nuevo repositorio de Microsoft.
sudo apt-get update

###################################
# Install PowerShell Instala Powershell
sudo apt-get install -y powershell

# Start PowerShell Inicia Poweshell
pwsh