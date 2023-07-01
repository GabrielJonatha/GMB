# Caminho para a pasta que contém as imagens dos meses
$pastaMeses = "C:\GMB"

# Obter o mês atual com base na data local do Windows
$mesAtual = Get-Date -Format "MMMM"

# Caminho completo para a imagem do mês atual
$arquivoImagem = Join-Path -Path $pastaMeses -ChildPath "$mesAtual.jpeg"

# Verificar se o arquivo de imagem do mês atual existe
if (Test-Path $arquivoImagem) {
    # Definir a nova imagem como papel de parede
    $SPI_SETDESKWALLPAPER = 0x0014
    $SPIF_UPDATEINIFILE = 0x01
    $SPIF_SENDCHANGE = 0x02

    # Função para definir a nova imagem como papel de parede
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

    # Definir a nova imagem como papel de parede
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $arquivoImagem, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

    Write-Host "O papel de parede para o mês atual foi definido com sucesso."
} else {
    Write-Host "O arquivo de imagem do mês atual não foi encontrado."
}