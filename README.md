# ◉ Grovl

**Grovl** é uma aplicação de gestão e descoberta de colecções de discos de vinil. Combina catalogação completa via Discogs, sets de DJ gerados por inteligência artificial com reprodução automática em YouTube, e karaoke sincronizado com letras em tempo real.

Tudo num único ficheiro HTML. Sem instalação. Sem servidor. Sem dependências locais.

🔗 **[Abrir Grovl](https://nelsondelicado.github.io/grovl/Grovl.html)**

---

## ✨ Funcionalidades

### 📀 Colecção
- Importa a colecção completa do Discogs com um clique
- Adiciona, edita e remove discos manualmente
- Pesquisa e filtra por artista, álbum, género ou ano
- Tracklists obtidas automaticamente via Discogs
- Classificação pessoal por estrelas e notas

### 🎧 DJ Sets
- Gera sets temáticos com IA a partir de qualquer disco da colecção
- A faixa escolhida entra sempre em primeiro
- Inserção manual de faixas por URL YouTube ou pesquisa por título/artista
- Reprodução automática sequencial — ao terminar, avança sozinho
- Navegação entre faixas (⏮ ⏭) e autoplay configurável

### 🎤 Karaoke
- Letras sincronizadas em tempo real com animação progressiva linha a linha
- Cascade de APIs em paralelo para máxima velocidade e cobertura:
  - **Tier 1 (simultâneo):** lrclib.net (4 estratégias, LRC sincronizado) + textyl.co
  - **Tier 2 (simultâneo):** some-random-api + lyrics.ovh (texto simples com timing estimado)
- Re-sincronização automática quando a duração real da faixa é conhecida
- Disponível nos Sets de DJ e no Player do Catálogo
- Botão "↺ Tentar novamente" quando as letras não são encontradas

### 📺 YouTube
- Pesquisa automática de vídeos por álbum com scoring inteligente (8 resultados avaliados)
- Link manual — cola um URL do YouTube ou ID de vídeo directamente no detail view
- Player incorporado no Catálogo por álbum
- Criação de playlists YouTube (requer conta Google ligada)

### 🔑 Credenciais
- Export/Import de credenciais para ficheiro `.json` local — nunca precisas de voltar a introduzir
- Backup completo da colecção + settings num único ficheiro

### 📋 Want List
- Regista os discos que queres comprar com notas e alertas

---

## 🚀 Deploy no GitHub Pages

O Grovl está alojado no GitHub Pages em HTTPS — o único requisito para OAuth YouTube e lrclib funcionar sem restrições de CORS.

Para actualizar depois de editar o `Grovl.html`:

1. Vai a [github.com/nelsondelicado/grovl](https://github.com/nelsondelicado/grovl)
2. Clica em **Add file → Upload files**
3. Arrasta o `Grovl.html` para a área de upload
4. Clica em **Commit changes**

O site actualiza em ~30 segundos em `https://nelsondelicado.github.io/grovl/Grovl.html`.

---

## 💻 Correr localmente

> Com `file://` o browser usa o caminho completo como chave do `localStorage` — se moveres o ficheiro, perdes os dados. Usa sempre um servidor local.

### Mac / Linux

```bash
# Na pasta do projecto:
./start.sh           # inicia na porta 8082
./start.sh 3000      # porta personalizada
```

Ou directamente:

```bash
python3 -m http.server 8082
```

### Windows

Duplo-clique em **`start.bat`** — abre servidor e browser automaticamente.

Ou no PowerShell / CMD:

```cmd
python -m http.server 8082
```

### URL local

```
http://localhost:8082
```

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
4. (Opcional) Restringe a key à YouTube Data API v3
5. No Grovl: **Settings → YouTube Data API Key** → cola a key → Save

### YouTube OAuth (opcional — para criar playlists no YouTube)

1. Google Cloud Console → **Credentials → Create Credentials → OAuth 2.0 Client ID**
2. Tipo: **Web application**
3. Em **Authorized redirect URIs** adiciona o URL exacto do deploy:
   ```
   https://nelsondelicado.github.io/grovl/Grovl.html
   http://localhost:8082/Grovl.html
   ```
   > ⚠️ Os URLs têm de corresponder **exactamente** — incluindo o path e sem barra no fim.
4. Copia o **Client ID** e o **Client Secret**
5. No Grovl: **Settings → YouTube OAuth Client ID + Secret** → Save
6. **OAuth consent screen → Test users → + Add users** → adiciona o teu Gmail

### Guardar credenciais localmente

No Grovl: **Settings → Credentials Backup → 🔑 Export Credentials** — guarda um ficheiro `grovl-credentials.json` que podes importar em qualquer browser.

---

## 📦 Migrar dados entre dispositivos

**Opção 1 — Export/Import (recomendado)**

No Grovl: **Settings → 💾 Export Everything** → guarda um `.json` com tudo (colecção + settings).  
No dispositivo de destino: **Settings → 📥 Import Collection** → selecciona o ficheiro.

**Opção 2 — localStorage manual**

No browser de origem, abre a consola (F12):
```javascript
copy(localStorage.getItem('vv3'))
```

No browser de destino:
```javascript
localStorage.setItem('vv3', '<cola aqui>')
location.reload()
```

---

## 🗂️ Estrutura do projecto

```
Grovl.html          — aplicação completa (HTML + CSS + JS num único ficheiro)
index.html          — redireccionamento para Grovl.html
start.sh            — servidor local Mac/Linux
start.bat           — servidor local Windows
GROVL-ROADMAP.md    — roadmap de funcionalidades futuras
```

---

## 🛠️ Notas técnicas

- **Sem dependências locais** — todo o código está no ficheiro HTML; CDNs carregados em runtime
- **Dados locais** — `localStorage` do browser (chave `vv3`); nenhum dado enviado para servidores externos
- **Puramente client-side** — as APIs do Discogs e YouTube são chamadas directamente do browser
- **Karaoke** — CSS Houdini `@property` para animação nativa do gradiente, `animation-delay` negativo para sincronização precisa; APIs de letras em paralelo por tier para minimizar latência
- **YouTube scoring** — `ytSearchAlbum` avalia 8 resultados com pontuação por título, artista, canal e keywords; `ytSearchDJTrack` idem para faixas individuais
- **Compatibilidade** — Chrome, Firefox, Safari, Edge (versões modernas)

---

## 📄 Licença

Projecto pessoal — todos os direitos reservados.
