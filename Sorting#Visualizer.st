!classDefinition: #SortingVisualizerWindow category: #'Sorting Visualizer'!
SystemWindow subclass: #SortingVisualizerWindow
	instanceVariableNames: 'visualizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Sorting Visualizer'!

!SortingVisualizerWindow methodsFor: 'initialization' stamp: 'Ma 5/9/2026 21:42:24'!
initializeWithCollection: aCollection label: aLabel sortingBlock: aSortingBlock
    self setLabel: aLabel.
    visualizer := SortingVisualizerMorph withCollection: aCollection.
    self layoutMorph addMorph: visualizer layoutSpec: (LayoutSpec useAll).
    self openInWorld.
    visualizer startStepping.
    aSortingBlock value: visualizer.! !

!SortingVisualizerWindow methodsFor: 'initialization' stamp: 'Ma 5/9/2026 21:43:53'!
openInWorld
    super openInWorld.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SortingVisualizerWindow class' category: #'Sorting Visualizer'!
SortingVisualizerWindow class
	instanceVariableNames: ''!

!SortingVisualizerWindow class methodsFor: 'instance creation' stamp: 'Ma 5/9/2026 22:01:19'!
withBogoSort: aCollection

	^ self new 
        initializeWithCollection: aCollection 
        label: 'Bogo Sort' 
        sortingBlock: [:v | v bogoSortingVisualizer ].! !

!SortingVisualizerWindow class methodsFor: 'instance creation' stamp: 'Ma 5/9/2026 21:43:36'!
withBubbleSort: aCollection
    ^ self new 
        initializeWithCollection: aCollection 
        label: 'Bubble Sort' 
        sortingBlock: [:v | v bubbleSortingVisualizer].! !

!SortingVisualizerWindow class methodsFor: 'instance creation' stamp: 'Ma 5/9/2026 21:43:42'!
withMergeSort: aCollection
    ^ self new 
        initializeWithCollection: aCollection 
        label: 'Merge Sort' 
        sortingBlock: [:v | v mergeSortingVisualizer].! !


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


!SortingVisualizerMorph methodsFor: 'visualizer sorting' stamp: 'Ma 5/9/2026 21:58:29'!
bogoSortingVisualizer

	(self sortingVisualizerBlockWith: [self bogoSort]) fork.! !

!SortingVisualizerMorph methodsFor: 'visualizer sorting' stamp: 'Ma 5/9/2026 21:57:08'!
bubbleSortingVisualizer
    
	(self sortingVisualizerBlockWith: [self bubbleSort ]) fork.! !

!SortingVisualizerMorph methodsFor: 'visualizer sorting' stamp: 'Ma 5/9/2026 21:57:24'!
mergeSortingVisualizer

	(self sortingVisualizerBlockWith: [self mergeSort ]) fork.! !


!SortingVisualizerMorph methodsFor: 'steps' stamp: 'Ma 5/3/2026 15:53:18'!
step
	
    self redrawNeeded.
! !

!SortingVisualizerMorph methodsFor: 'steps' stamp: 'Ma 5/3/2026 15:53:33'!
stepTime

	^16.! !


!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/9/2026 22:10:26'!
isSorted
    1 to: collection size - 1 do: [ :i |
        comparations := comparations + 1.
        arrayAccess := arrayAccess + 2.
        (collection at: i) > (collection at: i + 1) ifTrue: [ ^ false ].
    ].
    ^ true.! !

!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/3/2026 15:00:01'!
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

!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/9/2026 21:38:56'!
merge: aCollection with: aAnotherCollection
    | merged rightIndex leftIndex |

    merged := OrderedCollection new.
    leftIndex := 1.
    rightIndex := 1.

    [ leftIndex <= aCollection size and: [ rightIndex <= aAnotherCollection size ] ]
        whileTrue: [
            comparations := comparations + 1.
            arrayAccess := arrayAccess + 2.
            (aCollection at: leftIndex) <= (aAnotherCollection at: rightIndex)
                ifTrue:  [ merged add: (aCollection at: leftIndex).
                           arrayAccess := arrayAccess + 1.
                           leftIndex := leftIndex + 1 ]
                ifFalse: [ merged add: (aAnotherCollection at: rightIndex).
                           arrayAccess := arrayAccess + 1.
                           rightIndex := rightIndex + 1 ].
            
            1 to: merged size do: [:i | collection at: i put: (merged at: i)].
            highlightingIndices := { merged size }.
            self redrawNeeded.
            (Delay forMilliseconds: 1) wait.
        ].

    leftIndex  to: aCollection size        do: [ :i | 
        merged add: (aCollection at: i).
        arrayAccess := arrayAccess + 1 ].
    rightIndex to: aAnotherCollection size do: [ :i | 
        merged add: (aAnotherCollection at: i).
        arrayAccess := arrayAccess + 1 ].

    ^ merged! !

!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/9/2026 21:33:14'!
mergeSort: aCollection

	| mid left right |
	    
	    aCollection size <= 1 ifTrue: [ ^ aCollection ].
	    
	    mid   := aCollection size // 2.
	    left  := aCollection copyFrom: 1 to: mid.
	    right := aCollection copyFrom: mid + 1 to: aCollection size.
	    
	    left  := self mergeSort: left.
	    right := self mergeSort: right.
	    
	    ^ self merge: left with: right! !

!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/9/2026 22:10:37'!
shuffle
    collection size to: 2 by: -1 do: [ :i |
        | j |
        j := (Random new next * i) truncated + 1.
        self swap: i with: j.
        arrayAccess := arrayAccess + 2.
    ].! !

!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/9/2026 21:56:23'!
sortingVisualizerBlockWith: aSortingBlock
    ^ [
        aSortingBlock value.
        SoundPlayer stopPlayingAll.
        self lastPassed.
    ]! !

!SortingVisualizerMorph methodsFor: 'private' stamp: 'Ma 5/9/2026 21:38:24'!
swap: i with: j
    
    collection swap: i with: j.
    highlightingIndices := {i. j}.
    
    "Pedimos redibujo"
    self redrawNeeded.
    
   
    
    (Delay forMilliseconds: 1 ) wait.! !


!SortingVisualizerMorph methodsFor: 'sorting' stamp: 'Ma 5/9/2026 22:03:41'!
bogoSort
    [ self isSorted ] whileFalse: [ self shuffle ].! !

!SortingVisualizerMorph methodsFor: 'sorting' stamp: 'Ma 5/9/2026 22:03:17'!
bubbleSort

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
        ]! !

!SortingVisualizerMorph methodsFor: 'sorting' stamp: 'Ma 5/9/2026 22:03:32'!
mergeSort
    
	collection := self mergeSort: collection! !


!SortingVisualizerMorph methodsFor: 'initialization' stamp: 'Ma 5/3/2026 15:39:54'!
initializeWith: aCollection
	
	self initialize .
	collection :=  aCollection .
	comparations := 0.
	arrayAccess := 0.
	highlightingIndices := OrderedCollection new.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SortingVisualizerMorph class' category: #'Sorting Visualizer'!
SortingVisualizerMorph class
	instanceVariableNames: ''!

!SortingVisualizerMorph class methodsFor: 'instance creation' stamp: 'Ma 5/9/2026 21:45:22'!
withCollection: aCollection
    ^ self new initializeWith: aCollection.! !
