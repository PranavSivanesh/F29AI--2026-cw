(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
        rover1 - rover
        lander1 - lander
        wp1 wp2 wp3 wp4 wp5 - waypoint
        img1 scan1 - data
        samp1 - sample
    )

    (:init
        (connected wp1 wp2)
        (connected wp1 wp4)
        (connected wp4 wp3)
        (connected wp2 wp3)
        (connected wp3 wp5)
        (connected wp5 wp1)

        (where-lander lander1 wp4)
        (lander-empty lander1)

        (belongs-to rover1 lander1)
        (empty-memory rover1)
        (empty-hands rover1)

        (sample-at samp1 wp1)

        (data-target img1 wp5)
        (data-target scan1 wp3)
    )

    (:goal
        (and
            (transmitted img1 lander1)
            (transmitted scan1 lander1)
            (sample-storage samp1 lander1)
        )
    )
)