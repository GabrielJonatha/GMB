# URL do Google Drive para a pasta que contém as imagens dos meses
$urlPastaImagens = "https://drive.google.com/drive/folders/1VJcmyx_AWzy2zuUm0njCEdQqF_Abn8gw"

# Caminho para a pasta local que armazena as imagens dos meses
$pastaMeses = "C:\GMB"

# Obter lista de arquivos no diretório local
$arquivosLocais = Get-ChildItem -Path $pastaMeses -Filter "*.jpeg"

# Obter lista de arquivos no diretório do Google Drive
$urlPastaImagensHtml = Invoke-WebRequest -Uri $urlPastaImagens
$arquivosRemotos = $urlPastaImagensHtml.Links | Where-Object { $_.href -like "*uc?id=*" } | ForEach-Object { "https://drive.google.com/uc?id=$($_.href.Split('=')[1])" }

# Excluir arquivos locais que correspondem aos arquivos remotos
foreach ($arquivoLocal in $arquivosLocais) {
    $arquivoRemoto = $arquivosRemotos | Where-Object { $_ -like "*$($arquivoLocal.BaseName)*" }
    if (-not $arquivoRemoto) {
        $arquivoLocal | Remove-Item -Force
    }
}

# Baixar arquivos remotos que não existem localmente
foreach ($arquivoRemoto in $arquivosRemotos) {
    $nomeArquivo = $arquivoRemoto.Split("/")[-1]
    $caminhoArquivo = Join-Path -Path $pastaMeses -ChildPath $nomeArquivo

    if (-not (Test-Path $caminhoArquivo)) {
        Invoke-WebRequest -Uri $arquivoRemoto -OutFile $caminhoArquivo
    }
}

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
