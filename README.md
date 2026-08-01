# Salto Infinito

Jogo mobile hyper-casual em **Flutter + Flame**: um toque = pular. O
personagem corre automaticamente e o jogador desvia de obstáculos gerados
proceduralmente. Pontuação por distância percorrida, dificuldade crescente.

Veja [`CLAUDE.md`](./CLAUDE.md) para a visão completa do projeto, stack,
roadmap de fases e regras de desenvolvimento.

## Status

- **Fase 0 — Setup:** concluída (projeto Flutter, Flame configurado, `.gitignore`).
- **Fase 1 — Protótipo jogável:** concluída (gravidade, pulo, spawn de
  obstáculos, colisão, game over, pontuação, recorde local).
- **Fase 2 — UI/UX:** concluída (HUD, tela de configurações, som on/off).
- **Fase 3 — Anúncios:** concluída (banner, intersticial, recompensado com
  IDs de TESTE do AdMob + consentimento UMP).
- **Fase 4 — Polimento:** concluída (efeitos sonoros curtos gerados
  proceduralmente, animações de squash-and-stretch no pulo/aterrissagem,
  flash de tela na colisão, balanceamento de dificuldade).
- **Fase 5 em diante:** ver roadmap no `CLAUDE.md`.

## Sons

Os efeitos sonoros (`assets/audio/*.wav`) são gerados proceduralmente
(tons sintéticos), não baixados de bancos externos — evita qualquer
dúvida de licenciamento. Se quiser trocá-los por sons de um banco CC0
(ex. freesound.org), substitua os arquivos em `assets/audio/` e confira a
licença de cada um antes de usar.

## Rodando localmente

```bash
flutter pub get
flutter run
```

## Testes

```bash
flutter test
flutter analyze
```

## Estrutura

```
lib/
  main.dart            # entrypoint, MaterialApp
  screens/             # telas (menu, jogo)
  game/                # lógica do jogo (Flame): player, obstáculos, game loop
  services/            # persistência local (recorde)
```
