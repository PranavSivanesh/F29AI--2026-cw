(define (problem lunar-mission-3)
    (:domain lunar-extended)

;characters for this mission
    (:objects
        rover1 rover2 - rover
        lander1 lander2 - lander
        wp1 wp2 wp3 wp4 wp5 wp6 - waypoint
        imgwp3 imgwp2 scanwp4 scanwp6 - data
        sam1 sam2 - sample
        Alice Bob - astronaut
        db1 cr1 db2 cr2 - room
    )

    ; setting up the waypoints / board before the simulation begins
    (:init
    ; connecting all the waypoints as per figure 3.
        (connected wp1 wp2)
        (connected wp2 wp1)
        (connected wp2 wp3)
        (connected wp3 wp5)
        (connected wp5 wp3)
        (connected wp5 wp6)
        (connected wp6 wp4)
        (connected wp4 wp2)
        (connected wp2 wp4)

        (where-lander lander1 wp2)      ; starting position of lander1
        (lander-empty lander1)          ; defining that lander 1 is empty
        (belongs-to rover1 lander1)     ; assigning rover 1 to lander 1
        (at rover1 wp2)                 ; starting position of rover 1
        (deployed rover1)               ; rover 1 is already deployed
        (empty-memory rover1)           ; rover 1 initially has empty memory and is ready to capture img or scan
        (empty-hands rover1)            ; rover 1's hands are empty and ready to collect samples.)

        (where-lander lander2 wp3)      ; starting position of lander2
        (lander-empty lander2)          ; defining that lander 2 is empty
        (belongs-to rover2 lander2)     ; assigning rover 2 to lander 2
        (empty-memory rover2)           ; rover 2 also has empty memory initially
        (empty-hands rover2)            ; rover 2 also has empty hands initially and is ready to collect samples.

        (assigned-to Alice lander1)     ; Alice assigned to lander 1
        (assigned-to Bob lander2)       ; Bob assiigned to lander 2
        (where-astronaut Alice db1)     ; Alice's starting position is Docking Bay 1 (lander 1)
        (where-astronaut Bob cr2)       ; Bob's starting position is Control Room 2 (lander 2)

        (which-room db1 lander1)        ; linking docking bay 1 to lander 1
        (is-docking-bay db1)            ; defining db1 as Docking Bay
        (which-room cr1 lander1)        ; linking control room 1 to lander 1
        (is-control-room cr1)           ; defining cr1 as Control Room

        (which-room db2 lander2)        ; linking Docking bay 2 to lander 2
        (is-docking-bay db2)            ; defining db2 as Docking bay
        (which-room cr2 lander2)        ; linking Control Room 2 to lander 2
        (is-control-room cr2)           ; defining cr2 as Control Room

        ; defining where the scans and images are located for the mission
        (data-target imgwp3 wp3)
        (data-target scanwp4 wp4)
        (data-target imgwp2 wp2)
        (data-target scanwp6 wp6)

        ; defining where the sample is
        (sample-at sam1 wp5)
        (sample-at sam2 wp2)
    )

    (:goal
        (and
            ; both img and scan from their waypoints is captured and transmitted back to the lander 1
            (transmitted imgwp3 lander1)
            (transmitted scanwp6 lander1)
            (sample-storage sam1 lander1)   ; sample collected is safely stored at the base.

            ; both img and scan from their waypoints is captured and transmitted back to the lander 2.
            (transmitted imgwp2 lander2)
            (transmitted scanwp4 lander2)
            (sample-storage sam2 lander2)   ; sample collected is safely stored at the base.
        )
    )
)