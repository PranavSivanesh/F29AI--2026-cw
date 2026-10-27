(define (problem lunar-mission-1)
    (:domain lunar) ; Links the problem to our base Part 2A domain

    ; characters for this mission
    (:objects
        rover1 - rover
        lander1 - lander
        wp1 wp2 wp3 wp4 wp5 - waypoint
        img1 scan1 - data
        samp1 - sample
    )

; setting up the waypoints / board before the simulation starts
    (:init
        ; Connecting all the waypoints as per figure 2.
        (connected wp1 wp2)
        (connected wp1 wp4)
        (connected wp4 wp3)
        (connected wp2 wp3)
        (connected wp3 wp5)
        (connected wp5 wp1)

        ; defining the starting position of the empty lander 1 at waypoint 4
        (where-lander lander1 wp4)
        (lander-empty lander1)

        ; assigning rover 1 to its respective lander 1 and defining that rover 1 is empty and ready to store imgs and grab rocks.
        (belongs-to rover1 lander1)
        (empty-memory rover1)
        (empty-hands rover1)

        ; defining where the sample is.
        (sample-at samp1 wp1)

        ; defining where the scans and images are located for the mission to be held.
        (data-target img1 wp5)
        (data-target scan1 wp3)
    )

    (:goal
        (and
            ; both img1 and scan1 must be transmitted back to the base
            (transmitted img1 lander1)
            (transmitted scan1 lander1)

            ; sample collected from its waypoint has to be safely stored inside the base
            (sample-storage samp1 lander1)
        )
    )
)