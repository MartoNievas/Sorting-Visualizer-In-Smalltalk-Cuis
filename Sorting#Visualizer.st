
!classDefinition: #SortingVisualizerWindow category: #'Sorting Visualizer'!
SystemWindow subclass: #SortingVisualizerWindow
	instanceVariableNames: 'visualizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Sorting Visualizer'!

!SortingVisualizerWindow methodsFor: 'initialization' stamp: 'Ma 5/3/2026 14:30:11'!
initializeWithCollection: aCollection
    
    self setLabel: 'Sorting Visualizer'.
    visualizer := SortingVisualizerMorph with: aCollection.
    
    "Esto hace que el visualizador se expanda para llenar la ventana"
    self layoutMorph
        addMorph: visualizer
        layoutSpec: (LayoutSpec useAll).! !

!SortingVisualizerWindow methodsFor: 'initialization' stamp: 'Ma 5/3/2026 11:49:54'!
openInWorld

	super openInWorld.
	self layoutMorph submorphs first bubbleSort.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SortingVisualizerWindow class' category: #'Sorting Visualizer'!
SortingVisualizerWindow class
	instanceVariableNames: ''!

!SortingVisualizerWindow class methodsFor: 'instance creation' stamp: 'Ma 5/3/2026 11:18:47'!
with: aCollection

	^self new initializeWithCollection: aCollection .! !


!classDefinition: #SortingVisualizerMorph category: #'Sorting Visualizer'!
BoxMorph subclass: #SortingVisualizerMorph
	instanceVariableNames: 'collection highlightingIndices comparations arrayAccess'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Sorting Visualizer'!

!SortingVisualizerMorph methodsFor: 'drawing' stamp: 'Ma 5/3/2026 14:50:48'!
drawIn: aCanvas thisString: textoAMostrar inPosition: aPosition

	^ aCanvas 
    drawString: textoAMostrar
    at: aPosition 
    font: nil 
    color: Color black! !

!SortingVisualizerMorph methodsFor: 'drawing' stamp: 'Ma 5/3/2026 14:51:23'!
drawOn: aCanvas

    | barWidth maxVal w h |
	    aCanvas fillRectangle: self localBounds color: Color white.
		super drawOn: aCanvas .

    w := self morphExtent x.
    h := self morphExtent y.
    
    (w = 0 or: [h = 0]) ifTrue: [ ^self ].
    collection ifEmpty: [ ^self ].
    
    maxVal := collection max.
    barWidth := w / (collection size).
    
    collection withIndexDo: [ :val :index |
        | barHeight x y color|
        barHeight := (val / maxVal) * h.
        x := (index - 1) * barWidth.
        y := h - barHeight.

	"Logica del color"
	color := (highlightingIndices  includes: index ) ifTrue: [
			Color red.
		] ifFalse: [Color blue].	
        
        aCanvas fillRectangle: (x @ y extent: barWidth @ barHeight)
                color: color.
        aCanvas frameRectangle: (x @ y extent: barWidth @ barHeight)
                borderWidth: 1
                color: Color black.
    ].
"Dibujamos comparciones"


self drawIn: aCanvas thisString: ('Comparaciones: ', (comparations  printString ))  inPosition:  (0@0);
	drawIn: aCanvas thisString: ('Accesos a Coleccion: ', (arrayAccess printString )) inPosition: (0@20).
! !


!SortingVisualizerMorph methodsFor: 'auxiliar' stamp: 'Ma 5/3/2026 14:54:11'!
swap: i with: j
    
    collection swap: i with: j.
    highlightingIndices := {i. j}.
    
    "Sonido simple"
    Beeper beep.
    "Pedimos redibujo"
    self redrawNeeded.
    
    "FORZAMOS EL CAMBIO DE CONTEXTO"
    "Esto hace que tu algoritmo se pause y la UI se despierte"
    Processor yield.
    
    (Delay forMilliseconds: 1 )wait.! !


!SortingVisualizerMorph methodsFor: 'sorting' stamp: 'Ma 5/3/2026 14:46:30'!
bubbleSort
    [
        | n |
        n := collection size.
        
        1 to: n do: [:i |
            1 to: n - i do: [:j |
			arrayAccess  := arrayAccess + 2.
			comparations := comparations + 1.
                (collection at: j) > (collection at: (j + 1)) ifTrue: [
                    self swap: j with: j + 1.
			arrayAccess  := arrayAccess + 4.
                ].
            ].
        ].
	
	SoundPlayer stopPlayingAll .
	
        "Pasada final de color"
        self lastPassed .
    ] fork.! !

!SortingVisualizerMorph methodsFor: 'sorting' stamp: 'Ma 5/3/2026 14:52:58'!
lastPassed

	highlightingIndices := OrderedCollection new.
        1 to: (collection size) do: [:i |
            highlightingIndices addLast: i.
            self redrawNeeded.
            
            
            Processor yield. 
            (Delay forMilliseconds: 1) wait.
        ].

        highlightingIndices := OrderedCollection new.
        self redrawNeeded! !


!SortingVisualizerMorph methodsFor: 'steps' stamp: 'Ma 5/3/2026 13:05:20'!
step
	
	self invalidateBounds .! !

!SortingVisualizerMorph methodsFor: 'steps' stamp: 'Ma 5/3/2026 14:54:37'!
stepTime

	^0.! !


!SortingVisualizerMorph methodsFor: 'initialization' stamp: 'Ma 5/3/2026 14:45:48'!
initializeWith: aCollection
	
	self initialize .
	collection :=  aCollection .
	comparations := 0.
	arrayAccess := 0.
	highlightingIndices := OrderedCollection new.
	self startStepping .
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SortingVisualizerMorph class' category: #'Sorting Visualizer'!
SortingVisualizerMorph class
	instanceVariableNames: ''!

!SortingVisualizerMorph class methodsFor: 'instance creation' stamp: 'Ma 5/3/2026 11:34:06'!
with: aCollection

	^self new initializeWith: aCollection .! !
(Smalltalk at: #qq__ ifAbsentPut: [OrderedCollection new]) add: (#(54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 115 112 117 124 127 61 59 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 115 112 117 124 127 61 59 54 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 62 61 59 56 53 112 116 104 110 108 17 124 117 112 127 17 83 112 117 124 127 39 61 53 56 64 53 56 59 52 104 121 106 111 56 52 56 17 127 63 61 102 61 59 17 86 119 108 117 39 90 116 104 115 115 123 104 115 114 39 74 118 110 98 90 119 124 121 100 39 93 84 39 98 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 100 17 95 56 56 17 92 117 112 127 39 105 124 112 115 123 39 118 117 39 86 106 123 39 39 62 39 57 55 57 60 39 56 59 65 55 63 65 57 62 39 74 118 116 119 112 115 108 121 65 39 60 53 59 53 55 39 57 55 56 61 55 61 55 64 17 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 86 106 123 39 39 62 39 57 55 57 60 17 83 112 125 108 91 128 119 112 117 110 74 118 110 112 123 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 86 106 123 39 39 62 39 57 55 57 60 17 93 84 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 39 75 104 123 108 65 39 84 118 117 39 86 106 123 39 61 39 56 57 65 58 59 65 57 56 39 57 55 57 60 39 74 118 116 116 112 123 79 104 122 111 65 39 108 107 58 60 59 63 61 39 87 115 124 110 112 117 122 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 17 199 175 8 20 17 56 64 57 53 56 61 63 53 56 53 56 58 17 104 121 106 111 115 112 117 124 127 52 107 108 122 114 123 118 119 17 104 121 106 111 115 112 117 124 127 52 107 108 122 114 123 118 119 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 59 52 57 64 91 57 55 65 58 64 65 57 64 53 61 55 56 58 57 64 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 52 56 74 54 80 90 94 52 87 104 121 106 112 104 115 56 52 56 74 57 60 53 122 123 17 57 55 57 62 59 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 56 91 56 56 65 59 64 65 57 59 53 57 61 55 60 56 59 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 52 56 74 54 80 90 94 52 87 104 121 106 112 104 115 56 52 56 74 57 60 53 122 123 17 57 59 62 60 60 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 56 91 56 56 65 59 64 65 58 59 53 56 62 62 61 59 57 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 52 56 74 54 80 90 94 52 87 104 121 106 112 104 115 56 52 56 74 57 60 53 122 123 17 57 59 62 60 60 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 58 91 56 59 65 55 61 65 59 55 53 58 57 62 62 58 61 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 122 118 121 123 112 117 110 52 125 112 122 124 104 115 112 129 108 121 54 90 118 121 123 112 117 110 42 93 112 122 124 104 115 112 129 108 121 53 122 123 17 56 57 64 63 56 17 52 52 52 52 52 52 52 52 52 52 17 17 52 52 52 52 52 52 52 52 52 52 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 59 52 57 62 91 56 64 65 60 59 65 58 59 53 55 63 61 58 57 63 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 54 122 118 115 124 106 112 118 117 52 119 104 121 106 112 104 115 53 122 123 17 56 63 55 56 60 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 59 52 57 62 91 56 64 65 60 60 65 55 63 53 56 61 56 61 64 57 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 54 57 55 57 60 52 57 74 52 56 108 121 87 104 121 106 112 104 115 52 122 118 115 124 106 112 118 117 52 119 104 121 106 112 104 115 53 122 123 17 56 63 55 56 60 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 59 52 57 63 91 56 58 65 58 56 65 60 57 53 55 63 55 62 60 57 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 57 55 57 60 52 57 74 52 56 108 121 87 104 121 106 112 104 115 53 122 123 17 57 58 63 61 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 59 52 57 63 91 56 58 65 59 61 65 60 63 53 61 60 58 63 60 64 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 54 57 55 57 60 52 57 74 52 56 108 121 87 104 121 106 112 104 115 52 122 118 115 124 106 112 118 117 52 106 118 117 80 109 122 53 122 123 17 57 58 64 57 61 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 56 91 56 58 65 59 63 65 60 59 53 64 58 59 58 61 59 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 80 90 94 52 87 104 121 106 112 104 115 56 52 56 74 57 60 53 122 123 17 58 61 61 58 64 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 56 91 56 60 65 57 62 65 55 59 53 55 63 64 56 61 56 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 106 124 121 122 104 107 104 52 57 55 57 61 54 112 122 126 54 119 121 112 116 108 121 118 122 52 119 104 121 106 112 104 115 108 122 54 57 55 57 60 52 56 74 54 80 90 94 52 87 104 121 106 112 104 115 56 52 56 74 57 60 52 122 118 115 124 106 112 118 117 53 122 123 17 59 56 63 64 60 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 58 91 56 59 65 60 60 65 55 55 53 58 64 59 59 64 57 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 122 118 121 123 112 117 110 52 125 112 122 124 104 115 112 129 108 121 46 54 90 118 121 123 112 117 110 42 93 112 122 124 104 115 112 129 108 121 53 122 123 17 60 57 58 61 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 60 52 55 58 91 56 59 65 60 61 65 55 63 53 62 56 64 59 59 62 52 55 58 65 55 55 17 54 111 118 116 108 54 116 104 121 123 112 117 54 108 122 106 121 112 123 118 121 112 118 54 90 118 121 123 112 117 110 42 93 112 122 124 104 115 112 129 108 121 53 122 123 17 60 57 58 61 17 52 52 52 52 52 52 52 52 52 52 17 17))!
