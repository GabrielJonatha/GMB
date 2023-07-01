$url = "https://drive.google.com/u/0/uc?id=1-HGNh73USFuheXhGZwYOCwZ75zs8aUMy&export=download"
$outputFile = "teste.txt"  # Nome do arquivo de saída

$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $outputFile)

Write-Host "Arquivo baixado com sucesso!"