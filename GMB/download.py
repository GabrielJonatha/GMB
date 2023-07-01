import requests

url = "https://drive.google.com/u/0/uc?id=1-HGNh73USFuheXhGZwYOCwZ75zs8aUMy&export=download"
output_file = "teste.txt"  # Nome do arquivo de saída

response = requests.get(url)
response.raise_for_status()

with open(output_file, "wb") as file:
    file.write(response.content)

print("Arquivo baixado com sucesso!")