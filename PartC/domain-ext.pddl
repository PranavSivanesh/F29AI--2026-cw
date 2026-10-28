(define (domain lunar-extended)
    ; Defining the PDDL features we need to use
    (:requirements :strips :typing :negative-preconditions)

    ; Things that we need to use in our simulation and defining them to data type object.
    (:types
        rover lander waypoint data sample astronaut room - object
    )

    ; The things that the planner uses to keep track of what's happening
    (:predicates
        (at ?r - rover ?w - waypoint) ; rover is at waypoint
        (where-lander ?l - lander ?w - waypoint) ; lander is at waypoint
        (connected ?from - waypoint ?to - waypoint) ; waypoint is connected to another waypoint
        (belongs-to ?r - rover ?l - lander) ; rover belongs to lander
        (deployed ?r - rover) ; rover is deployed

        (data-target ?d - data ?w - waypoint) ; data at waypoint
        (carrying-data ?r - rover ?d - data) ; rover is carrying data
        (transmitted ?d - data ?l - lander) ; data has been transmitted to lander
        (empty-memory ?r - rover) ; rover has empty memory

        (carrying-sample ?r - rover ?s - sample) ; rover is carrying a sample
        (sample-storage ?s - sample ?l - lander) ; sample is stored in lander
        (sample-at ?s - sample ?w - waypoint) ; sample is at waypoint
        (empty-hands ?r - rover) ; rover is empty handed
        (lander-empty ?l - lander) ; lander is empty

        (where-astronaut ?a - astronaut ?rm - room) ; astronaut at which room
        (assigned-to ?a - astronaut ?l - lander)    ; astronaut assigned to a lander
        (which-room ?rm - room ?l - lander)    ; which room the lander is in
        (is-control-room ?rm - room)    ; one room as control room
        (is-docking-bay ?rm - room)     ; one room as Docking Bay
    )

    ;-------------------moving astronaut-----------------
    ;actions allowing the astronaut to walk between rooms inside their assigned lander.
    (:action move-astronaut
        :parameters (?a - astronaut ?from - room ?to - room ?l - lander)
        :precondition (and 
            (assigned-to ?a ?l)             ;astronaut belongs to their lander
            (which-room ?from ?l)           ; starting room must be in the lander
            (which-room ?to ?l)             ; destination room also should be in the lander
            (where-astronaut ?a ?from)      ; the astronaut must be in the starting room
        )
        :effect (and 
            (where-astronaut ?a ?to)            ; astronaut arrives to a new room
            (not (where-astronaut ?a ?from))    ; astronaut is no longer in the old room
        )
    )
    ;---------- --------deploy action-------------------
    ; Action to get the rover out of the lander to start the mission
    (:action deploy
        :parameters (?r - rover ?l - lander ?w - waypoint)
        :precondition (and
            (not (deployed ?r)) ;rover is not deployed yet
            (belongs-to ?r ?l) ;rover belongs to lander
            (where-lander ?l ?w) ;lander is at waypoint
        )
        :effect (and
            (deployed ?r) ;rover is deployed
            (at ?r ?w) ;rover is at waypoint
        )
    )
;------------------move action----------------------
; actions defined for the movement of the rover.
    (:action move
        :parameters (?r - rover ?from - waypoint ?to - waypoint)
        :precondition (and
            (at ?r ?from) ;rover is at starting waypoint
            (connected ?from ?to) ;rover can move to destination waypoint
        )
        :effect (and
            (at ?r ?to) ;rover is at destination waypoint
            (not (at ?r ?from)) ;rover is no longer at starting waypoint
        )
    )
;----------------capture image action----------------
; actions defined for the movement of the rover.
    (:action capture-data
        :parameters (?r - rover ?w - waypoint ?d - data)
        :precondition (and
            (at ?r ?w) ;rover is at waypoint
            (empty-memory ?r) ;rover has empty memory
            (data-target ?d ?w) ; data is at the waypoint
        )
        :effect (and
            (not (empty-memory ?r)) ; memory is no longer empty
            (carrying-data ?r ?d) ;rover is now carrying captured data
        )
    )

;---------------sending the captured data back to the base---------------
; actions defined to send the data back to the base
    (:action transmit-data
        :parameters (?r - rover ?d - data ?l - lander ?a - astronaut ?rm - room)
        :precondition (and
            (belongs-to ?r ?l)  ;transmit data from a specific rover to the assigned lander
            (carrying-data ?r ?d) ;if the rover actually has the data
            (assigned-to ?a ?l) ; astronaut is assigned to their specific lander
            (which-room ?rm ?l) ; check the room inside the lander
            (is-control-room ?rm)   ; making sure the room is the Control Room
            (where-astronaut ?a ?rm)    ; astronaut must be in the control room to receive data
        )
        :effect (and
            (not (carrying-data ?r ?d)) ;if data removed from the rover
            (empty-memory ?r)    ;free up the memory of the rover for another scan
            (transmitted ?d ?l) ;mission achieved
        )
    )

;---------------collecting the sample from the ground-----------------
    (:action collect-sample
        :parameters (?r - rover ?s - sample ?w - waypoint)
        :precondition (and
            (at ?r ?w)  ;chk if rover is physically present at the waypoint
            (sample-at ?s ?w)   ;sample also at the same place of rover waypoint.
            (empty-hands ?r)    ;chk if rover is empty or no. (or else cant carry another sample)
        )
        :effect (and
            (not(sample-at ?s ?w))  ;sample removed from the ground
            (not(empty-hands ?r))   ;rover has a sample and is full and cannot carry another one
            (carrying-sample ?r ?s)   ;the rover is carring the data.
        )
    )

;---------------------store the sample in the assigned lander---------------
    (:action store-sample
        :parameters (?r - rover ?s - sample ?l - lander ?w - waypoint ?a - astronaut ?rm - room)
        :precondition (and
            (at ?r ?w)  ;rover must travel to the specified wayapoint
            (where-lander ?l ?w)   ;lander has to be at the same exact waypoint
            (carrying-sample ?r ?s)     ;the tove must be carrying the sample
            (belongs-to ?r ?l)      ;the rover can only store the sample in its assigned lander.
            (lander-empty ?l)       ;the lander needs to be free as it can store only one sample at a time.
            (assigned-to ?a ?l)     ; astronaut assigned to their specific lander
            (which-room ?rm ?l)     ; check the room inside the lander
            (is-docking-bay ?rm)    ; making sure the room is the Docking Bay
            (where-astronaut ?a ?rm)    ; astronaut must be in the Docking Bay to receive the rock.
        )
        :effect (and
            (not (carrying-sample ?r ?s))   ;the rover hands over the sample
            (empty-hands ?r)        ;the rover is now empty and free to pick up another sample.
            (not (lander-empty ?l))     ;the lander is not empty after receiving the sample from the rover.
            (sample-storage ?s ?l)      ;goal of storing the sample is a success.
        )
    )

)