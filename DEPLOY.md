# VinylVault — Deployment Guide

VinylVault é uma app de página única (single-file SPA). O único ficheiro necessário é `VinylVault.html`.

---

## 💻 Correr localmente (recomendado para desenvolvimento)

> **Porquê um servidor local e não abrir o ficheiro directamente?**
> Com `file://` o browser usa o caminho completo do ficheiro como chave para o `localStorage` — se moveres o ficheiro, perdes todos os dados. Além disso, o YouTube OAuth **não funciona** sem `http://`.

### Mac / Linux

```bash
# Na pasta do projecto:
./start.sh           # inicia na porta 8082
./start.sh 3000      # porta personalizada
```

Se o script não abrir, abre o terminal na pasta e corre:
```bash
python3 -m http.server 8082
```

### Windows

Faz duplo-clique em **`start.bat`** — abre o servidor e o browser automaticamente.

Ou no PowerShell / CMD:
```cmd
python -m http.server 8082
```

### URL local

```
http://localhost:8082
```

Os tokens e toda a colecção ficam guardados no `localStorage` do browser neste URL. Enquanto usares sempre `http://localhost:8082` os dados persistem entre sessões.

### YouTube OAuth em localhost

Para o OAuth do YouTube funcionar localmente, tens de registar o URL local no Google Cloud Console:

1. Vai a **Google Cloud Console → Credentials → o teu OAuth 2.0 Client ID**
2. Em **Authorized redirect URIs** adiciona:
   ```
   http://localhost:8082/VinylVault.html
   ```
3. Guarda. O VinylVault detecta automaticamente o URL onde está a correr — não precisas de mudar nada na app.

> 💡 Podes ter os dois URIs registados em simultâneo: o do Netlify e o do localhost.

---

## 🚀 Deploy no Netlify (configuração actual)

**URL do projecto:** `https://rainbow-wisp-de0cdd.netlify.app/`

A pasta já inclui um `netlify.toml` que:
- Serve `VinylVault.html` na raiz (`/`) sem precisar de renomear o ficheiro
- Define os headers HTTP correctos para os embeds do YouTube e chamadas às APIs

### Como actualizar o deploy:
1. Vai a [app.netlify.com/drop](https://app.netlify.com/drop)
2. Arrasta **toda a pasta** do projecto (deve conter `VinylVault.html` + `netlify.toml`)
3. O Netlify vai substituir o deploy existente

---

## Outros serviços de hosting

| Serviço | Como fazer |
|---|---|
| **GitHub Pages** | Push `VinylVault.html` para um repo público → Settings → Pages → Deploy from branch |
| **Netlify Drop** | Arrasta a pasta do projecto para [app.netlify.com/drop](https://app.netlify.com/drop) |
| **Cloudflare Pages** | Cria um novo projecto → faz upload directo do ficheiro |
| **Vercel** | `npx vercel --yes` na pasta do projecto |

---

## Configuração de APIs

### Discogs
1. Vai a [discogs.com/settings/developers](https://www.discogs.com/settings/developers)
2. Cria um **Personal Access Token**
3. Na app: Settings → Discogs Token → cola o token → Save

### YouTube API Key (para pesquisa e DJ Sets)
1. [console.cloud.google.com](https://console.cloud.google.com) → cria um projecto
2. **APIs & Services → Library** → pesquisa e activa **"YouTube Data API v3"**
3. **Credentials → Create Credentials → API Key**
4. Na app: Settings → YouTube Data API Key → cola a key → Save

### YouTube OAuth (para criação de playlists — opcional)
1. Google Cloud Console → **Credentials → Create Credentials → OAuth 2.0 Client ID**
2. Tipo: **Web application**
3. Em **Authorized redirect URIs** adiciona **ambos** os URLs (podes ter os dois ao mesmo tempo):
   ```
   https://rainbow-wisp-de0cdd.netlify.app/VinylVault.html
   http://localhost:8082/VinylVault.html
   ```
   > ⚠️ Os URLs têm de corresponder **exactamente** — incluindo o path `/VinylVault.html` e sem barra no fim. A app detecta automaticamente onde está a correr.
4. Copia o **Client ID** e o **Client Secret**
5. Na app: Settings → YouTube OAuth Client ID + Secret → Save
6. **OAuth consent screen → Test users → + Add users** → adiciona o teu Gmail

---

## Notas técnicas

- **Sem dependências locais** — todo o código está no ficheiro HTML; CDNs (Tesseract.js, Google APIs) são carregados ao momento conforme necessário
- **Dados guardados localmente** — usa `localStorage` do browser (chave `vv3`); os dados ficam no browser, não em nenhum servidor
- **Sem servidor necessário** — app puramente client-side (Discogs API + YouTube API são chamadas directamente do browser)
- **HTTPS obrigatório** — necessário para o OAuth do YouTube e para os iframes do YouTube funcionarem sem restrições; o Netlify garante HTTPS automaticamente
- **Compatibilidade** — Chrome, Firefox, Safari, Edge (versões modernas)

---

## Migrar dados entre dispositivos

Os dados (coleção, wantlist, DJ sets) estão no `localStorage` do browser. Para migrar:

1. No browser antigo: abre a consola (F12) e corre:
   ```javascript
   copy(localStorage.getItem('vv3'))
   ```
2. No novo browser/dispositivo, abre a consola e corre:
   ```javascript
   localStorage.setItem('vv3', '<cola aqui o conteúdo copiado>')
   location.reload()
   ```
