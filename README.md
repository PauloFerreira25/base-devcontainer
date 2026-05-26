# base-devcontainer

Template de devcontainer para novos projetos.

## Como usar

Execute o comando abaixo no terminal, substituindo `/path/to/target` pelo caminho do projeto de destino:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/PauloFerreira25/base-devcontainer/main/scaffold.sh) /path/to/target
```

O script irá:
- Buscar os arquivos do template diretamente deste repositório
- Copiar tudo para o projeto de destino, substituindo `base-devcontainer` pelo nome do projeto
- Perguntar antes de sobrescrever qualquer arquivo já existente

## O que é copiado

Todos os arquivos trackeados no repositório, exceto os listados em `.scaffoldignore` (os arquivos meta do próprio template: `scaffold.sh`, `README.md`, `.scaffoldignore`).

Para adicionar novos arquivos ao template, basta adicioná-los ao repositório — o scaffold os incluirá automaticamente.
