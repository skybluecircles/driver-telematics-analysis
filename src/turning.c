double calculate_turn
(
    double current_angle,
    double prev_angle
);

double calculate_turn
(
    double current,
    double prev
)
{
    double inverse;
    double turn;

    if ( prev >= 0 ) {
        inverse = prev - M_PI;
        if ( current >= inverse ) {
            turn = current - prev;
        }
        else {
            turn = M_PI - prev + M_PI + current;
        }
    }
    else {
        inverse = M_PI + prev;
        if ( current == M_PI ) {
            turn = -M_PI - prev;;
        }
        else if ( current <= inverse ) {
            turn = current - prev;
        }
        else {
            turn = M_PI - current + M_PI + prev;
        }
    }

    if ( turn > M_PI || turn < M_PI * -1) {
        fprintf (
            stderr,
            "The turn between %f and %f was greater or less than pi (%f): %f\n",
            prev,
            current,
            M_PI,
            turn
        );
        exit(1);
    }
    else if ( turn == -M_PI ) {
        turn = M_PI;
    }

    return turn;
}
