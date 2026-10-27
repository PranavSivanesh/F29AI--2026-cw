(define (problem lunar-mission-3)
    (:domain lunar-extended)

    (:objects
        rover1 rover2 - rover
        lander1 lander2 - lander
        wp1 wp2 wp3 wp4 wp5 wp6 - waypoint
        imgwp3 imgwp2 scanwp4 scanwp6 - data
        sam1 sam2 - sample
        Alice Bob - astronaut
        db1 cr1 db2 cr2 - room
    )

    (:init
        (connected wp1 wp2)
        (connected wp2 wp1)
        (connected wp2 wp3)
        (connected wp3 wp5)
        (connected wp5 wp3)
        (connected wp5 wp6)
        (connected wp6 wp4)
        (connected wp4 wp2)
        (connected wp2 wp4)

        (where-lander lander1 wp2)
        (lander-empty lander1)
        (belongs-to rover1 lander1)
        (at rover1 wp2)
        (deployed rover1)
        (empty-memory rover1)
        (empty-hands rover1)

        (where-lander lander2 wp3)
        (lander-empty lander2)
        (belongs-to rover2 lander2)
        (empty-memory rover2)
        (empty-hands rover2)

        (assigned-to Alice lander1)
        (assigned-to Bob lander2)
        (where-astronaut Alice db1)
        (where-astronaut Bob cr2)

        (which-room db1 lander1)
        (is-docking-bay db1)
        (which-room cr1 lander1)
        (is-control-room cr1)

        (which-room db2 lander2)
        (is-docking-bay db2)
        (which-room cr2 lander2)
        (is-control-room cr2)

        (data-target imgwp3 wp3)
        (data-target scanwp4 wp4)
        (data-target imgwp2 wp2)
        (data-target scanwp6 wp6)

        (sample-at sam1 wp5)
        (sample-at sam2 wp2)
    )

    (:goal
        (and
            (transmitted imgwp3 lander1)
            (transmitted scanwp6 lander1)
            (sample-storage sam1 lander1)

            (transmitted imgwp2 lander2)
            (transmitted scanwp4 lander2)
            (sample-storage sam2 lander2)
        )
    )
)