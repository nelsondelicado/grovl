# ◉ Grovl — v1

**Grovl** é uma aplicação de gestão e descoberta de colecções de discos de vinil. Combina catalogação completa via Discogs, sets de DJ gerados por inteligência artificial com reprodução automática em YouTube, e karaoke sincronizado com as letras em tempo real.

Tudo num único ficheiro HTML. Sem instalação. Sem servidor. Sem dependências locais.

---

## ✨ Funcionalidades

- **Gestão de colecção** — importa a tua colecção completa do Discogs com um clique; adiciona, edita e remove discos manualmente; pesquisa e filtra por artista, álbum, género ou ano
- **Sets de DJ por IA** — escolhe um disco da tua colecção e o Grovl gera automaticamente um set temático com sugestões de faixas relacionadas via YouTube; a faixa escolhida é sempre a primeira
- **Reprodução automática** — quando uma faixa termina, a próxima começa sozinha; em caso de falha avança automaticamente ao fim de 2 segundos
- **Navegação no player** — avança e recua entre faixas dentro do set
- **Inserção manual de faixas** — adiciona músicas entre as faixas do set gerado, colando um URL do YouTube ou pesquisando por título e artista
- **Karaoke sincronizado** — as letras acompanham a música em tempo real com animação de preenchimento progressivo linha a linha; fontes: lrclib.net, some-random-api, lyrics.ovh
- **Want list** — regista os discos que queres comprar com alertas e pesquisa integrada
- **Importação / Exportação JSON** — exporta a tua colecção como ficheiro `.json` e importa noutro dispositivo ou browser
- **Migração de dados** — os dados ficam no `localStorage` do browser e podem ser copiados entre dispositivos

---

## 🚀 Deploy (Cloudflare Pages — recomendado)

A forma mais rápida de publicar o Grovl com HTTPS, CDN global e plano gratuito.

1. Vai a [pages.cloudflare.com](https://pages.cloudflare.com) e cria uma conta gratuita
2. Clica em **Create a project → Direct Upload**
3. Dá um nome ao projecto (ex: `grovl`)
4. Faz upload dos dois ficheiros: **`index.html`** e **`Grovl.html`**
5. Clica em **Deploy site**

O Grovl fica disponível em `https://grovl.pages.dev` (ou o nome que escolheres).

> **Porquê HTTPS?** O HTTPS é obrigatório para o OAuth do YouTube e para o serviço de letras lrclib.net funcionar sem restrições de CORS.

---

## 💻 Correr localmente

> Com `file://` o browser usa o caminho completo do ficheiro como chave do `localStorage` — se moveres o ficheiro, perdes os dados. Usa sempre um servidor local.

### Mac / Linux

```bash
# Na pasta do projecto:
./start.sh           # inicia na porta 8082
./start.sh 3000      # porta personalizada
```

Ou directamente no terminal:

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

Os tokens e toda a colecção ficam guardados no `localStorage` neste URL. Enquanto usares sempre `http://localhost:8082` os dados persistem entre sessões.

---

## ⚙️ Configuração de APIs

### Discogs (obrigatório para importar a colecção)

1. Vai a [discogs.com/settings/developers](https://www.discogs.com/settings/developers)
2. Cria um **Personal Access Token**
3. No Grovl: **Settings → Discogs Token** → cola o token → Save

### YouTube Data API Key (para pesquisa e sets de DJ)

1. Vai a [console.cloud.google.com](https://console.cloud.google.com) e cria um projecto
2. **APIs & Services → Library** → pesquisa e activa **YouTube Data API v3**
3. **Credentials → Create Credentials → API Key**
4. No Grovl: **Settings → YouTube Data API Key** → cola a key → Save

### YouTube OAuth (opcional — para criar playlists no YouTube)

1. Google Cloud Console → **Credentials → Create Credentials → OAuth 2.0 Client ID**
2. Tipo: **Web application**
3. Em **Authorized redirect URIs** adiciona o URL do teu deploy (podes ter vários ao mesmo tempo):
   ```
   https://grovl.pages.dev/Grovl.html
   http://localhost:8082/Grovl.html
   ```
   > ⚠️ Os URLs têm de corresponder **exactamente** — incluindo o path `/Grovl.html` e sem barra no fim.
4. Copia o **Client ID** e o **Client Secret**
5. No Grovl: **Settings → YouTube OAuth Client ID + Secret** → Save
6. **OAuth consent screen → Test users → + Add users** → adiciona o teu Gmail

---

## 📦 Migrar dados entre dispositivos

Os dados (colecção, want list, sets de DJ) estão no `localStorage` do browser. Para migrar:

**No browser de origem** — abre a consola (F12) e corre:
```javascript
copy(localStorage.getItem('vv3'))
```

**No browser de destino** — abre a consola e corre:
```javascript
localStorage.setItem('vv3', '<cola aqui o conteúdo copiado>')
location.reload()
```

---

## 🗂️ Estrutura do projecto

```
Grovl.html      — aplicação completa (HTML + CSS + JS num único ficheiro)
index.html      — redireccionamento para Grovl.html (necessário para hosting)
start.sh        — servidor local para Mac/Linux
start.bat       — servidor local para Windows
```

---

## 🛠️ Notas técnicas

- **Sem dependências locais** — todo o código está no ficheiro HTML; CDNs (YouTube IFrame API, etc.) são carregados ao momento
- **Dados locais** — usa `localStorage` do browser (chave `vv3`); nenhum dado é enviado para servidores externos
- **Puramente client-side** — as APIs do Discogs e YouTube são chamadas directamente do browser
- **Karaoke** — usa CSS Houdini `@property` para animação nativa do gradiente de preenchimento, com `animation-delay` negativo para sincronização precisa à linha actual
- **Compatibilidade** — Chrome, Firefox, Safari, Edge (versões modernas)

---

## 📄 Licença

Projecto pessoal — todos os direitos reservados.
