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
- **Fase 2 em diante:** ver roadmap no `CLAUDE.md`.

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
