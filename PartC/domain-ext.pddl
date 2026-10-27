(define (domain lunar-extended)
    (:requirements :strips :typing :negative-preconditions)

    (:types
        rover lander waypoint data sample astronaut room - object
    )

    (:predicates
        (at ?r - rover ?w - waypoint)
        (where-lander ?l - lander ?w - waypoint)
        (connected ?from - waypoint ?to - waypoint)
        (belongs-to ?r - rover ?l - lander)
        (deployed ?r - rover)

        (data-target ?d - data ?w - waypoint)
        (carrying-data ?r - rover ?d - data)
        (transmitted ?d - data ?l - lander)
        (empty-memory ?r - rover)

        (carrying-sample ?r - rover ?s - sample)
        (sample-storage ?s - sample ?l - lander)
        (sample-at ?s - sample ?w - waypoint)
        (empty-hands ?r - rover)
        (lander-empty ?l - lander)

        (where-astronaut ?a - astronaut ?rm - room)
        (assigned-to ?a - astronaut ?l - lander)
        (which-room ?rm - room ?l - lander)
        (is-control-room ?rm - room)
        (is-docking-bay ?rm - room)
    )

    ;-------------------moving astronaut-----------------
    (:action move-astronaut
        :parameters (?a - astronaut ?from - room ?to - room ?l - lander)
        :precondition (and 
            (assigned-to ?a ?l)
            (which-room ?from ?l)
            (which-room ?to ?l)
            (where-astronaut ?a ?from)
        )
        :effect (and 
            (where-astronaut ?a ?to)
            (not (where-astronaut ?a ?from))
        )
    )
    ;---------- --------deploy action-------------------
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
    (:action capture-image
        :parameters (?r - rover ?w - waypoint ?d - data)
        :precondition (and
            (at ?r ?w) ;rover is at waypoint
            (empty-memory ?r) ;rover has empty memory
            (data-target ?d ?w)
        )
        :effect (and
            (not (empty-memory ?r)) ; memory is no longer empty
            (carrying-data ?r ?d) ;rover is now carrying captured data
        )
    )

;---------------sending the captured data back to the base---------------
    (:action transmit-data
        :parameters (?r - rover ?d - data ?l - lander ?a - astronaut ?rm - room)
        :precondition (and
            (belongs-to ?r ?l)  ;transmit data from a specific rover to the assigned lander
            (carrying-data ?r ?d) ;if the rover actually has the data
            (assigned-to ?a ?l)
            (which-room ?rm ?l)
            (is-control-room ?rm)
            (where-astronaut ?a ?rm)
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
            (assigned-to ?a ?l)
            (which-room ?rm ?l)
            (is-docking-bay ?rm)
            (where-astronaut ?a ?rm)
        )
        :effect (and
            (not (carrying-sample ?r ?s))   ;the rover hands over the sample
            (empty-hands ?r)        ;the rover is now empty and free to pick up another sample.
            (not (lander-empty ?l))     ;the lander is not empty after receiving the sample from the rover.
            (sample-storage ?s ?l)      ;goal of storing the sample is a success.
        )
    )

)