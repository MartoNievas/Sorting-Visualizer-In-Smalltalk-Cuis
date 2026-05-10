# Sorting Visualizer

Visualizador de algoritmos de ordenamiento implementado en **Cuis Smalltalk** usando Morphic.

## ¿Qué hace?

Muestra una animación en tiempo real de algunos algoritmos de ordenamiento sobre una colección de números, representados como barras verticales. Las barras que se están comparando/intercambiando se resaltan en **rojo**, mientras que el resto se muestran en **azul**.

## Estructura

- **`SortingVisualizerWindow`** — Ventana principal que contiene el visualizador. Hereda de `SystemWindow`.
- **`SortingVisualizerMorph`** — Morph encargado del dibujo y la lógica de animación. Hereda de `BoxMorph`.

## Uso

Abrí un Workspace en Cuis y ejecutá:

```smalltalk
SortingVisualizerWindow withBubbleSort: (1 to: 50) asOrderedCollection shuffled.
SortingVisualizerWindow withMergeSort: (1 to: 50) asOrderedCollection shuffled.
SortingVisualizerWindow withMergeSort: (1 to: 3) asOrderedCollection shuffled .
```

Podés cambiar el tamaño de la colección o usar cualquier colección de números.

## Detalles técnicos

- El ordenamiento corre en un **proceso separado** (`fork`) para no bloquear la UI.
- Se usa `step` / `stepTime` para mantener el redibujado activo sin necesidad de input del usuario.
- `redrawNeeded` notifica a Morphic que debe llamar a `drawOn:` en el próximo ciclo.
- `Processor yield` cede el control entre swaps para que la UI pueda redibujar.

## Requisitos

- Cuis Smalltalk 6.x o superior

## Referecencias

[Video de Daniel Hirsch](https://www.youtube.com/watch?v=bm-UnFrLajU)

[Video de Salar en C++ POO](https://www.youtube.com/watch?v=VkA0J5al4rA&t=115s)
